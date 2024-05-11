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
  List<String> _users = [
    'Usuário 1',
    'Usuário 2',
    'Usuário 3',
    'Usuário 4',
    'Usuário 5',
    'Usuário 6',
  ];
  List<String> _filteredUsers = [];
  bool _isAdmin = false; // Defina isso com base nos dados do usuário

  @override
  void initState() {
    _filteredUsers.addAll(_users);
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('enfermeiros')
        .doc(uid)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      setState(() {
        _isAdmin = userData['admin'] ?? false;
      });
    }
  }

  void _filterUsers(String query) {
    List<String> filteredList = [];
    if (query.isNotEmpty) {
      _users.forEach((user) {
        if (user.toLowerCase().contains(query.toLowerCase())) {
          filteredList.add(user);
        }
      });
    } else {
      filteredList.addAll(_users);
    }
    setState(() {
      _filteredUsers.clear();
      _filteredUsers.addAll(filteredList);
    });
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
        SnackBar(content: Text('Erro ao sair da conta. Por favor, tente novamente.',), backgroundColor: Colors.red,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Lista de Usuários',
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
                ))
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Pesquisar',
                  hintText: 'Digite o nome do usuário',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: _filterUsers,
              ),
            ),
            Expanded(
              child: _filteredUsers.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhum usuário encontrado',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredUsers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 5.0,
                          ),
                          child: ListTile(
                            title: Text(_filteredUsers[index]),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddPaciente()));
          },
          child: Icon(Icons.add),
        ));
  }
}
