import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as Permisos;

class MapaPage extends StatefulWidget {
  final String usuario;
  MapaPage(this.usuario);
  @override
  State<StatefulWidget> createState() => new _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {

  void initState() async {
    super.initState();
    permisoGPS(context, this.widget.usuario);
    // _locationData = await location.getLocation();
  }


  String _status = 'no-action';
  CameraPosition _initialPosition = CameraPosition(
    target: LatLng(14.588262, -89.5027674),
      zoom: 75.0
  );
  Completer<GoogleMapController> _controller = Completer();


  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
  MapType _defaultMapType = MapType.normal;

  void _changeMapType() {
    setState(() {
      _defaultMapType = _defaultMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }
  // int _circleIdCounter = 1;
  // bool _isCircle = false;

  // void _setCircles(LatLng point) {
  //   final String circleIdVal = 'circle_id_$_circleIdCounter';
  //   _circleIdCounter++;
  //   print(
  //       'Circle | Latitude: ${point.latitude}  Longitude: ${point.longitude}  Radius: $radius');
  //   _circles.add(Circle(
  //       circleId: CircleId(circleIdVal),
  //       center: point,
  //       radius: radius,
  //       fillColor: Colors.redAccent.withOpacity(0.5),
  //       strokeWidth: 3,
  //       strokeColor: Colors.redAccent));
  // }


  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      backgroundColor: Colors.green,
      title: new Text('Marcaje'),
    ),
    body: Stack(

        children: <Widget>[

          GoogleMap(
            mapType: _defaultMapType,
            myLocationEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: _initialPosition,
          ),
          Container(
            margin: EdgeInsets.only(top: 80, right: 10),
            alignment: Alignment.topRight,
            child: Column(
                children: <Widget>[

                  FloatingActionButton(
                      child: Icon(Icons.layers),
                      elevation: 100,
                      backgroundColor: Colors.teal[200],
                      onPressed: () {
                        _changeMapType();
                        print('Changing the Map Type');
                      }),
                ]),
          ),
        ]),
  );
}

void permisoGPS(context, usuario) async{
  final status = await Permisos.Permission.location.status;

  if(status == Permisos.PermissionStatus.denied){
    Permisos.Permission.location.request();
  }
  // if(status == PermissionStatus.disabled || status == PermissionStatus.unknown || status == PermissionStatus.restricted){
  //   PermissionHandler().openAppSettings();
  // }
  if(status == Permisos.PermissionStatus.undetermined){
    Permisos.Permission.location.request();
  }if(status == Permisos.PermissionStatus.permanentlyDenied){
    Permisos.Permission.location.request();
  }if(status == Permisos.PermissionStatus.restricted){
    Permisos.Permission.location.request();
  }if(status == PermissionStatus.GRANTED){
    _showDialog(context, 'Bienvenido', 'Marcaje ', usuario);
  }else{
    //PermissionHandler().openAppSettings();
    print(status);
  }
}


void _showDialog(context, titulo, contenido, usuario) {
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
              // Navigator.of(context).push(MaterialPageRoute(
              //
              //   builder: (context) => HomePage(usuario),
              // ));

            },
          ),
        ],
      );
    },
  );
}