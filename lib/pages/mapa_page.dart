import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
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