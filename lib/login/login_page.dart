import 'dart:convert';
import 'dart:io';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cempro_gps/clave/clave_page.dart';
import 'package:cempro_gps/constantes/url_helper.dart';
import 'package:cempro_gps/home/welcome_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_mac/get_mac.dart';
import 'dart:async';
import 'package:http/http.dart' as httpLogin;
import 'package:rounded_loading_button/rounded_loading_button.dart';

bool checkPass;
bool verpass;

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoginPage> {
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  final TextEditingController _correlativo = TextEditingController();
  final TextEditingController _clave = TextEditingController();

  String _getMacAddress = '';
  void initState() {
    super.initState();
    getMacAddressLogin();
    checkPass = true;
    verpass = true;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    BackButtonInterceptor.add(myInterceptor);
    HttpOverrides.global = new MyHttpOverrides();
  }
  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  Future<String> getMacAddressLogin() async {
    try {
      _getMacAddress = await GetMac.macAddress;
    } on PlatformException {
      _getMacAddress = "Fallo al obtener el nacaddress";
    }
    return _getMacAddress;
  }
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    _salirAPP(context);
    return true;
  }
  Future obtenerPermiso(String correlativo, String permiso) async {
    var miMapPermisos;
    Map datosPermisso = {"correlativo": correlativo};

    var respuestaPermisos = await httpLogin.post(URL_BASE + 'accesosusuario',
        headers: {
          "Accept": "application/json",
          "APP-KEY": APP_KEY,
          "APP-SECRET": APP_SECRET
        },
        body: datosPermisso);

    if(respuestaPermisos.statusCode == 200){
      var mapPermisos = jsonDecode(respuestaPermisos.body);

      for (int i = 0; i < mapPermisos.length; i++) {
        if(mapPermisos[i]['nombre_acceso'] == permiso){
          miMapPermisos = {
              'estado': mapPermisos[i]['estado'],
              'link': mapPermisos[i]['link'],
            };
          // user = mapPermisos[i]['estado'];
          break;
        }
      }
      return jsonEncode(miMapPermisos);
    }
  }

  Future<String> obtenerdatospost(String correlativo, String password, String macAddress) async {
    Map datos = {"correlativo": correlativo, "password": password};
try {
  var respuesta = await httpLogin.post(URL_BASE + 'login',
      headers: {
        "Accept": "application/json",
        "APP-KEY": APP_KEY,
        "APP-SECRET": APP_SECRET
      },
      body: datos);
  print(respuesta.body);
  if (respuesta.statusCode == 200) {
    var map = jsonDecode(respuesta.body);

    if (map.length == 2) {
      _btnController.error();
      _showDialog(context, 'Atención! ', map['mensaje']);
    } else {
      //definir los permisos;
      Timer(Duration(seconds: 3), () {
        _btnController.success();
      });
      var _GPS = jsonDecode(await obtenerPermiso(correlativo, 'Marcaje GPS'));
      var _MARCAJEQR = jsonDecode(
          await obtenerPermiso(correlativo, 'Marcaje QR'));
      var _MARCAJECARNE = jsonDecode(
          await obtenerPermiso(correlativo, 'Marcaje Carné'));
      var _MENSAJES = jsonDecode(await obtenerPermiso(correlativo, 'Mensajes'));
      var _CAMBIARCLAVE = jsonDecode(
          await obtenerPermiso(correlativo, 'Cambiar clave'));
      var _CERRARSESION = jsonDecode(
          await obtenerPermiso(correlativo, 'Cerrar sesión'));
      var _ODH = jsonDecode(await obtenerPermiso(correlativo, 'Servicios ODH'));
      var _EVENTOQR = jsonDecode(
          await obtenerPermiso(correlativo, 'Creación evento QR'));
      var _SAP = jsonDecode(await obtenerPermiso(correlativo, 'SAP Concur'));
      var _NEXO = jsonDecode(await obtenerPermiso(correlativo, 'Nexo'));
      String permisoGPS = _GPS['estado'];
      String permisoQR = _MARCAJEQR['estado'];
      String permisoCARNE = _MARCAJECARNE['estado'];
      String permisoMSJ = _MENSAJES['estado'];
      String permisoCLAVE = _CAMBIARCLAVE['estado'];
      // String permisoSES = _CERRARSESION['estado'];
      String permisoODH = _ODH['estado'];
      String permisoEQR = _EVENTOQR['estado'];
      String permisoSAP = _SAP['estado'];
      String permisoNEXO = _NEXO['estado'];

      String permisoODHURL = _ODH['link'];
      String permisoNEXOURL = _NEXO['link'];
      String permisoSAPUL = _SAP['link'];
      //
      if (correlativo == map[0]['correlativo'] &&
          password != '' &&
          map[0]['rolldispositivio'] == 'app' &&
          macAddress == map[0]['macaddress'] &&
          map[0]['estado'] == "Activo") {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomePage(
                    map[0]['name2'] +
                        ' ' +
                        map[0]['last-name1'],
                    // Eje: Pedro blanco
                    map[0]['id'],
                    map[0]['correlativo'],
                    //Eje: 2324
                    map[0]['rolldispositivio'],
                    //eje: app o web
                    map[0]['name'],
                    permisoGPS,
                    permisoQR,
                    permisoCARNE,
                    permisoMSJ,
                    permisoCLAVE,
                    // permisoSES,
                    permisoODH,
                    permisoEQR,
                    permisoSAP,
                    permisoNEXO,

                    permisoODHURL,
                    permisoNEXOURL,
                    permisoSAPUL,
                  )),
        );
      } //fin if de validar usuario
      else {
        _btnController.error();
        _showDialog(context, 'Atención! ',
            'Tu rol no existe contacta servicio al cliente.');
      }
    }
  } else {
    _btnController.error();
    _showDialog(context, 'Error! ', 'Revise su Disponibilidad de Internet');
  }
  _showDialog(context, 'Error! ', respuesta.body);
}on SocketException catch( e ) {
  _showDialog(context, 'Error! ', e.toString());
  // errorCallback( e.toString() );

}
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
                _btnController.reset();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  TextStyle style = TextStyle(fontFamily: 'Gill');

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      autofocus: true,
      controller: _correlativo,
      textAlign: TextAlign.center,
      obscureText: false,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      // controller: controller,
      style: TextStyle(fontFamily: 'Grill', color: Colors.black, fontSize: 25),
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
          hintStyle: TextStyle(
              fontFamily: 'Grill', color: Colors.black54, fontSize: 25),
          focusColor: Colors.white,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      autofocus: true,
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.next,
      controller: _clave,
      onChanged: (texto) {
        setState(() {
          verpass = checkPass;
          getMacAddressLogin();
        });
      },
      obscureText: verpass,
      style: TextStyle(fontFamily: 'Grill', color: Colors.black, fontSize: 25),
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
          hintStyle: TextStyle(
              fontFamily: 'Grill', color: Colors.black54, fontSize: 25),
          focusColor: Colors.white,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            image: DecorationImage(
              image: AssetImage("assets/bosque.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 250.0,
                ),
                SizedBox(height: 50.0),
                Container(child: emailField),
                SizedBox(height: 40.0),
                passwordField,
                SizedBox(
                  height: 30.0,
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
                              fontSize: 20,
                              fontFamily: 'Grill')),
                      onTap: () {
                        _btnController.reset();
                        // obtenerPermisos(valor.text);
                        setState(() {
                          if (verpass == true) {
                            verpass = false;
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
                  height: 60.0,
                ),
                RoundedLoadingButton(
                  // width: 75.50,
                  height: 60,
                  borderRadius: 75.5,
                  color: Colors.green,
                  controller: _btnController,
                  successColor: Colors.green,
                  onPressed: () {
                    if (_correlativo.text != '' && _clave.text != '') {
                      obtenerdatospost(_correlativo.text, _clave.text, _getMacAddress);
                      // print(_getMacAddress);

                    } else {
                      _btnController.error();
                      _showDialog(
                          context, 'Campos Vacíos', 'Por Favor llenar todos los campos');
                    }
                  },
                  child: Text("Ingresar",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontSize: 22, fontFamily: 'Grill')),
                ),
                SizedBox(
                  height: 25.0,
                ),
                InkWell(
                  child: Text('Recuperar Clave',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Grill')),
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

void limpiarTextController(
    TextEditingController correlativo, TextEditingController clave) {
  correlativo.text = '';
  clave.text = '';
}

//iconos los mensajes

//Que se les pueda dar en negrita

//Tiempo para compilar
void _salirAPP(context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Cerrar APP!", style: TextStyle(fontFamily: 'Gill')),
        content: new Text('Desea Cerrar la APP ??', style: TextStyle(fontFamily: 'Gill')),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Cerrar App", style: TextStyle(fontFamily: 'Gill')),
            onPressed: () {
              exit(0);
            },
          ),
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
