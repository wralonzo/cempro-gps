import 'dart:convert';
import 'dart:io';

import 'package:cempro_gps/constantes/url_helper.dart';
import 'package:cempro_gps/qrcode/scan.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as httpMarcajes;
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';

class MapaPage extends StatefulWidget {
  final String usuario;
  final int idUsuario;
  final String Correlativo;
  MapaPage(this.usuario, this.idUsuario, this.Correlativo);
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapaPage> {
  Completer<GoogleMapController> controller1;

  //static LatLng _center = LatLng(-15.4630239974464, 28.363397732282127);
  static LatLng _initialPosition;
  final Set<Marker> _markers = {};
  static LatLng _lastMapPosition = _initialPosition;
  Position positionHere;
  // final String currentTime = getSystemTime();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _getLocationHere();
    HttpOverrides.global = new MyHttpOverrides();
  }

  void _getLocationHere() async {
    positionHere = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  String getSystemTime() {
    var now = new DateTime.now();
    return new DateFormat("H:m:s").format(now);
  }

  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      // print('${placemark[0].name}');
    });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      controller1.complete(controller);
      _getUserLocation();
    });
  }

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow:
              InfoWindow(title: "Macaje", snippet: "Progreso S.A", onTap: () {}),
          onTap: () {},
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  Widget mapButton(Function function, Icon icon, Color color) {
    return RawMaterialButton(
      onPressed: function,
      child: icon,
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: color,
      padding: const EdgeInsets.all(7.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(193, 216, 47, 50),
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(200),
                bottomRight: Radius.circular(10))),
        title: new Center(
            child: Text('Marcajes Progreso',
                style: TextStyle(
                    fontFamily: 'Gill',
                    fontSize: 25,
                    color: Color.fromRGBO(14, 123, 55, 0.8)))),

      ),
      body: _initialPosition == null
          ? Container(
              child: Center(
                child: Text(
                  'loading map..',
                  style: TextStyle(
                      fontFamily: 'Avenir-Medium', color: Colors.grey[400]),
                ),
              ),
            )
          : Container(
              child: Stack(children: <Widget>[
                GoogleMap(
                  markers: _markers,
                  mapType: _currentMapType,
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 14.4746,
                  ),
                  onMapCreated: _onMapCreated,
                  zoomGesturesEnabled: true,
                  onCameraMove: _onCameraMove,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      margin: EdgeInsets.fromLTRB(1.0, 65.0, 1.0, 0),
                      child: Column(
                        children: <Widget>[
                          mapButton(_onMapTypeButtonPressed,
                              Icon(Icons.airplanemode_active), Colors.green),
                        ],
                      )),
                ),
                Align(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // SizedBox(height: ),
                      SizedBox(
                          height: 5
                      ),
                      TimerBuilder.periodic(Duration(seconds: 1),
                          builder: (context) {
                        // print("${getSystemTime()}");
                        return Text(
                          "${getSystemTime()}",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 30,
                              fontFamily: 'Gill',
                              fontWeight: FontWeight.w700),
                        );
                      }),
                    ],
                    // )
                  ),
                ),
                Align(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 40),
                      RaisedButton(
                        onPressed: () async {
                          setState(() {
                            _getLocationHere();
                            _getUserLocation();
                            guardarMarcaje(
                                positionHere.latitude.toString(),
                                positionHere.longitude.toString(),
                                widget.Correlativo,
                                widget.idUsuario.toString(),
                                "P10",
                                widget.usuario,
                                "Entrada",
                                context);
                          });
                          // print(positionHere.latitude);
                        },
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          height: 50,
                          width: 200,
                          padding: const EdgeInsets.all(15.0),
                          child: Text("Marcar Entrada",
                              style: TextStyle(fontSize: 15, fontFamily: 'Gill'),
                              textAlign: TextAlign.center),
                        ),
                        color: Color.fromRGBO(66, 172, 53, 50),
                        // shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            side: BorderSide(color: Colors.green)),
                      ),
                    ],
                    // )
                  ),
                ),
                Align(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () async {
                          setState(() {
                            _getLocationHere();
                            guardarMarcaje(
                                positionHere.latitude.toString(),
                                positionHere.longitude.toString(),
                                widget.Correlativo,
                                widget.idUsuario.toString(),
                                "P20",
                                widget.usuario,
                                "Salida",
                                context);
                          });
                          // _showDialog(context, "MARCAJE", "Sálida guardada Exitosamente");
                        },
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          height: 50,
                          width: 200,
                          // color: Colors.green,
                          padding: const EdgeInsets.all(15.0),
                          child: Text("Marcar Salida",
                              style: TextStyle(fontSize: 15, fontFamily: 'Gill' ),
                              textAlign: TextAlign.center),
                        ),
                        color: Colors.red,
                        // shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            side: BorderSide(color: Colors.green)),
                      ),
                    ],
                )),
              ]),
            ),
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

Future<String> guardarMarcaje(
    String latitud,
    String longitud,
    String correlativo,
    String idUsuario,
    String tipoMarcaje,
    String usuario,
    String nombreMarcaje,
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
    "reloj": 'DI01',
    "status": 'PEN',
    "fecha": fecha,
    "create_at": fecha + " " +reloj,
    "tipo_marcaje": tipoMarcaje,
    "longitud": longitud,
    "latitud": latitud,
    "iduser": idUsuario,
    "name": usuario,
    "nombre_marcaje": nombreMarcaje
  };
  try {
    var respuesta = await httpMarcajes.post(URL_BASE + 'logmarcajesgral',
        headers: {
          "Accept": "application/json",
          "APP-KEY": APP_KEY,
          "APP-SECRET": APP_SECRET
        },
        body: datos);
    var map = jsonDecode(respuesta.body);
    if (respuesta.statusCode == 201) {
      var mensaje = map['mensaje'];
      if (mensaje == null) {
        _showDialog(context, 'Muy Bien!', "Se completo con éxito el marcaje");
      }
    } else if (respuesta.statusCode == 200) {
      var mensaje = map['mensaje'];
      _showDialog(context, 'Información del Marcaje', mensaje);
    }
    else if (respuesta.statusCode == 500) {
      var mensaje = map['message'];
      _showDialog(context, 'Error!', 'Verifique su conexión a datos');
    }
    else {
      _showDialog(context, 'Error!',
          "Verifique su conexión a datos");
    }
  }catch(e){
    _showDialog(context, 'Error!',
        "Verifique su conexión a datos");
  }
}

/*
*
* */