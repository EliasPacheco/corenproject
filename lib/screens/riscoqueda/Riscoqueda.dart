import 'package:corenproject/drawer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RiscoquedaScreen(),
    );
  }
}

class RiscoquedaScreen extends StatefulWidget {
  @override
  _RiscoquedaScreenState createState() => _RiscoquedaScreenState();
}

class _RiscoquedaScreenState extends State<RiscoquedaScreen> {
  bool option1Selected = false;
  bool option2Selected = false;
  bool option3Selected = false;
  bool option4Selected = false;
  bool option5Selected = false;
  bool option6Selected = false;
  bool option7Selected = false;
  bool optionSelected = false;
  bool option8Selected = false;
  bool option9Selected = false;
  bool option10Selected = false;
  bool option11Selected = false;
  bool option12Selected = false;
  bool option13Selected = false;
  bool option14Selected = false;

  String evaluateRisk(int points) {
    if (points >= 0 && points <= 24) {
      return 'Baixo Risco';
    } else if (points >= 25 && points <= 44) {
      return 'Médio Risco\n Colocar pulseira no paciente';
    } else {
      return 'Alto Risco\nColocar pulseira no paciente';
    }
  }

  int calculatePoints() {
    int totalPoints = 0;

    // Se option1Selected for verdadeiro, adicione 25 pontos
    if (option1Selected) {
      totalPoints += 25;
    }

    // Se option2Selected for verdadeiro, adicione 15 pontos
    if (option3Selected) {
      totalPoints += 15;
    }

    if (option6Selected) {
      totalPoints += 15;
    }

    if (option7Selected) {
      totalPoints += 30;
    }

    if (option8Selected) {
      totalPoints += 20;
    }

    if (option11Selected) {
      totalPoints += 10;
    }
    if (option12Selected) {
      totalPoints += 20;
    }
    if (option14Selected) {
      totalPoints += 15;
    }

    return totalPoints;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Risco de Queda e lesões',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      drawer: DrawerScreen(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Histórico de quedas (imediatas ou anteriores)',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Checkbox(
                    value: option1Selected,
                    onChanged: (value) {
                      setState(() {
                        option1Selected = value!;
                        option2Selected = !value;
                      });
                    },
                  ),
                  Text('Sim'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: option2Selected,
                    onChanged: (value) {
                      setState(() {
                        option2Selected = value!;
                        option1Selected = !value;
                      });
                    },
                  ),
                  Text('Não'),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                'Diagnóstico secundário (2 ou mais diagnósticos médicos no prontuário)',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Checkbox(
                    value: option3Selected,
                    onChanged: (value) {
                      setState(() {
                        option3Selected = value!;
                        option4Selected = !value;
                      });
                    },
                  ),
                  Text('Sim'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: option4Selected,
                    onChanged: (value) {
                      setState(() {
                        option4Selected = value!;
                        option3Selected = !value;
                      });
                    },
                  ),
                  Text('Não'),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                'Apoio ambulatorial',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Checkbox(
                    value: option5Selected,
                    onChanged: (value) {
                      setState(() {
                        option5Selected = value!;
                        option6Selected = !value;
                      });
                    },
                  ),
                  Text('Nenhum/repouso na cama/assistência\nde enfermagem'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: option6Selected,
                    onChanged: (value) {
                      setState(() {
                        option6Selected = value!;
                        option5Selected = !value;
                      });
                    },
                  ),
                  Text('Muletas/bengala/andador'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: option7Selected,
                    onChanged: (value) {
                      setState(() {
                        option7Selected = value!;
                        option8Selected = !value;
                      });
                    },
                  ),
                  Text('Mobília'),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                'Terapia intravenosa/fechadura de heparina',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Checkbox(
                    value: option8Selected,
                    onChanged: (value) {
                      setState(() {
                        option8Selected = value!;
                        option7Selected = !value;
                      });
                    },
                  ),
                  Text('Sim'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: option9Selected,
                    onChanged: (value) {
                      setState(() {
                        option9Selected = value!;
                        option8Selected = !value;
                      });
                    },
                  ),
                  Text('Não'),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                'Marcha',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Checkbox(
                    value: option10Selected,
                    onChanged: (value) {
                      setState(() {
                        option10Selected = value!;
                        option11Selected = !value;
                        option12Selected = !value;
                      });
                    },
                  ),
                  Text('Normal/repouso na cama/cadeira de rodas'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: option11Selected,
                    onChanged: (value) {
                      setState(() {
                        option11Selected = value!;
                        option10Selected = !value;
                        option12Selected = !value;
                      });
                    },
                  ),
                  Text('Fraco'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: option12Selected,
                    onChanged: (value) {
                      setState(() {
                        option12Selected = value!;
                        option10Selected = !value;
                        option11Selected = !value;
                      });
                    },
                  ),
                  Text('Comprometido'),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                'Estado mental',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Checkbox(
                    value: option13Selected,
                    onChanged: (value) {
                      setState(() {
                        option13Selected = value!;
                        option14Selected = !value;
                      });
                    },
                  ),
                  Text('Orientado para sua própria capacidade'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: option14Selected,
                    onChanged: (value) {
                      setState(() {
                        option14Selected = value!;
                        option13Selected = !value;
                      });
                    },
                  ),
                  Text('Superestima/esquece limitações'),
                ],
              ),
              Divider(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    int points = calculatePoints();
                    String riskEvaluation = evaluateRisk(points);
                    // Aqui você pode fazer o que quiser com os pontos, como exibi-los em um AlertDialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Pontuação"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total de pontos: $points\n"),
                              Text("Avaliação de Risco: $riskEvaluation"),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Voltar"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Imprimir Pulseira"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text("Calcular"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
