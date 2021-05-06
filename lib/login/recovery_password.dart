import 'dart:convert';
import 'dart:io';

import 'package:cempro_gps/constantes/url_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class PasswordPage extends StatefulWidget {
  final usuario;
  PasswordPage(this.usuario);

  @override
  _HomePasswordPage createState() => _HomePasswordPage();
}

class _HomePasswordPage extends State<PasswordPage> {
  final TextEditingController newPass = TextEditingController();
  final TextEditingController user = TextEditingController();

  Future<String> savePassword(String usuario, String newPassword) async {
    // String url = 'http://18.189.26.76:8000/api/cambiarclave';
    Map datos = {"name": usuario, "nuevaclve": newPassword};

    var respuesta = await post(
        URL_BASE + 'cambiarclave',
        headers: {
          "Accept": "application/json",
          "APP-KEY": APP_KEY,
          "APP-SECRET": APP_SECRET
        }, body: datos);
    // print(respuesta.body);
    var map = jsonDecode(respuesta.body);
    var mensaje = map['mensaje'];
    if (respuesta.statusCode == 200) {
      if (mensaje == 'Clave actualizada existosamente!') {
        _showDialog(
            context,
            "Clave Actualizada!",
            mensaje +
                '... Para ver los cambios cierre sesión e inicie nuevamente.');
      } else {
        _showDialog(context, "Clave Actualizada!", mensaje);
      }
    } else {
      _showDialog(context, "Error!", "Sin conexión al servidor de marcaciones");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user.text = widget.usuario;
    HttpOverrides.global = new MyHttpOverrides();
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text('Cambiar clave', style: TextStyle(fontFamily:'Gill', fontSize: 25, color: Color.fromRGBO(14, 123, 55, 99.0))),
        backgroundColor: Color.fromRGBO(193, 216, 47, 0.8),
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(200),
                bottomRight: Radius.circular(10))),
      ),
      body: SafeArea(
        bottom: false,
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                  ),
                  Card(
                    elevation: 8.0,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            decoration: InputDecoration(
                                prefixIcon:
                                    Icon(Icons.person, color: Color.fromRGBO(0, 99, 38, 50), size: 30),
                                labelText: "Usuario",
                                labelStyle: TextStyle(color: Color.fromRGBO(0, 99, 38, 50)),
                                enabled: false,
                                hintStyle: TextStyle(color: Color.fromRGBO(84, 87, 89, 50), fontSize: 15, fontFamily: 'Gill'),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 0.0),
                                ),
                                suffixStyle: const TextStyle(color: Color.fromRGBO(0, 99, 38, 50)
                                    )
                            ),
                            controller: user,
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                  hoverColor: Colors.green,
                                  prefixIcon:
                                      Icon(Icons.lock, color: Color.fromRGBO(0, 99, 38, 50), size: 30),
                                  labelText: 'Clave Nueva',
                                  labelStyle: TextStyle(color: Color.fromRGBO(0, 99, 38, 50)),
                                  hintStyle: TextStyle(color: Color.fromRGBO(84, 87, 89, 50), fontSize: 15, fontFamily: 'Gill'),
                                  fillColor: Color.fromRGBO(84, 87, 89, 50),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color.fromRGBO(0, 99, 38, 50)),
                                  ),
                                  helperStyle: TextStyle(
                                      color: Color.fromRGBO(0, 99, 38, 50), fontSize: 13),
                                  suffixStyle:
                                      const TextStyle(color: Color.fromRGBO(0, 99, 38, 50))),
                              keyboardType: TextInputType.text,
                              controller: newPass,
                              cursorColor: Color.fromRGBO(84, 87, 89, 50)
                          ),
                          SizedBox(height: 60.0),
                          MaterialButton(
                              height: 50.0,
                              elevation: 5,
                              minWidth: 300,
                              onPressed: () async {
                                setState(() {
                                  savePassword(widget.usuario, newPass.text);
                                  newPass.text = '';
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              color: Colors.green,
                              disabledElevation: 0,
                              child: Text(
                                'Cambiar clave',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontFamily: 'Gill', fontSize: 20),
                              )),
                          SizedBox(height: 40.0),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ));
}

void _showDialog(context, titulo, contenido) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(titulo, style: TextStyle(fontFamily: 'Gill')),
        content: new Text(contenido, style: TextStyle(fontFamily: 'Gill')),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close", style: TextStyle(fontFamily: 'Gill')),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
