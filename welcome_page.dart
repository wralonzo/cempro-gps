// import 'package:cempro_gps/pages/mapa_page.dart';
// import 'package:cempro_gps/formularios/politicas.dart';
// import 'package:cempro_gps/login/login_page.dart';
// import 'package:cempro_gps/qrcode/generate.dart';
// import 'package:cempro_gps/qrcode/scan.dart';
// import 'package:cempro_gps/ui/screens/screens.dart';
// import 'package:flutter/material.dart';
//
// class HomePage extends StatefulWidget {
//   final String usuario;
//   final int idUsuario;
//   final String correlativo;
//   HomePage(this.usuario, this.idUsuario, this.correlativo);
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//
//
//   @override
//   Widget build(BuildContext context) => new Scaffold(
//
//       appBar: new AppBar(
//       backgroundColor: Colors.green,
//       automaticallyImplyLeading: false,
//       title: new Text('Cempro GPS'),
//       actions: [
//         Image.asset('assets/logo.png',fit: BoxFit.contain,height: 32, color: Colors.white), // here add notification icon
//         Container(padding: const EdgeInsets.all(2.0))
//       ],
//     ),
//     body: new Container(
//
//
//       alignment: Alignment.center,
//       child: new Column(
//
//           children: <Widget>[
//             SizedBox(height: 20),
//             new Text("Bienvenido "+this.widget.usuario, style: TextStyle(color: Colors.green.shade500,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20)),
//             SizedBox(height: 10),
//             ListTile(
//               leading: Icon(Icons.location_on, color: Colors.lightGreen, size: 50),
//               title: Text('Marcajes'),
//               trailing: Icon(Icons.keyboard_arrow_right),
//               onTap: (){
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => MapaPage(widget.usuario, widget.idUsuario, widget.correlativo)),
//                 );
//               },
//             ),
//
//             SizedBox(height: 10),
//             ListTile(
//               leading: Icon(Icons.chat, color: Colors.orangeAccent, size: 50),
//               title: Text('Mensajes'),
//               trailing: Icon(Icons.keyboard_arrow_right),
//               onTap: (){
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ChatScreen()),
//                 );
//               },
//             ),
//             SizedBox(height: 10),
//             ListTile(
//               leading: Icon(Icons.qr_code, color: Colors.black, size: 50),
//               title: Text('Generar QR'),
//               trailing: Icon(Icons.keyboard_arrow_right),
//               onTap: (){
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => GenerateScreen()),
//                 );
//               },
//             ),
//             SizedBox(height: 10),
//             ListTile(
//               leading: Icon(Icons.camera, color: Colors.blueAccent, size: 50),
//               title: Text('Scanner QR'),
//               trailing: Icon(Icons.keyboard_arrow_right),
//               onTap: (){
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ScanScreen()),
//                 );
//               },
//             ),
//             SizedBox(height: 10),
//             ListTile(
//               leading: Icon(Icons.policy, color: Colors.cyan, size: 50),
//               title: Text('Politicas de Usuario'),
//               trailing: Icon(Icons.keyboard_arrow_right),
//               onTap: (){
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => Politicas()),
//                 );
//               },
//             ),
//             SizedBox(height: 10),
//             ListTile(
//               leading: Icon(Icons.logout, color: Colors.red, size: 50),
//               title: Text('Salir'),
//               trailing: Icon(Icons.keyboard_arrow_right),
//               onTap: (){
//                 Navigator.of(context).pop();
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => LoginPage())
//                   // onPressed: ()=> exit(0),
//
//                 );
//               },
//             ),
//
//       ],
//
//       ),
//     ),
//   );
// }
//
