import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final String correlativo;
  ChatScreen(this.correlativo);
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<ChatScreen> {
  var data;
  Future<String> getData(String usuario) async {
    Map datos = {"correlativo": '34'};
    var response = await http.post(
        Uri.encodeFull("http://18.189.26.76:8000/api/mensajesporusuario"),
        body: datos);

    this.setState(() {
      data = json.decode(response.body);
    });

    print(data.length);
    print(data);

    return "Success!";
  }

  @override
  void initState() {
    this.getData(widget.correlativo);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Mensajes"),
        backgroundColor: Colors.lightGreen,
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(200),
                bottomRight: Radius.circular(10))),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                Divider(
                  height: 12.0,
                ),
                ListTile(
                  leading: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: AssetImage('assets/logo.png'),
                    backgroundColor: Colors.white,
                  ),
                  title: Row(
                    children: <Widget>[
                      Text("CEMPRO"),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        'Importante leer',
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                  subtitle: Text(data['mensajedescripcion']),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
