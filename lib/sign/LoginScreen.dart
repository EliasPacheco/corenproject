import 'package:corenproject/homeadmin/Homescreenadmin.dart';
import 'package:corenproject/homescreen/HomeScreen.dart';
import 'package:corenproject/screens/paciente/PacienteScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false; 

  Future<void> _login(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      
      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor, digite seu email.'), backgroundColor: Colors.red, duration: Duration(seconds: 1),),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (!isValidEmail(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor, digite um email válido.'), backgroundColor: Colors.red, duration: Duration(seconds: 1)),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor, digite sua senha.'), backgroundColor: Colors.red, duration: Duration(seconds: 1)),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Autenticação do usuário com Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Verifica se o usuário é administrador
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('enfermeiros').doc(userCredential.user!.uid).get();
      bool isAdmin = userDoc.exists ? userDoc.get('admin') : false;

      // Navegação para a próxima tela após o login
      if (isAdmin) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => HomeScreenAdmin())));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => HomeScreen())));
      }
    } catch (error) {
      print('Erro ao fazer login: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email ou senha inválidos. Verifique e tente novamente.'), backgroundColor: Colors.red, duration: Duration(seconds: 1)),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool isValidEmail(String email) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo, Colors.lightBlueAccent],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.lock,
                    color: Colors.blueAccent,
                    size: 50,
                  ),
                ),
                SizedBox(height: 30.0),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: !_isPasswordVisible, // Mostrar/ocultar a senha com base na variável _isPasswordVisible
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () => _login(context), // Permitindo clique durante o carregamento
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blueAccent, backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ), // Definindo a cor de fundo do botão como branca
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent))
                      : Text(
                          'Login',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
