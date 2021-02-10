import 'dart:convert';
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
String estado ='';
String _loginMac = '';
String macAddress = '' ;
bool checkPass = true;
bool verpass = false;
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
    // obtenerdatospost(valor.text, pass.text);
  }
  Future<String> obtenerdatospost(String name, String password) async{

    Map datos = {
      "name": name,
      "password": password
    };

    respuesta = await httpLogin.post(urlLogin, body: datos );
    // print(respuesta.body);
    var map = jsonDecode(respuesta.body);
    idUsuarioLogin    = map[0]['id'];
    nombre            = map[0]['name'];
    correlativoLogin  = map[0]['correlativo'];
    macAddress        = map[0]['macaddress'];
    estado            = map[0]['estado'];
    rol               = map[0]['rolldispositivio'];
    nombreUsuario     = map[0]['name2']+' '+map[0]['last-name1'];
  }
  TextStyle style = TextStyle(fontFamily: 'Montserrat', color: Colors.white);

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      autofocus: true,
      controller: valor,
      textAlign: TextAlign.center,
      obscureText: false,
      keyboardType: TextInputType.emailAddress,
      // controller: controller,
      style: TextStyle(fontFamily: 'Montserrat', color: Colors.white, fontSize: 25),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Usuario",
          hintStyle: TextStyle(fontSize: 25, color: Colors.white),
          focusColor: Colors.white,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      autofocus: true,
        textAlign: TextAlign.center,
      controller: pass,
      onChanged: (texto) {

        miUser = valor.text;
        setState(() {
          verpass = checkPass;
          obtenerdatospost(valor.text, pass.text);
        });
        },
      obscureText: verpass,
      style: TextStyle(fontFamily: 'Montserrat', color: Colors.white, fontSize: 25),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Clave",
          hintStyle: TextStyle(fontSize: 25, color: Colors.white),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)))
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.green[800],

      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),

        onPressed: () {
          setState(() {
            // obtenerdatospost(valor.text, pass.text);
            print(_loginMac);
            if(valor.text == nombre && pass.text != '' && _loginMac == macAddress && estado == "activo"){
            // if(valor.text != '' && pass.text != ''){


              Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomePage(miUser, idUsuarioLogin, correlativoLogin, rol, nombreUsuario),
                  ));

            }else{
              _showDialog(context, "Error !", "Credenciales Incorrectas");
              // obtenerdatospost(valor.text, pass.text);
            }
            valor.text = '';
            pass.text = '';

          });

          },
        child: Text("Ingresar",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white)),
      ),
    );

    return Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                  image: DecorationImage(
                  image: AssetImage("assets/bosque.jpg"),
                  fit: BoxFit.cover
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 50.0,
                    ),
                    SizedBox(
                      height: 155.0,
                      child: Image.asset(
                        "assets/progreso.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Text('Bienvenido', style: TextStyle(fontSize: 50, color: Colors.white)),
                    SizedBox(height: 25.0),
                    emailField,
                    SizedBox(height: 25.0),

                    passwordField,
                    SizedBox(
                      height: 35.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Mostrar Clave', textAlign: TextAlign.center,
                            style: style.copyWith(
                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        // icon: Icon(Icons.set_meal_sharp),
                        Checkbox(
                          activeColor: Colors.lightGreen,

                          value: checkPass,
                          onChanged: (bool newValue) {
                            obtenerdatospost(valor.text, pass.text);
                            setState(() {
                              checkPass = newValue;
                              verpass = checkPass;
                              print(nombre);
                              print(macAddress);
                              print(estado);
                              print(rol);
                            });
                          },
                        ),
                      ],
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
Future<String> getMacAddressLogin() async {
  String macAddress;
  try{
    macAddress = await GetMac.macAddress;
  }on PlatformException{
    macAddress = "Fallo al obtener el nacaddress";
  }
  _loginMac = macAddress;
  return _loginMac;
}
