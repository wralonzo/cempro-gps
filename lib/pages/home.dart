// import 'package:flutter/material.dart';
// import 'package:location/location.dart';
// import 'package:cempro_gps/pages/mapa_home.dart';
//
// class MapaGoes extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<MapaGoes> {
//   Location location = new Location();
//   bool _serviceEnabled;
//   PermissionStatus _permissionGranted;
//   LocationData _locationData;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkLocationPermission();
//   }
//
//   // Check Location Permissions, and get my location
//   void _checkLocationPermission() async {
//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return;
//       }
//     }
//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//     _locationData = await location.getLocation();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[800],
//       appBar: AppBar(
//         title: Text('Studyng Maps - Zeh'),
//         centerTitle: true,
//         backgroundColor: Colors.grey[900],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//           onPressed: () => _locationData != null ? Navigator.push(
//               context, MaterialPageRoute(builder: (context) => GooMap(location: _locationData,))) : null,
//           backgroundColor: Colors.orange,
//           label: Row(
//             children: <Widget>[
//               Text(
//                 'Open Maps',
//                 style: TextStyle(color: Colors.black87),
//               ),
//               Icon(
//                 Icons.map,
//                 color: Colors.black87,
//               ),
//             ],
//           )),
//       body: Container(
//         padding: EdgeInsets.all(16),
//         child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text(
//                   'Study of google maps - Zeh',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   'App to study some features of google maps: Testing markers, polygons, polylines and circles',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ],
//             )),
//       ),
//     );
//   }
// }