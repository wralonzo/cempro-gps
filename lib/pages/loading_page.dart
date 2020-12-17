// import 'package:cempro_gps/helpers/helpers.dart';
// import 'package:flutter/material.dart';
//
// // import 'mapa_page.dart';
// import 'acceso_gps_page.dart';
//
// class LoadingPage extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: this.checkGpsYLocation(context),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           return Center(
//             child: CircularProgressIndicator(strokeWidth: 2)
//           );
//         },
//       ),
//       );
//
//   }
//
//   Future checkGpsYLocation( BuildContext context ) async {
//
//     await Future.delayed(Duration(microseconds: 100));
//
//
//     Navigator.pushReplacement(context, navegarMapaFadeIn(context, AccesoGpsPage() ));
//
//     // Navigator.pushReplacement(context, navegarMapaFadeIn(context, MapaPage() ));
//   }
//
// }
