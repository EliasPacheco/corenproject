import 'package:flutter/material.dart';

class DetalhesPaciente extends StatelessWidget {
  final Map<String, dynamic> paciente;

  const DetalhesPaciente({Key? key, required this.paciente}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Paciente'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200], // Cor de fundo
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem(Icons.person, 'Nome', paciente['nome']),
            _buildDetailItem(Icons.wc, 'Sexo', paciente['sexo']),
            _buildDetailItem(Icons.cake, 'Idade', paciente['idade'].toString()),
            _buildDetailItem(Icons.history, 'Histórico Clínico', paciente['historico_clinico']),
            _buildDetailItem(Icons.warning, 'Alergias', paciente['alergias']),
            _buildDetailItem(Icons.healing, 'Sintomas', paciente['sintomas']),
            _buildDetailItem(Icons.local_hospital, 'Diagnóstico de Enfermagem', paciente['diagnostico_enfermagem']),
            _buildDetailItem(Icons.person_pin, 'Enfermeiro(a)', paciente['enfermeiro(a)']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.0),
              Text(
                value,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
