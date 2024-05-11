import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'dart:io';
import 'package:open_file/open_file.dart' as open_file;

class DetalhesMedicacao extends StatefulWidget {
  final Map<String, dynamic> paciente;

  const DetalhesMedicacao({Key? key, required this.paciente}) : super(key: key);

  @override
  _DetalhesMedicacaoState createState() => _DetalhesMedicacaoState();
}

class _DetalhesMedicacaoState extends State<DetalhesMedicacao> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      _showPotentialIncidentAlert(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prescrição do Paciente',
          style: TextStyle(color: Colors.white),
        ),
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
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200], // Cor de fundo
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem(Icons.person, 'Nome', widget.paciente['nome'],
                  isStatus: false),
              _buildDetailItem(Icons.wc, 'Sexo', widget.paciente['sexo'],
                  isStatus: false),
              _buildDetailItem(
                  Icons.cake, 'Idade', widget.paciente['idade'].toString(),
                  isStatus: false),
              _buildDetailItem(
                  Icons.local_hospital,
                  'Diagnóstico de Enfermagem',
                  widget.paciente['diagnostico_enfermagem'],
                  isStatus: false),
              _buildDetailItem(Icons.local_hospital_sharp,
                  'Diagnóstico do Médico(a)', widget.paciente['diagnostico_medico'],
                  isStatus: false),
              _buildDetailItem(
                  Icons.person_pin, 'Enfermeiro(a)', widget.paciente['enfermeiro(a)'],
                  isStatus: false),
              _buildDetailItem(Icons.medical_information, 'Medicamento',
                  widget.paciente['medicamento'],
                  isStatus: false),
              _buildDetailItem(Icons.circle, 'Status', widget.paciente['status']),
              GestureDetector(
                onTap: () {
                  _showAntibioticoDialog(context);
                },
                child: _buildAntibioticoCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value,
      {bool isStatus = true}) {
    Color color;
    if (isStatus) {
      switch (value.toLowerCase()) {
        case 'entregue':
          color = Colors.green;
          break;
        case 'em separação':
          color = Colors.orange;
          break;
        case 'em andamento':
          color = Colors.blue;
          break;
        case 'potencial incidente':
          color = Colors.red;
          break;
        default:
          color = Colors.yellow;
      }
    } else {
      color = Colors.black;
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Container(
                  constraints: BoxConstraints(maxHeight: 60), // Definindo altura máxima
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3, // Definindo número máximo de linhas
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAntibioticoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.medical_services, size: 24, color: Colors.blue),
          SizedBox(width: 16.0),
          Text(
            'Antibiótico',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Future<void> _showAntibioticoDialog(BuildContext context) async {
    TextEditingController nomeController = TextEditingController();
    TextEditingController doseController = TextEditingController();
    TextEditingController horarioController = TextEditingController();
    TextEditingController quantidadeController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Preencher Informações do Antibiótico'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: nomeController,
                  decoration: InputDecoration(labelText: 'Nome do Antibiótico'),
                ),
                TextFormField(
                  controller: doseController,
                  decoration: InputDecoration(labelText: 'Dose (mg)'),
                ),
                TextFormField(
                  controller: horarioController,
                  decoration: InputDecoration(labelText: 'Horário (X vezes ao dia)'),
                ),
                TextFormField(
                  controller: quantidadeController,
                  decoration: InputDecoration(labelText: 'Quantidade usada em 24 hrs'),
                ),
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
              child: Text('Salvar'),
              onPressed: () {
                // Aqui você pode fazer o que quiser com as informações
                // Por exemplo, enviar para um servidor, salvar localmente, etc.
                print('Nome do Antibiótico: ${nomeController.text}');
                print('Dose: ${doseController.text}');
                print('Horário: ${horarioController.text}');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDownloadConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close dialog!
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

    // Adicionando informações do paciente ao PDF
    pdf.addPage(
      pdfLib.MultiPage(
        build: (pdfLib.Context context) => [
          pdfLib.Header(level: 0, child: pdfLib.Text('Prescrição do Paciente')),
          pdfLib.Header(level: 1, child: pdfLib.Text('Detalhes do Paciente')),
          pdfLib.Paragraph(
            text: 'Nome: ${widget.paciente['nome']}',
          ),
          pdfLib.Paragraph(
            text: 'Sexo: ${widget.paciente['sexo']}',
          ),
          pdfLib.Paragraph(
            text: 'Idade: ${widget.paciente['idade']}',
          ),
          pdfLib.Header(level: 1, child: pdfLib.Text('Diagnósticos')),
          pdfLib.Paragraph(
            text:
                'Diagnóstico de Enfermagem: ${widget.paciente['diagnostico_enfermagem']}',
          ),
          pdfLib.Paragraph(
            text: 'Diagnóstico do Médico(a): ${widget.paciente['diagnostico_medico']}',
          ),
          pdfLib.Header(level: 1, child: pdfLib.Text('Responsável')),
          pdfLib.Paragraph(
            text: 'Enfermeiro(a): ${widget.paciente['enfermeiro(a)']}',
          ),
          pdfLib.Header(level: 1, child: pdfLib.Text('Status')),
          pdfLib.Paragraph(
            text: 'Medicamento: ${widget.paciente['medicamento']}',
          ),
          pdfLib.Paragraph(
            text: 'Status: ${widget.paciente['status']}',
          ),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/prescricao_paciente.pdf");
    await file.writeAsBytes(await pdf.save());
    await open_file.OpenFile.open(file.path); // Aqui está a correção
  }

  Future<void> _showPotentialIncidentAlert(BuildContext context) async {
    if (widget.paciente['status'].toLowerCase() == 'potencial incidente') {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // User must tap button to close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alerta'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('O medicamento losartana não está disponível na via prescrita'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
