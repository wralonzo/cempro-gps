import 'package:cempro_gps/home/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapaPage extends StatefulWidget {
  final String usuario;
  MapaPage(this.usuario);
  @override
  State<StatefulWidget> createState() => new _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  void initState() {
    super.initState();
    permisoGPS(context, this.widget.usuario);
  }
  String _status = 'no-action';
  GoogleMapController mapController;
  MapType _defaultMapType = MapType.normal;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  void _changeMapType() {
    setState(() {
      _defaultMapType = _defaultMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }


  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      backgroundColor: Colors.green,
      title: new Text('Marcaje'),
    ),
    body: Center(
      child:
      GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        rotateGesturesEnabled: false,
        scrollGesturesEnabled: false,
        tiltGesturesEnabled: false,
        zoomGesturesEnabled: false,
        mapType: _defaultMapType,
        mapToolbarEnabled: true,
        myLocationButtonEnabled: true,
        initialCameraPosition: CameraPosition(
          // target: _center,
          target: LatLng(14.63077, -90.60711),
          zoom: 8.0,
        ),

      ),
      // Column(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //   children: <Widget>[
          // SizedBox(height: 30),
          // new Text("Bienvenido la hora es: 10:30 AM "),
          // SizedBox(height: 30),
          // new RaisedButton(
          //   child: Text('Marcar inicio'),
          //   onPressed:() {},
          // ),
          // SizedBox(height: 100),
          // new Text("Aqui va el mapa "),
          // GoogleMap(
          //   onMapCreated: _onMapCreated,
          //   initialCameraPosition: CameraPosition(
          //     target: _center,
          //     zoom: 11.0,
          //   ),
          // ),
          // SizedBox(height: 100),
          // new RaisedButton(
          //   child: Text('Marcar Salida'),
          //   onPressed:() {},
          // ),
          // SizedBox(height: 100),
          // SizedBox(height: 100),
        //]
      //),
    )
  );
}


void permisoGPS(context, usuario) async{
  final status = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
  if(status == PermissionStatus.denied){
    PermissionHandler().requestPermissions([PermissionGroup.location]);
  }
  // if(status == PermissionStatus.disabled || status == PermissionStatus.unknown || status == PermissionStatus.restricted){
  //   PermissionHandler().openAppSettings();
  // }
  if(status == PermissionStatus.disabled){
    PermissionHandler().requestPermissions([PermissionGroup.location]);
  }if(status == PermissionStatus.unknown){
    PermissionHandler().requestPermissions([PermissionGroup.location]);
  }if(status == PermissionStatus.restricted){
    PermissionHandler().requestPermissions([PermissionGroup.location]);
  }if(status == PermissionStatus.granted){
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