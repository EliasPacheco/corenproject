import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'dart:io';
import 'package:open_file/open_file.dart' as open_file;

class DetalhesPaciente extends StatelessWidget {
  final Map<String, dynamic> paciente;

  const DetalhesPaciente({Key? key, required this.paciente}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Paciente', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              _showDownloadConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200], // Fundo
        ),
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem(Icons.person, 'Nome', paciente['nome']),
              _buildDetailItem(Icons.wc, 'Sexo', paciente['sexo']),
              _buildDetailItem(Icons.wc, 'Data de Nascimento', paciente['data_nascimento']),
              _buildDetailItem(Icons.cake, 'Idade', paciente['idade'].toString()),
              _buildDetailItem(Icons.history, 'Histórico Clínico', paciente['historico_clinico']),
              _buildDetailItem(Icons.warning, 'Alergias', paciente['alergias']),
              _buildDetailItem(Icons.healing, 'Sintomas', paciente['sintomas']),
              _buildDetailItem(Icons.bed, 'Leito', paciente['leito_paciente']),
              _buildDetailItem(Icons.local_hospital, 'Diagnóstico de Enfermagem', paciente['diagnostico_enfermagem']),
              _buildDetailItem(Icons.person_pin, 'Enfermeiro(a)', paciente['enfermeiro(a)']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3), // Sombra
          ),
        ],
      ),
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Título
              ),
              SizedBox(height: 4.0),
              Text(
                value,
                style: TextStyle(fontSize: 16), // Texto
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showDownloadConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Baixar como PDF'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Deseja baixar este conteúdo como PDF?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Baixar'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _savePdf(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _savePdf(BuildContext context) async {
    final pdf = pdfLib.Document();

    // Criando uma tabela com as informações do paciente
    final table = pdfLib.Table.fromTextArray(
      headers: ['Indentificação', 'Paciente'],
      data: [
        ['Nome', paciente['nome']],
        ['Sexo', paciente['sexo']],
        ['Data de Nascimento', paciente['data_nascimento']],
        ['Leito do Paciente', paciente['leito_paciente']],
        ['Idade', paciente['idade'].toString()],
      ],
    );

    pdf.addPage(pdfLib.Page(build: (pdfLib.Context context) {
      return pdfLib.Center(
        child: table,
      );
    }));

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/detalhes_paciente.pdf");
    await file.writeAsBytes(await pdf.save());
    await open_file.OpenFile.open(file.path);
  }
}
