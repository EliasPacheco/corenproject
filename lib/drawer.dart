import 'package:corenproject/conteudos/CartilhaCard.dart';
import 'package:corenproject/homescreen/HomeScreen.dart';
import 'package:corenproject/screens/cirurgia/CirurgiaScreen.dart';
import 'package:corenproject/screens/comunicacao/ComunicacaoScreen.dart';
import 'package:corenproject/screens/higienizacao/HigienizacaoScreen.dart';
import 'package:corenproject/screens/medicacao/Medicacao.dart';
import 'package:corenproject/screens/paciente/PacienteScreen.dart';
import 'package:corenproject/screens/riscoqueda/Riscoqueda.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:corenproject/sign/LoginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  late String _currentUserName = ''; // Inicialize como uma string vazia

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Carrega o nome do usuário quando o drawer é aberto pela primeira vez
  }

  Future<void> _loadUserName() async {
    // Verifica se o nome do usuário já foi carregado antes
    if (_currentUserName.isEmpty) {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('enfermeiros')
          .doc(uid)
          .get();

      setState(() {
        _currentUserName = snapshot.get('nome');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá, $_currentUserName!', // Agora podemos usar diretamente o nome do usuário salvo
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home), // Ícone para a opção Home
            title: Text('Home'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.person), // Ícone para a opção Identificação
            title: Text('Identificação'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => IdentificacaoScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.chat), // Ícone para a opção Comunicação
            title: Text('Comunicação'),
            onTap: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => ComunicacaoScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.medication), // Ícone para a opção Medicamentos
            title: Text('Medicamentos'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MedicacaoScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.local_hospital), // Ícone para a opção Cirurgia
            title: Text('Cirurgia'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CirurgiaScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.cleaning_services), // Ícone para a opção Higienização
            title: Text('Higienização'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HigienizacaoScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.warning), // Ícone para a opção Risco de Queda
            title: Text('Risco de Queda'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RiscoquedaScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark), // Ícone para a opção Risco de Queda
            title: Text('Educação e saúde'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CartilhaCard()));
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red,), // Ícone para a opção Sair
            title: Text('Sair', style: TextStyle(color: Colors.red),),
            onTap: () {
              _signOut(context);
            },
          ),
        ],
      ),
    );
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
}
