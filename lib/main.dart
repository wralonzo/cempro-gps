

import 'package:cempro_gps/cards/card_modulos_pages.dart';
import 'package:cempro_gps/formularios/alta_form_page.dart';
import 'package:cempro_gps/home/welcome_page.dart';
import 'package:cempro_gps/pages/BusesPage.dart';
import 'package:cempro_gps/pages/ViaticosPage.dart';
import 'package:cempro_gps/services/auth.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'location/location.dart';
import 'login/login.dart';
import 'login/login_page.dart';
import 'login/logout_page.dart';
import 'pages/loading_page.dart';
import 'pages/acceso_gps_page.dart';
import 'pages/mapa_page.dart';
AuthService appAuth = new AuthService();

void main() async {
  // Set default home.
  Widget _defaultHome = new FormDeAlta();

  // Get result of the login function.
  bool _result = await appAuth.login();
  if (_result) {
    _defaultHome = new FormDeAlta();
  }


    // Run app!
    runApp(
        new MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'App',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: _defaultHome,
          routes: <String, WidgetBuilder>{
            // Set routes for using the Navigator.
            '/home': (BuildContext context) => new HomePage(),
            '/login': (BuildContext context) => new Login(),
            '/cards': ( BuildContext context ) => new CardPage(),
            '/form-de-alta': ( BuildContext context ) => new FormDeAlta(),
            '/mapa-gps': ( BuildContext context ) => new MapaPage(),
            '/buses': ( BuildContext context ) => new BusesPage(),
            '/viaticos': ( BuildContext context ) => new ViaticosPage(),


          },
        )
    );
}