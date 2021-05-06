import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cempro_gps/constantes/url_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:intl/intl.dart';

class ScanScreen extends StatefulWidget {
  final String usuario;
  final int idUsuario;
  final String Correlativo;
  ScanScreen(this.usuario, this.idUsuario, this.Correlativo);
  @override
  _ScanState createState() => new _ScanState();
}


class _ScanState extends State<ScanScreen> {
  String barcode = "";
  Map<String, String> map1;
  int contador = 0;

  @override
  initState() {
    super.initState();
    HttpOverrides.global = new MyHttpOverrides();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text('Scanner qr',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily:'Gill',
                              fontSize: 25,
                              color: Color.fromRGBO(14, 123, 55, 99.0))
                      ),
                    ],
                  )
                ],
            )
          ),
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
              if (barcode == 'Sin acceso a la cámara!' ||
                  barcode == '' ||
                  barcode == 'Por Favor Scanner Código QR')
                if (contador == 0)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.0, vertical: 8.0),
                    child: RaisedButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      splashColor: Colors.blueGrey,
                      onPressed: () {
                        setState(() {
                          contador = contador + 1;
                        });
                        scan();

                      },
                      child: Container(
                        height: 50,
                        width: 200,
                        // color: Colors.green,
                        padding: const EdgeInsets.all(15.0),
                        child: Text("Scannear Código QR",
                            style: TextStyle(fontSize: 15, fontFamily: 'Gill'),
                            textAlign: TextAlign.center),
                      ),
                      // shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          side: BorderSide(color: Colors.green)),
                    ),
                  ),
              if (barcode != 'Sin acceso a la cámara!' &&
                  barcode != '' &&
                  barcode != 'Por Favor Scanner Código QR')
                if (contador == 1)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.0, vertical: 8.0),
                    child: RaisedButton(
                      color: Color.fromRGBO(66, 172, 53,  50),
                      textColor: Colors.white,
                      splashColor: Colors.blueGrey,
                      onPressed: () {
                        setState(() {
                          contador = 0;
                        });
                        Map valueMap = jsonDecode(barcode);
                        guardarMarcaje(
                            valueMap['Latitud'].toString(),
                            valueMap['Longitud'].toString(),
                            widget.Correlativo,
                            widget.idUsuario.toString(),
                            "Marcajeqr",
                            valueMap['nombreqr'],
                            widget.usuario,
                            context);
                      },
                      child: Container(
                        height: 50,
                        width: 200,
                        // color: Colors.green,
                        padding: const EdgeInsets.all(15.0),
                        child: Text("Hacer Marcación",
                            style: TextStyle(fontSize: 15),
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
  // String urlMarcajes = 'http://18.189.26.76:8000/api/logmarcajesgral';
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
    "reloj": "DI01",
    "status": 'PEN',
    "fecha": fecha,
    "create_at": fecha + " " + reloj,
    "tipo_marcaje": tipoMarcaje,
    "longitud": longitud,
    "latitud": latitud,
    "iduser": idUsuario,
    "nombreqr": nombreqr,
    "name": usuario,
    "nombre_marcaje": "QR"
  };

  var respuesta = await post(URL_BASE + 'logmarcajesgral',
      headers: {
        "Accept": "application/json",
        "APP-KEY": APP_KEY,
        "APP-SECRET": APP_SECRET
      }, body: datos);

  var map = jsonDecode(respuesta.body);
  var mensaje = map['mensaje'];
  if (respuesta.statusCode == 201) {
    if (mensaje == null) {
      _showDialog(context, 'Muy Bien!', "Se completo con éxito el marcaje");
    }
  } else if (respuesta.statusCode == 200) {
    _showDialog(context, 'Información del Marcaje', mensaje);
  } else {
    _showDialog(context, 'Error!',
        "Fuera del rango de marcaje");
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
