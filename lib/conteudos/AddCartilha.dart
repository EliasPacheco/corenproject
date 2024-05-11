import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:intl/intl.dart';

class AddCartilha extends StatefulWidget {
  @override
  _AddCartilhaState createState() => _AddCartilhaState();
}

class _AddCartilhaState extends State<AddCartilha> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  List<PlatformFile>? _files;
  String? _tituloError;
  String? _descricaoError;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _tituloController.addListener(_clearTitleError);
    _descricaoController.addListener(_clearDescriptionError);
  }

  @override
  void dispose() {
    _tituloController.removeListener(_clearTitleError);
    _descricaoController.removeListener(_clearDescriptionError);
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _clearTitleError() {
    setState(() {
      _tituloError = null;
    });
  }

  void _clearDescriptionError() {
    setState(() {
      _descricaoError = null;
    });
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _files = result.files;
        });
      }
    } catch (e) {
      print('Erro ao selecionar arquivos: $e');
    }
  }

  Future<void> _enviarParaFirestore() async {
    try {
      setState(() {
        _sending = true;
      });

      String titulo = _tituloController.text;
      String descricao = _descricaoController.text;
      List<String?> urls = [];

      for (var file in _files ?? []) {
        var url = await _uploadArquivo(file);
        if (url != null) {
          urls.add(url);
        }
      }

      String dataEnvio = DateFormat('dd/MM/yyyy').format(DateTime.now());

      await FirebaseFirestore.instance.collection('cartilhas').add({
        'titulo': titulo,
        'descricao': descricao,
        'pdf': urls,
        'data_envio': dataEnvio,
      });

      setState(() {
        _files = null;
        _tituloController.clear();
        _descricaoController.clear();
        _sending = false;
      });

      Navigator.of(context).pop();
    } catch (e) {
      print('Erro ao enviar dados para o Firestore: $e');
      setState(() {
        _sending = false;
      });
    }
  }

  Future<String?> _uploadArquivo(PlatformFile file) async {
    try {
      if (file == null || file.path == null) {
        print('Arquivo ou caminho do arquivo nulo. O arquivo será ignorado.');
        return null;
      }

      File localFile = File(file.path!);

      if (!localFile.existsSync()) {
        print(
            'Arquivo não encontrado para ${file.name}. O arquivo será ignorado.');
        return null;
      }

      List<int> bytes = await localFile.readAsBytes();

      if (bytes.isEmpty) {
        print(
            'Bytes do arquivo são vazios para ${file.name}. O arquivo será ignorado.');
        return null;
      }

      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('cartilhas')
          .child('${DateTime.now().millisecondsSinceEpoch}_${file.name}');

      firebase_storage.UploadTask uploadTask =
          storageReference.putData(Uint8List.fromList(bytes));

      await uploadTask;

      String downloadUrl = await storageReference.getDownloadURL();

      if (downloadUrl != null) {
        return downloadUrl;
      } else {
        print('URL de download nula após o upload do arquivo.');
        return null;
      }
    } catch (e) {
      print('Erro ao fazer upload do arquivo: $e');
      return null;
    }
  }

  List<Widget> _buildFileList() {
    if (_files?.isNotEmpty ?? false) {
      return _files!.map<Widget>((file) {
        return Row(
          children: [
            Expanded(
              child: Text(file.name ?? ''),
            ),
            IconButton(
              icon: Icon(Icons.clear),
              color: Colors.red,
              onPressed: () {
                setState(() {
                  _files!.remove(file);
                });
              },
            ),
          ],
        );
      }).toList();
    }

    return [Container()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Adicionar Cartilha', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF021F38),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                  errorText: _tituloError,
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      _tituloError = 'Por favor, insira o título';
                    });
                    return null;
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descricaoController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                  errorText: _descricaoError,
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      _descricaoError = 'Por favor, insira a descrição';
                    });
                    return null;
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: () {
                  _pickFiles();
                },
                icon: Icon(Icons.attach_file),
                label: Text('Adicionar Cartilha'),
              ),
              SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildFileList(),
              ),
              SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: _sending
                    ? null
                    : () {
                        if (_formKey.currentState!.validate() &&
                            _files != null &&
                            _files!.isNotEmpty) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Dados do Formulário'),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Título: ${_tituloController.text}'),
                                    Text(
                                        'Descrição: ${_descricaoController.text}'),
                                    if (_files != null)
                                      Text(
                                          'Arquivos: ${_files!.map((file) => file.name).join(", ")}'),
                                  ],
                                ),
                                actions: [
                                  if (!_sending)
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancelar'),
                                    ),
                                  ElevatedButton.icon(
                                    onPressed: _sending
                                        ? null
                                        : () {
                                            _enviarParaFirestore();
                                            Navigator.pop(context);
                                          },
                                    icon: _sending
                                        ? CircularProgressIndicator(
                                            color: Colors.white)
                                        : Icon(Icons.send),
                                    label: Text('Enviar'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Por favor, preencha todos os campos e anexe pelo menos um documento.',
                              ),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                icon: _sending
                    ? CircularProgressIndicator(color: Colors.white)
                    : Icon(Icons.send),
                label: Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
