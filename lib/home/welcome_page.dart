import 'dart:io';

import 'package:cempro_gps/bascode/darcode_page.dart';
import 'package:cempro_gps/login/recovery_password.dart';
import 'package:cempro_gps/pages/mapa_page.dart';
import 'package:cempro_gps/formularios/politicas.dart';
import 'package:cempro_gps/login/login_page.dart';
import 'package:cempro_gps/qrcode/generate.dart';
import 'package:cempro_gps/qrcode/scan.dart';
import 'package:cempro_gps/ui/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  final String usuario;
  final int idUsuario;
  final String correlativo;
  final String rol;
  final String nombre;
  HomePage(this.usuario, this.idUsuario, this.correlativo, this.rol, this.nombre);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime backbuttonpressedTime;

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    //bifbackbuttonhasnotbeenpreedOrToasthasbeenclosed
    //Statement 1 Or statement2
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 4);

    if (backButton) {
      backbuttonpressedTime = currentTime;
      _showDialog("SALIR", "Desea Cerrar la Aplicación" );
      return false;
    }
    return true;
  }
  void _showDialog(titulo, contenido) {
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
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Aceptar"),
              onPressed: () {
                Navigator.of(context).pop();
                exit(0);
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) => new Scaffold(

      appBar: new AppBar(
      backgroundColor: Colors.green,
      automaticallyImplyLeading: false,
      title: new Text('Cempro GPS'),
      actions: <Widget>[
        Image.asset('assets/logo.png',fit: BoxFit.contain,height: 32, color: Colors.white), // here add notification icon
        Container(padding: const EdgeInsets.all(2.0),
        ),
        IconButton(
          icon: Icon(
            Icons.lock_outline_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordPage(widget.usuario)));
          },
        )
      ],
    ),
    body: new WillPopScope(
      onWillPop: onWillPop,
      child: new ListView(
          children: <Widget>[
            SizedBox(height: 20),
            Center(
              child: Column(
                children: <Widget>[
                  new Text(this.widget.nombre, style: TextStyle(color: Colors.green.shade500,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
                ],
              ),
            ),
            SizedBox(height: 10),
            if(widget.rol == 'Marcaje')
                ListTile(
                  leading: Icon(Icons.location_on, color: Colors.lightGreen, size: 50),
                  title: Text('Marcajes'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapaPage(widget.usuario, widget.idUsuario, widget.correlativo)),
                    );
                  },
                ),

                SizedBox(height: 10),
            if(widget.rol == 'Marcaje')
                ListTile(
                  leading: Icon(Icons.chat, color: Colors.orangeAccent, size: 50),
                  title: Text('Mensajes'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen(widget.usuario)),
                    );
                  },
                ),

            SizedBox(height: 10),
            if(widget.rol == 'Marcador')
              ListTile(
                leading: Icon(Icons.qr_code, color: Colors.black, size: 50),
                title: Text('Generar QR'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GenerateScreen()),
                  );
                },
              ),

            // SizedBox(height: 10),
            if(widget.rol == 'Marcaje')
              ListTile(
                leading: Icon(Icons.add_chart, color: Colors.black, size: 50),
                title: Text('Lector de Barras'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BarcodePage(widget.usuario, widget.idUsuario, widget.correlativo)),
                  );
                },
              ),

            SizedBox(height: 10),
            if(widget.rol == 'Marcaje')
            ListTile(
              leading: Icon(Icons.camera, color: Colors.blueAccent, size: 50),
              title: Text('Scanner QR'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScanScreen(widget.usuario, widget.idUsuario, widget.correlativo)),
                );
              },
            ),

            SizedBox(height: 10),
            if(widget.rol == 'Marcaje')
            ListTile(
              leading: Icon(Icons.policy, color: Colors.cyan, size: 50),
              title: Text('Politicas de Usuario'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Politicas()),
                );
              },
            ),
            // SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.lock_outline_rounded, color: Colors.black38, size: 50),
              title: Text('Cambiar Contraseña'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PasswordPage(widget.usuario))
                  // onPressed: ()=> exit(0),

                );
              },
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red, size: 50),
              title: Text('Salir'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage())
                  // onPressed: ()=> exit(0),

                );
              },
            ),

      ],

      ),
    ),
  );
}

