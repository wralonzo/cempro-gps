import 'dart:convert';

import 'package:http/http.dart';

String URL_BASE = 'http://18.217.25.238/api/';
String ACCEPT = 'application/json';
String APP_KEY = '056617d0ce9dbfc1f05999de9df9d527';
String APP_SECRET = '1611c4d7c9e549ab9abca590386b30cb';

Map headersApi = {
  "Accept": "application/json",
  "APP-KEY": APP_KEY,
  "APP-SECRET": APP_SECRET
};