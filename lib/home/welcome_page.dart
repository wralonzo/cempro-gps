import 'package:cempro_gps/pages/loading_page.dart';
import 'package:cempro_gps/pages/mapa_page.dart';
import 'package:cempro_gps/formularios/politicas.dart';
import 'package:cempro_gps/login/login_page.dart';
import 'package:cempro_gps/pages/BusesPage.dart';
import 'package:cempro_gps/pages/ViaticosPage.dart';
import 'package:flutter/material.dart';

import '../main.dart';
// import 'package:cempro_gps/services/auth.service.dart';

class HomePage extends StatefulWidget {
  final String usuario;
  HomePage(this.usuario);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) => new Scaffold(

      appBar: new AppBar(
      backgroundColor: Colors.green,
      automaticallyImplyLeading: false,
      title: new Text('Cempro GPS'),
      actions: [
        Image.asset('assets/logo.png',fit: BoxFit.contain,height: 32, color: Colors.white), // here add notification icon
        Container(padding: const EdgeInsets.all(2.0))
      ],
    ),
    body: new Container(


      alignment: Alignment.center,
      child: new Column(

          children: <Widget>[
            SizedBox(height: 20),
            new Text("Bienvenido "+this.widget.usuario, style: TextStyle(color: Colors.green.shade500,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
            SizedBox(height: 20),
            MaterialButton(
              minWidth: 200.0,
              height: 100.0,
              color: Colors.green,
              child: Text('Marcajes', style: TextStyle(color: Colors.white)),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapaPage()),
                );
                  },
            ),

            new Text('Benvenido USUARIO1 !', style: TextStyle(color: Colors.white)),
            MaterialButton(
              minWidth: 200.0,
              height: 100.0,
              color: Colors.lightGreen,
              child: Text('Buses', style: TextStyle(color: Colors.white)),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoadingPage()),
                );
              },
            ),

            new Text('Benvenido USUARIO1 !', style: TextStyle(color: Colors.white)),
            MaterialButton(
              minWidth: 200.0,
              height: 100.0,
              color: Colors.lightBlueAccent,
              child: Text('Viaticos', style: TextStyle(color: Colors.white)),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViaticosPage()),
                );
              },
            ),
            new Text('Benvenido USUARIO1 !', style: TextStyle(color: Colors.white)),
            MaterialButton(
              minWidth: 200.0,
              height: 100.0,
              color: Colors.cyan,
              child: Text('Politicas de usuario', style: TextStyle(color: Colors.white)),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Politicas()),
                );
              },
            ),
            new Text('Benvenido USUARIO1 !', style: TextStyle(color: Colors.white)),
            MaterialButton(
              minWidth: 200.0,
              height: 100.0,
              color: Colors.orangeAccent,
              child: Text('Salir', style: TextStyle(color: Colors.white)),
              onPressed: (){
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage())
                  // onPressed: ()=> exit(0),

                );
              },
            ),
            SizedBox(height: 20),
      ],

      ),
    ),
  );
}

