import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importe o pacote FirebaseAuth

class AddPaciente extends StatefulWidget {
  const AddPaciente({Key? key}) : super(key: key);

  @override
  State<AddPaciente> createState() => _AddPacienteState();
}

class _AddPacienteState extends State<AddPaciente> {
  String _selectedGender = 'Masculino';
  List<String> _genders = ['Masculino', 'Feminino'];

  // Controladores para os campos de texto
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _clinicalHistoryController = TextEditingController();
  TextEditingController _allergiesController = TextEditingController();
  TextEditingController _symptomsController = TextEditingController();
  TextEditingController _nursingDiagnosisController = TextEditingController();
  TextEditingController _enfermeiroController = TextEditingController();
  TextEditingController _leitoController = TextEditingController();

  // Referência para a coleção "enfermeiros" no Firestore
  CollectionReference _enfermeirosRef = FirebaseFirestore.instance.collection('enfermeiros');

  // Função para buscar e definir o nome do enfermeiro atual
  Future<void> _getEnfermeiro() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var enfermeiroDoc = await _enfermeirosRef.doc(user.uid).get();
      var enfermeiroNome = enfermeiroDoc.get('nome');
      setState(() {
        _enfermeiroController.text = enfermeiroNome;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getEnfermeiro(); // Chame a função no initState para obter o nome do enfermeiro ao iniciar a tela
  }

  // Função para salvar os dados no Firestore
  Future<void> _salvarPaciente() async {
    try {
      await FirebaseFirestore.instance.collection('pacientes').add({
        'nome': _nameController.text,
        'sexo': _selectedGender,
        'idade': int.parse(_ageController.text),
        'historico_clinico': _clinicalHistoryController.text,
        'alergias': _allergiesController.text,
        'sintomas': _symptomsController.text,
        'diagnostico_enfermagem': _nursingDiagnosisController.text,
        'leito_paciente': _leitoController.text,
        'enfermeiro(a)': _enfermeiroController.text, // Use o nome do enfermeiro(a) atual
      });

      // Limpar os campos após salvar
      _nameController.clear();
      _ageController.clear();
      _clinicalHistoryController.clear();
      _allergiesController.clear();
      _symptomsController.clear();
      _nursingDiagnosisController.clear();
      _leitoController.clear();

      // Feedback de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Paciente salvo com sucesso')),
      );
    } catch (e) {
      // Lidar com erros
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar paciente')),
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
        centerTitle: true,
        title: Text(
          'Adicionar Paciente', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words, // Capitalizar a primeira letra de cada palavra
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField(
              value: _selectedGender,
              items: _genders.map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value.toString();
                });
              },
              decoration: InputDecoration(
                labelText: 'Sexo',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: 'Idade',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _leitoController,
              decoration: InputDecoration(
                labelText: 'Leito',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _clinicalHistoryController,
              decoration: InputDecoration(
                labelText: 'Histórico Clínico',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _allergiesController,
              decoration: InputDecoration(
                labelText: 'Alergias',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _symptomsController,
              decoration: InputDecoration(
                labelText: 'Sintomas',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _nursingDiagnosisController,
              decoration: InputDecoration(
                labelText: 'Possíveis Diagnósticos de Enfermagem',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _enfermeiroController,
              decoration: InputDecoration(
                labelText: 'Enfermeiro(a)',
                border: OutlineInputBorder(),
              ),
              enabled: false, // Desabilitar edição do campo
            ),
            SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _salvarPaciente, // Chamar a função de salvar
                child: Text('Salvar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose os controladores quando não forem mais necessários
    _nameController.dispose();
    _ageController.dispose();
    _clinicalHistoryController.dispose();
    _allergiesController.dispose();
    _symptomsController.dispose();
    _nursingDiagnosisController.dispose();
    _enfermeiroController.dispose();
    _leitoController.dispose();
    super.dispose();
  }
}
