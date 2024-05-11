import 'package:corenproject/paciente/DetalhesPaciente.dart';
import 'package:corenproject/paciente/addpaciente.dart';
import 'package:corenproject/sign/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacienteScreen extends StatefulWidget {
  @override
  _PacienteScreenState createState() => _PacienteScreenState();
}

class _PacienteScreenState extends State<PacienteScreen> {
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

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (error) {
      print('Erro ao sair da conta: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao sair da conta. Por favor, tente novamente.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _verDetalhesPaciente(
      BuildContext context, QueryDocumentSnapshot<Object?> paciente) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetalhesPaciente(
              paciente: paciente.data() as Map<String, dynamic>)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Lista de Pacientes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () => _signOut(context),
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
          )
        ],
      ),
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
                      var filteredPacientes = snapshot.data!.docs.where((paciente) =>
                          paciente['nome'].toLowerCase().contains(_searchController.text.toLowerCase()));

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
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Card(
                              elevation: 3,
                              child: ListTile(
                                title: Text(
                                  paciente['nome'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                    'Sexo: ${paciente['sexo']}, Idade: ${paciente['idade']}'),
                                onTap: () => _verDetalhesPaciente(context, paciente),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPaciente()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
