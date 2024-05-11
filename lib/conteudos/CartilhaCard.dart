import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:corenproject/conteudos/AddCartilha.dart';
import 'package:corenproject/conteudos/CartilhaScreen.dart';
import 'package:corenproject/drawer.dart';
import 'package:flutter/material.dart';


class CartilhaCard extends StatefulWidget {

  @override
  State<CartilhaCard> createState() => _CartilhaCardState();
}

class _CartilhaCardState extends State<CartilhaCard> {
  Connectivity _connectivity = Connectivity();

  bool _temConexaoInternet = true;

  void _monitorarConexao() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _temConexaoInternet = result != ConnectivityResult.none;
      });
    });
  }

  Future<void> _verificarConexaoInternet() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    setState(() {
      _temConexaoInternet = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  void initState() {
    super.initState();
    _verificarConexaoInternet();
    _monitorarConexao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Educação e saúde',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue, // Choose a suitable color
      ),
      drawer: DrawerScreen(
      ),
      body: _temConexaoInternet
          ? CartilhaList()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.signal_wifi_off,
                    size: 50,
                    color: Colors.red,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Sem conexão com a Internet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCartilha(),
                  ),
                );
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ), // Use a suitable icon
              backgroundColor: Colors.blue, // Choose a suitable color
            )
          
    );
  }
}

class CartilhaList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('cartilhas').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        List<DocumentSnapshot> cartilhas = snapshot.data!.docs;

        return ListView.builder(
          itemCount: cartilhas.length,
          itemBuilder: (context, index) {
            return CardWidget(
              documentSnapshot: cartilhas[index],
            );
          },
        );
      },
    );
  }
}

class CardWidget extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;

  CardWidget({required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    String title = documentSnapshot['titulo'];
    String description = documentSnapshot['descricao'];
    String pdfUrl =
        documentSnapshot['pdf'][0]; // Supondo que há apenas um URL de PDF
    String titulo = documentSnapshot['titulo']; // Adicionando o nome do PDF

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CartilhaScreen(
              pdfUrl: pdfUrl,
              titulo: titulo,
            ),
          ),
        );
      },
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.all(16.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 21.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF021F38),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                description,
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
