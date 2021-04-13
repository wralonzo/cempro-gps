import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cempro_gps/constantes/url_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final String correlativo;
  final String id;
  ChatScreen(this.correlativo, this.id);
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<ChatScreen> {
  var data;
  Future<String> getData(String usuario) async {
    Map datos = {"correlativo": usuario};
    var response = await http.post(URL_BASE + 'mensajesporusuario',
        headers: {
          "Accept": "application/json",
          "APP-KEY": APP_KEY,
          "APP-SECRET": APP_SECRET
        },
        body: datos);

    this.setState(() {
      data = json.decode(response.body);
    });
// print(data.length);
    for (int i = 0; i < data.length; i++) {
      if(data[i]['estado'] == 'Sin lectura'){
        leerMensajes(data[i]['id']);
        // break;
      }
    }

  }
  Future leerMensajes(String idMensaje) async {
    Map datosPermisso = {"id": idMensaje};

    var respuestaPermisos = await http.post(URL_BASE + 'mensajeleidio',
        headers: {
          "Accept": "application/json",
          "APP-KEY": APP_KEY,
          "APP-SECRET": APP_SECRET
        },
        body: datosPermisso);
    // print(respuestaPermisos.body);
  }

  @override
  void initState() {
    this.getData(widget.correlativo);
    // this.leeMensajes(widget.id);
    HttpOverrides.global = new MyHttpOverrides();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Mensajes", style: TextStyle(fontFamily:'Gill', fontSize: 25, color: Color.fromRGBO(14, 123, 55, 99.0))),
        backgroundColor: Color.fromRGBO(193, 216, 47, 0.8),
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
                    backgroundImage: AssetImage('assets/logopro.png'),
                    backgroundColor: Colors.white,
                  ),
                  title: Row(
                    children: <Widget>[
                      Text("Progreso", style: TextStyle(fontSize: 16.0, fontFamily:'Gill')),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        'Importante leer',
                        style: TextStyle(fontSize: 12.0, fontFamily:'Gill'),
                      ),
                    ],
                  ),
                  subtitle: Text(data[index]['descripcion'], style: TextStyle(fontSize: 15.0, fontFamily:'Gill')),
                ),
              ],
            );
            index = index + 1;
          },
        ),
      ),
    );
  }
}
