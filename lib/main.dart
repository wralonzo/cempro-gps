import 'package:cempro_gps/home/welcome_page.dart';
import 'package:cempro_gps/map/bloc/maps_bloc.dart';
import 'package:cempro_gps/pages/acceso_gps_page.dart';
import 'package:cempro_gps/pages/loading_page.dart';
import 'package:cempro_gps/pages/mapa_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'map/maps.dart';
import 'modelos/login_class.dart';
import 'package:cempro_gps/login/login_page.dart';
import 'formularios/alta_form_page.dart';
import 'helpers/sqlLite_helper.dart';



final dbHelper = DatabaseHelper.instance;
List<Login> logs = [];
List<Login> logByName = [];
String ruta = '/form-alta';
int opc = 0;

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BlocProvider(
      create: (BuildContext context) => MapsBloc(),
      child: Maps(),
    ),
    routes:{
      'mapa'    : ( _ ) => MapaPage(null),
      'loading' : ( _ ) => LoadingPage(),
      'acceso_gps': ( _ ) => AccesoGpsPage(),
      'home': ( _ ) => HomePage(null)
    },
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _query(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: new Column(children: <Widget>[
          Divider(
            height: 240.0,
            color: Colors.white,
          ),
          new Image.asset(
            'assets/logo_small.png',
            fit: BoxFit.cover,
            repeat: ImageRepeat.noRepeat,
            width: 170.0,
          ),
          Divider(
            height: 105.2,
            color: Colors.white,
          ),
        ]),
      ),
    );
  }
}

void _query(context) async {
  final allRows = await dbHelper.getVeces(0);
  logByName.clear();
  allRows.forEach((row) => logByName.add(Login.fromMap(row)));
  if(allRows != null && allRows.length > 0 ){
    new Future.delayed(
        const Duration(seconds: 1),
            () =>
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            ));

  }else{
    new Future.delayed(
        const Duration(seconds: 1),
            () =>
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FormDeAlta()),
            ));
  }
}