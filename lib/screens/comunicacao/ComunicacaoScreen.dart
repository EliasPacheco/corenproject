import 'package:corenproject/drawer.dart';
import 'package:corenproject/screens/comunicacao/Chatscreen.dart';
import 'package:flutter/material.dart';

class ComunicacaoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Comunicação',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: DrawerScreen(),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildCard('Médico Prescritor', Icons.local_hospital, Colors.blue, context),
          _buildCard('Enfermeira Estomaterapeuta', Icons.people, Colors.green, context),
          _buildCard('Nutricionista', Icons.local_dining, Colors.orange, context),
          _buildCard('Fisioterapeuta', Icons.directions_walk, Colors.red, context),
          _buildCard('Psicólogo', Icons.psychology, Colors.purple, context),
          _buildCard('Farmacêutico', Icons.local_pharmacy, Colors.indigo, context),
          _buildCard('Terapeuta Ocupacional', Icons.work, Colors.brown, context),
          _buildCard('Fonoaudiólogo', Icons.record_voice_over, Colors.teal, context),
          _buildCard('Setor de exames', Icons.assignment, Colors.blue, context),
          _buildCard('Ouvidoria do paciente', Icons.hearing, Colors.green, context),
        ],
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, Color color, BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: color,
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          // Navegar para a tela de chat
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        },
      ),
    );
  }
}

