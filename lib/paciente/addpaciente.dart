import 'package:flutter/material.dart';

class AddPaciente extends StatefulWidget {
  const AddPaciente({super.key});

  @override
  State<AddPaciente> createState() => _AddPacienteState();
}

class _AddPacienteState extends State<AddPaciente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add Paciente',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}