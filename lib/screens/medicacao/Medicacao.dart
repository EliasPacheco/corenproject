import 'package:corenproject/drawer.dart';
import 'package:corenproject/screens/medicacao/DetalhesMedicacao.dart';
import 'package:corenproject/screens/paciente/DetalhesPaciente.dart';
import 'package:corenproject/screens/paciente/addpaciente.dart';
import 'package:corenproject/sign/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicacaoScreen extends StatefulWidget {
  @override
  _MedicacaoScreenState createState() => _MedicacaoScreenState();
}

class _MedicacaoScreenState extends State<MedicacaoScreen> {
  TextEditingController _searchController = TextEditingController();
  String? _currentEnfermeiro;
  late Stream<QuerySnapshot> _pacientesStream;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('enfermeiros')
        .doc(uid)
        .get();

    setState(() {
      _currentEnfermeiro = snapshot.get('nome');
    });

    // Recupera todos os pacientes do Firestore
    _pacientesStream = FirebaseFirestore.instance
        .collection('pacientes')
        .where('enfermeiro(a)', isEqualTo: _currentEnfermeiro)
        .snapshots();
  }

  void _verDetalhesPaciente(
      BuildContext context, QueryDocumentSnapshot<Object?> paciente) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetalhesMedicacao(
              paciente: paciente.data() as Map<String, dynamic>)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Medicação dos Pacientes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      drawer: DrawerScreen(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar Paciente',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: _currentEnfermeiro != null
                ? StreamBuilder(
                    stream: _pacientesStream,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Erro: ${snapshot.error}'),
                        );
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            'Nenhum paciente encontrado',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }

                      // Filtra localmente os pacientes pelo nome
                      var filteredPacientes = snapshot.data!.docs.where(
                          (paciente) => paciente['nome']
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()));

                      if (filteredPacientes.isEmpty) {
                        return Center(
                          child: Text(
                            'Nenhum paciente encontrado',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredPacientes.length,
                        itemBuilder: (context, index) {
                          var paciente = filteredPacientes.elementAt(index);
                          Color statusColor = Colors
                              .grey; // Cor padrão para pacientes sem status definido

                          // Acessando os dados do paciente corretamente
                          Map<String, dynamic>? pacienteData =
                              paciente.data() as Map<String, dynamic>?;

                          // Verificando se o paciente possui o campo 'status' e determinando a cor com base nele
                          if (pacienteData != null &&
                              pacienteData.containsKey('status')) {
                            switch (pacienteData['status'].toLowerCase()) {
                              case 'entregue':
                                statusColor = Colors.green;
                                break;
                              case 'em separação':
                                statusColor = Colors.orange;
                                break;
                              case 'em andamento':
                                statusColor = Colors.blue;
                                break;
                              case 'potencial incidente':
                                statusColor = Colors.red;
                                break;
                              default:
                                statusColor = Colors.grey;
                            }
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Card(
                              elevation: 3,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: statusColor,
                                  child: Text(
                                    pacienteData != null &&
                                            pacienteData.containsKey('status')
                                        ? pacienteData['status']
                                            .toString()
                                            .substring(0, 1)
                                            .toUpperCase()
                                        : '?', // Usando '?' se o status não estiver definido
                                  ),
                                ),
                                title: Text(
                                  pacienteData?['nome'] ??
                                      'Nome Indefinido', // Acessando o nome do paciente e tratando caso seja nulo
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                    'Sexo: ${pacienteData?['sexo'] ?? 'Indefinido'}, Idade: ${pacienteData?['idade'] ?? 'Indefinida'}'), // Acessando o sexo e idade do paciente e tratando caso sejam nulos
                                onTap: () =>
                                    _verDetalhesPaciente(context, paciente),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
    );
  }
}
