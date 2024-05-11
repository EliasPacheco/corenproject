import 'package:corenproject/drawer.dart';
import 'package:corenproject/screens/cirurgia/CirurgiaScreen.dart';
import 'package:corenproject/screens/comunicacao/ComunicacaoScreen.dart';
import 'package:corenproject/screens/higienizacao/HigienizacaoScreen.dart';
import 'package:corenproject/screens/medicacao/Medicacao.dart';
import 'package:corenproject/screens/paciente/PacienteScreen.dart';
import 'package:corenproject/screens/riscoqueda/Riscoqueda.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      drawer: DrawerScreen(),
      body: ListView(
        children: [
          TopicCard(
            topic: 'Identificação do Paciente',
            image: 'assets/identificacao.jpeg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IdentificacaoScreen()),
              );
            },
          ),
          TopicCard(
            topic: 'Comunicação',
            image: 'assets/comunicacao.jpeg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ComunicacaoScreen()),
              );
            },
          ),
          TopicCard(
            topic: 'Administração de Medicamento',
            image: 'assets/medicacao.jpeg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MedicacaoScreen()),
              );
            },
          ),
          TopicCard(
            topic: 'Cirurgia Segura',
            image: 'assets/seguranca.jpeg',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CirurgiaScreen()));
            },
          ),
          TopicCard(
            topic: 'Higienização das Mãos',
            image: 'assets/higienizacao.jpeg',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HigienizacaoScreen()));
            },
          ),
          TopicCard(
            topic: 'Risco de Queda e lesão por pressão',
            image: 'assets/riscoqueda.jpeg',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RiscoquedaScreen()));
            },
          ),
        ],
      ),
    );
  }
}

class TopicCard extends StatelessWidget {
  final String topic;
  final String image;
  final VoidCallback onTap;

  const TopicCard({
    Key? key,
    required this.topic,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              image,
              fit: BoxFit.cover,
              height: 200.0,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                topic,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}