import 'package:corenproject/drawer.dart';
import 'package:flutter/material.dart';

class CirurgiaScreen extends StatefulWidget {
  @override
  _CirurgiaScreenState createState() => _CirurgiaScreenState();
}

class _CirurgiaScreenState extends State<CirurgiaScreen> {
  List<String> tasks = [
    'Recursos inerentes anestesia',
    'Recursos inerentes aos procedimentos da enfermagem no perioperatório',
    'Recursos instrumentais para a cirurgia',
    'Adequabilidade do centro cirúrgico e da sala de cirurgia',
  ];

  List<bool> taskCompleted = [false, false, false, false];

  void _toggleTask(int index) {
    setState(() {
      taskCompleted[index] = !taskCompleted[index];
      if (taskCompleted.every((bool task) => task == true)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Cirurgia Segura"),
              content: Text(
                  "Todas as tarefas concluídas. Você pode realizar a cirurgia."),
              actions: <Widget>[
                ElevatedButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checklist Cirurgia',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: DrawerScreen(),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4.0,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(
                tasks[index],
                style: TextStyle(
                  decoration: taskCompleted[index]
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              trailing: IconButton(
                icon: taskCompleted[index]
                    ? Icon(Icons.check_box)
                    : Icon(Icons.check_box_outline_blank),
                onPressed: () {
                  _toggleTask(index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
