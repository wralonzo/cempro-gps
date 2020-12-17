// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class AccesoGpsPage extends StatefulWidget{
//   @override
//   _AccesoGpsPageState createState() => _AccesoGpsPageState();
// }
//
// class _AccesoGpsPageState extends State<AccesoGpsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//           Text('Es necesario el GPS para utilizar esta aplicacion'),
//           MaterialButton(
//             child: Text('Solicitar Acceso', style: TextStyle(color: Colors.white)),
//             color: Colors.black,
//             shape: StadiumBorder(),
//             elevation: 0,
//             splashColor:  Colors.transparent,
//             onPressed: () async {
//
//               final status = await Permission.location.request();
//               // print( status );
//               accessGPS(status);
//
//               //moficicar permisos
//             })
//           ],)
//       )
//     );
//   }
// }
//
//
// void accessGPS( PermissionStatus status){
//   switch (status){
//
//     // case PermissionStatus.undetermined:
//     case PermissionStatus.granted:
//       // Navigator.pushReplacementNamed(context, 'mapa');
//       break;
//     case PermissionStatus.undetermined:
//
//     case PermissionStatus.denied:
//     case PermissionStatus.restricted:
//     case PermissionStatus.permanentlyDenied:
//       openAppSettings();
//
//
//   }
// }