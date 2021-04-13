import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

// String URL_BASE = 'http://18.217.25.238/api/';
String URL_BASE = 'http://alphacentauri.progreso.com/api/';
String ACCEPT = 'application/json';
String APP_KEY = '056617d0ce9dbfc1f05999de9df9d527';
String APP_SECRET = '1611c4d7c9e549ab9abca590386b30cb';

Map headersApi = {
  "Accept": "application/json",
  "APP-KEY": APP_KEY,
  "APP-SECRET": APP_SECRET
};

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true; }
}
