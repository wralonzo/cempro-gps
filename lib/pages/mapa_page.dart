import 'dart:convert';

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
  static  LatLng _lastMapPosition = _initialPosition;
  Position positionHere;
  // final String currentTime = getSystemTime();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _getLocationHere();
  }
  void _getLocationHere() async {
    positionHere = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  }

  String getSystemTime() {
    var now = new DateTime.now();
    return new DateFormat("H:m:s").format(now);
  }

  void _getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      print('${placemark[0].name}');
    });
  }


  _onMapCreated(GoogleMapController controller) {
    setState(() {
      controller1.complete(controller);
      _getLocationHere();
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
      _markers.add(
          Marker(
              markerId: MarkerId(_lastMapPosition.toString()),
              position: _lastMapPosition,
              infoWindow: InfoWindow(
                  title: "Macaje",
                  snippet: "Cempro S.A",
                  onTap: (){
                  }
              ),
              onTap: (){
              },

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
        backgroundColor: Colors.green,
        title: new Text('Marcajes Cempro'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.qr_code,
              color: Colors.white,
              size: 35,
            ),
            onPressed: () {
              // do
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    ScanScreen(widget.usuario, widget.idUsuario, widget.Correlativo)
                  // HomePageB()
                ),

              );
            },
          )
        ],
      ),
      body: _initialPosition == null ? Container(child: Center(child:Text('loading map..', style: TextStyle(fontFamily: 'Avenir-Medium', color: Colors.grey[400]),),),) : Container(
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

                      mapButton(
                          _onMapTypeButtonPressed,
                          Icon(
                            Icons.airplanemode_active
                          ),
                          Colors.green),
                    ],
                  )),
          ),

          Align(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // SizedBox(height: ),

                TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
                  // print("${getSystemTime()}");
                  return Text(
                    "${getSystemTime()}",

                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 30,
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
                        onPressed: ()async {
                          setState(() {
                            _getLocationHere();
                            // _showDialog(context, "MARCAJE", "Entrada guardada Exitosamente");
                            guardarMarcaje(positionHere.latitude.toString(), positionHere.longitude.toString(), widget.Correlativo, widget.idUsuario.toString(), "Entrada", widget.usuario, context );
                          });
                          // print(positionHere.latitude);
                        },
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          height: 50,
                          width: 200,
                          // color: Colors.green,
                          padding: const EdgeInsets.all(15.0),
                          child: Text("Marcar Entrada", style: TextStyle(fontSize: 15), textAlign: TextAlign.center ),
                        ),
                        color: Colors.green,
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

                  // margin: EdgeInsets.symmetric(vertical: 350.0),
                  // child: Column(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: ()async {
                          setState(() {
                            _getLocationHere();
                            guardarMarcaje(positionHere.latitude.toString(), positionHere.longitude.toString(), widget.Correlativo, widget.idUsuario.toString(), "Salida", widget.usuario, context );                          });
                          // _showDialog(context, "MARCAJE", "Sálida guardada Exitosamente");

                        },
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          height: 50,
                          width: 200,
                          // color: Colors.green,
                          padding: const EdgeInsets.all(15.0),
                          child: Text("Marcar Salida", style: TextStyle(fontSize: 15), textAlign: TextAlign.center ),
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

Future<String> guardarMarcaje(String latitud, String longitud, String correlativo, String idUsuario, String tipoMarcaje, usuario, context) async{
  String urlMarcajes = 'http://18.189.26.76:8000/api/logmarcajesgral';
  DateTime now = DateTime.now();
  var formatter = new DateFormat("yyyy-MM-dd");
  String fecha = formatter.format(now);
  var reloj = now.hour.toString()+":"+now.minute.toString()+":"+now.second.toString();

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
    "name": usuario
  };

  var respuesta = await httpMarcajes.post(urlMarcajes, body: datos );
  var map = jsonDecode(respuesta.body);
  var mensaje    = map['mensaje'];
  // print(mensaje);
  print(respuesta.statusCode);
  if(respuesta.statusCode == 201){
    if(mensaje == null) {
      _showDialog(context, 'Muy Bien!', "Se completo con éxito el marcaje");
    }
  }else if(respuesta.statusCode == 200){
    _showDialog(context, 'Información del Marcaje', mensaje);
  }else{
    _showDialog(context, 'Error!', "No se completo el registro verifique su conexión a internet, puede estar fuera del rango de marcaje");
  }
}
