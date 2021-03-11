import 'dart:convert';
import 'package:cempro_gps/clave/clave_page.dart';
import 'package:cempro_gps/home/welcome_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_mac/get_mac.dart';
import 'dart:async';
import 'package:http/http.dart' as httpLogin;

String urlLogin = "http://18.189.26.76:8000/api/login";
String nombre = '';
String clave = '';
String estado = '';
String _loginMac = '';
String macAddress = '';
String correlativo = '';
bool checkPass;
bool verpass;
var respuesta;
String correlativoLogin = '';
int idUsuarioLogin = 0;
String rol = '';
String nombreUsuario = '';

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

    getMacAddressLogin();

    checkPass = true;
    verpass = true;
    // obtenerdatospost(valor.text, pass.text);
  }

  DateTime backbuttonpressedTime;
  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    //bifbackbuttonhasnotbeenpreedOrToasthasbeenclosed
    //Statement 1 Or statement2
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 4);

    if (backButton) {
      backbuttonpressedTime = currentTime;
      _showDialog(context, "SALIR", "Desea Cerrar la Aplicación");
      return false;
    }
    return true;
  }

  Future<String> obtenerdatospost(String name, String password) async {
    Map datos = {"correlativo": name, "password": password};

    respuesta = await httpLogin.post(urlLogin, body: datos);
    // print(respuesta.body);
    var map = jsonDecode(respuesta.body);
    idUsuarioLogin = map[0]['id'];
    nombre = map[0]['name'];
    correlativoLogin = map[0]['correlativo'];
    macAddress = map[0]['macaddress'];
    estado = map[0]['estado'];
    rol = map[0]['rolldispositivio'];
    nombreUsuario = map[0]['name2'] + ' ' + map[0]['last-name1'];
  }

  TextStyle style = TextStyle(fontFamily: 'Montserrat');

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      autofocus: true,
      controller: valor,
      textAlign: TextAlign.center,
      obscureText: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      // controller: controller,
      style: TextStyle(
          fontFamily: 'Montserrat', color: Colors.black, fontSize: 25),
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Correlativo',
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          ),
          // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          // hintText: "Clave",
          hintStyle: TextStyle(
              fontFamily: 'Montserrat', color: Colors.black, fontSize: 25),
          focusColor: Colors.white,
          // focusedBorder: UnderlineInputBorder(
          //   borderSide: BorderSide(color: Colors.white),
          // ),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      autofocus: true,
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.next,
      controller: pass,
      onChanged: (texto) {
        miUser = valor.text;
        setState(() {
          verpass = checkPass;
          obtenerdatospost(valor.text, pass.text);
          print(_loginMac);
          print('mac');
          print(macAddress);
        });
      },
      obscureText: verpass,
      style: TextStyle(
          fontFamily: 'Montserrat', color: Colors.black, fontSize: 25),
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Clave',
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          ),
          // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          // hintText: "Clave",
          hintStyle: TextStyle(
              fontFamily: 'Montserrat', color: Colors.black, fontSize: 25),
          focusColor: Colors.white,
          // focusedBorder: UnderlineInputBorder(
          //   borderSide: BorderSide(color: Colors.white),
          // ),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButon = Material(
      borderRadius: BorderRadius.circular(30.0),
      color: Color.fromARGB(230, 68, 173, 52),
      child: MaterialButton(
        minWidth: 400.0,
        height: 60,
        // minWidth: MediaQuery.of(context).size.width,
        // padding: EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 15.0),
        onPressed: () {
          setState(() {
            // obtenerdatospost(valor.text, pass.text);
            if (valor.text == correlativoLogin &&
                pass.text != '' &&
                _loginMac == macAddress &&
                estado == "activo") {
              // if(valor.text != '' && pass.text != ''){
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                // builder: (context) => HomePage('willian', 3212, '3213', 'admin', 'Willian'),
              ));
            } else {
              _showDialog(context, "Error !", "Credenciales Incorrectas");
              // obtenerdatospost(valor.text, pass.text);
            }
            valor.text = '';
            pass.text = '';
          });
        },
        child: Text("Ingresar",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat')),
      ),
    );

    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            image: DecorationImage(
                image: AssetImage("assets/bosque.jpg"), fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 25.0,
                ),
                SizedBox(
                  height: 75.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/progreso.png",
                        fit: BoxFit.contain,
                      ),
                      Text(' Progeso',
                          style: TextStyle(color: Colors.white, fontSize: 50)),
                    ],
                  ),
                ),
                SizedBox(height: 60.0),
                Text('BIENVENIDO',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 50, color: Colors.white)),
                SizedBox(height: 50.0),
                emailField,
                SizedBox(height: 40.0),
                passwordField,
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("     "),
                    InkWell(
                      child: Text('Mostrar Clave',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat')),
                      onTap: () {
                        // obtenerPermisos(valor.text);
                        setState(() {
                          if (verpass == true) {
                            verpass = false;
                            print(valor.text);
                          } else {
                            verpass = true;
                          }
                        });
                      },
                    ),
                    Text('   '),
                    Container(
                      // color: Colors.white,
                      width: 25,
                      height: 25,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 3.0, color: Colors.white),
                          left: BorderSide(width: 3.0, color: Colors.white),
                          right: BorderSide(width: 3.0, color: Colors.white),
                          bottom: BorderSide(width: 3.0, color: Colors.white),
                        ),
                      ),

                      child: Checkbox(
                        focusColor: Colors.green,
                        checkColor: Colors.white,
                        hoverColor: Colors.green,
                        activeColor: Colors.green,
                        value: checkPass,
                        onChanged: (bool newValue) {
                          obtenerdatospost(valor.text, pass.text);

                          setState(() {
                            checkPass = newValue;
                            verpass = checkPass;
                          });
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 70.0,
                ),
                loginButon,
                SizedBox(
                  height: 25.0,
                ),
                InkWell(
                  child: Text('Recuperar Clave',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat')),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ClavePage();
                        },
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 200.0,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
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

Future<String> getMacAddressLogin() async {
  String macAddress;
  try {
    macAddress = await GetMac.macAddress;
  } on PlatformException {
    macAddress = "Fallo al obtener el nacaddress";
  }
  _loginMac = macAddress;
  return _loginMac;
}

class Permisos {
  String studentId;
  String studentName;
  int studentScores;

  Permisos({this.studentId, this.studentName, this.studentScores});
}

Future<String> _loadAStudentAsset() async {
  return await rootBundle
      .loadString('https://8.189.26.76:8000/api/accesosusuario');
}
