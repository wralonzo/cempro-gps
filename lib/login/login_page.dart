import 'dart:convert';

import 'package:cempro_gps/cards/usuario_class.dart';
import 'package:cempro_gps/home/welcome_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

String url = "http://18.189.26.76:8000/api/login";
String nombre = '';
String estado ='';


class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;


  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<LoginPage> {
  final TextEditingController valor = TextEditingController();
  final TextEditingController pass = TextEditingController();
  String miUser = '';
  void initState() {
    super.initState();
    // login(valor, pass, context);
  }
  Future<String> obtenerdatospost(String name, String password) async{

    Map datos = {
      "name": name,
      "password": password
    };

    var respuesta = await http.post(url,body: datos );

    // print(respuesta.body);

    Map<String, dynamic> map = jsonDecode(respuesta.body);
    nombre = map['name'];
    estado = map['estado'];
    print(nombre);

  }
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      autofocus: true,
      controller: valor,
      obscureText: false,
      keyboardType: TextInputType.emailAddress,
      // controller: controller,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Usuario",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      autofocus: true,
      controller: pass,
      onChanged: (texto) {
        obtenerdatospost(valor.text, pass.text);
        miUser = valor.text;
        },
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Contraseña",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.green,

      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),

        onPressed: () {

          setState(() {
            if(valor.text == nombre && pass.text != ''){
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomePage(miUser),
                  ));

            }else{
              _showDialog(context, "Error !", "Credenciales Incorrectas");
            }
            valor.text = '';
            pass.text = '';

          });

          },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        body: SingleChildScrollView(

          child: Center(

            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 120.0,
                    ),
                    SizedBox(
                      height: 155.0,
                      child: Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 45.0),
                    emailField,
                    SizedBox(height: 25.0),

                    passwordField,
                    SizedBox(
                      height: 35.0,
                    ),
                    loginButon,
                    SizedBox(
                      height: 15.0,
                    ),
                    SizedBox(
                      height: 200.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

}

void _showDialog(context, titulo, contenido) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(titulo),
        content: new Text(contenido),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
