import 'dart:async';
import 'package:corenproject/sign/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
    
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.indigo, Colors.blue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          ),
          
        ),
        child: Stack(
        fit: StackFit.expand,
        children: [
          // Exibindo a imagem desejada (substitua 'sua_imagem.png' pelo caminho da sua imagem)
          Image.asset(
            'assets/coren.png',
            fit: BoxFit.contain,
          ),

          // Indicador de progresso circular
          Positioned(
            bottom: 50.0, // Ajuste a posição vertical conforme necessário
            left: 0,
            right: 0,
            child: Center(
              child: SpinKitCircle(
                color: Colors.white, // Cor do indicador
                size: 70.0, // Tamanho do indicador
              ),
            ),
          ),
        ],
      ),
      )
    );
  }
}
