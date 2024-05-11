import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  Future<void> _cadastrar(BuildContext context) async {
    try {
      final String email = _emailController.text.trim();
      final String senha = _senhaController.text.trim();
      
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      await FirebaseFirestore.instance.collection('enfermeiros').doc(userCredential.user!.uid).set({
        'nome': _nomeController.text.trim(),
        'email': email,
        'admin': false,
      });

      _nomeController.clear();
      _emailController.clear();
      _senhaController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
    } catch (error) {
      print('Erro ao cadastrar: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar. Por favor, tente novamente.')),
      );
    }
  }

  String _capitalize(String input) {
    if (input.isEmpty) return '';
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CadastroForm(
                formKey: _formKey,
                nomeController: _nomeController,
                emailController: _emailController,
                senhaController: _senhaController,
                onCadastrar: () => _cadastrar(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CadastroForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nomeController;
  final TextEditingController emailController;
  final TextEditingController senhaController;
  final VoidCallback onCadastrar;

  const CadastroForm({
    required this.formKey,
    required this.nomeController,
    required this.emailController,
    required this.senhaController,
    required this.onCadastrar,
  });

  @override
  _CadastroFormState createState() => _CadastroFormState();
}

class _CadastroFormState extends State<CadastroForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: widget.nomeController,
            decoration: InputDecoration(
              labelText: 'Nome',
              icon: Icon(Icons.person),
            ),
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor, insira seu nome';
              }
              return null;
            },
          ),
          TextFormField(
            controller: widget.emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              icon: Icon(Icons.email),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor, insira seu email';
              }
              // Adicione validação de email se desejar
              return null;
            },
          ),
          TextFormField(
            controller: widget.senhaController,
            decoration: InputDecoration(
              labelText: 'Senha',
              icon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor, insira sua senha';
              }
              // Adicione validação de senha se desejar
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: widget.onCadastrar,
            child: Text('Cadastrar'),
          ),
        ],
      ),
    );
  }
}
