import 'dart:async';
import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cempro_gps/constantes/url_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:intl/intl.dart';

class BarcodePage extends StatefulWidget {
  final String usuario;
  final int idUsuario;
  final String Correlativo;
  BarcodePage(this.usuario, this.idUsuario, this.Correlativo);
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<BarcodePage> {
  String barcode = "";
  Map<String, String> map1;
  int contador = 0;
  Position positionHere;

  void _getLocationHereCodeBar() async {
    positionHere = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  initState() {
    super.initState();
    _getLocationHereCodeBar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text('Marcaje Carné', style: TextStyle(
        fontFamily:'Gill', fontSize: 25, color: Color.fromRGBO(14, 123, 55, 99.0))),
          backgroundColor: Color.fromRGBO(193, 216, 47, 0.8),
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(200),
                  bottomRight: Radius.circular(10))),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 8.0),
                child: RaisedButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  splashColor: Colors.blueGrey,
                  onPressed: () async {
                    var permission = await Permission.camera.status;
                    if (permission != Permission.camera.isGranted) {
                      var permission = await Permission.camera.request();
                    }
                    try {
                      String barcode = await BarcodeScanner.scan();
                      setState(() {
                        this.barcode = barcode;
                        guardarMarcaje(
                            positionHere.latitude.toString(),
                            positionHere.longitude.toString(),
                            barcode,
                            widget.idUsuario.toString(),
                            'CODEBAR',
                            "",
                            "",
                            context);
                      });
                    } on PlatformException catch (e) {
                      if (e.code == BarcodeScanner.CameraAccessDenied) {
                        setState(() {
                          this.barcode = 'Sin acceso a la cámara!';
                        });
                      } else {
                        setState(() => this.barcode = 'Error Desconocido: $e');
                      }
                    } on FormatException {
                      setState(
                          () => this.barcode = 'Por Favor Scanner Código QR');
                    } catch (e) {
                      setState(() => this.barcode = 'Unknown error: $e');
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 200,
                    // color: Colors.green,
                    padding: const EdgeInsets.all(15.0),
                    child: Text("Scan Código de Barra",
                        style: TextStyle(fontSize: 15, fontFamily: 'Gill'),
                        textAlign: TextAlign.center),
                  ),
                  // shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      side: BorderSide(color: Colors.green)),
                ),
              ),
            ],
          ),
        ));
  }

  Future scan() async {
    var permission = await Permission.camera.status;
    if (permission != Permission.camera.isGranted) {
      var permission = await Permission.camera.request();
    }
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.barcode = barcode;
        // mapeoQR = json.decode(barcode);
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'Sin acceso a la cámara!';
        });
      } else {
        setState(() => this.barcode = 'Error Desconocido: $e');
      }
    } on FormatException {
      setState(() => this.barcode = 'Por Favor Scanner Código QR');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}

Future<String> guardarMarcaje(
    String latitud,
    String longitud,
    String correlativo,
    String idUsuario,
    String tipoMarcaje,
    String nombreqr,
    usuario,
    context) async {
  DateTime now = DateTime.now();
  var formatter = new DateFormat("yyyy-MM-dd");
  String fecha = formatter.format(now);
  var reloj = now.hour.toString() +
      ":" +
      now.minute.toString() +
      ":" +
      now.second.toString();

  Map datos = {
    // "id_log_reloj": id_log,
    "carnet": correlativo,
    "reloj": reloj,
    "status": 'Activo',
    "fecha": fecha,
    "tipo_marcaje": tipoMarcaje,
    "longitud": longitud,
    "latitud": latitud,
    "iduser": idUsuario,
    "nombreqr": nombreqr,
    "name": usuario
  };

  var respuesta = await post(URL_BASE + 'logmarcajesgral',
      headers: {
        "Accept": "application/json",
        "APP-KEY": APP_KEY,
        "APP-SECRET": APP_SECRET
      }, body: datos);
  print("hlalallala");

  print(respuesta.statusCode);
  if (respuesta.statusCode == 201) {
    var map = jsonDecode(respuesta.body);
    var mensaje = map['mensaje'];
    if (mensaje == null) {
      _showDialog(context, 'Muy Bien!', "Se completo con éxito el marcaje");
    }
  } else if (respuesta.statusCode == 200) {
    var map = jsonDecode(respuesta.body);
    var mensaje = map['mensaje'];
    _showDialog(context, 'Información del Marcaje', mensaje);
  } else if (respuesta.statusCode == 500) {
    _showDialog(
        context, 'Error!', "Ingrese un Carné Válido para realizar el marcaje");
  } else {
    _showDialog(context, 'Error!',
        "verifique su acceso a internet, puede estar fuera del rango de marcaje");
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
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
