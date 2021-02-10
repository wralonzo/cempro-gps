import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Mes {
  String id;
  String name;

  Mes(this.id, this.name);

  static List<Mes> getMeses() {
    return <Mes>[
      Mes('01', 'Enero'),
      Mes('02', 'Febrero'),
      Mes('03', 'Marzo'),
      Mes('04', 'Abril'),
      Mes('05', 'Mayo'),
      Mes('06', 'Junio'),
      Mes('07', 'Julio'),
      Mes('08', 'Agosto'),
      Mes('09', 'Septiembre'),
      Mes('10', 'Octubre'),
      Mes('11', 'Noviembre'),
      Mes('12', 'Diciembre')
    ];
  }
}

class AltaForm {
  final int id;
  final String name;

  AltaForm({this.id, this.name});

  factory AltaForm.fromJson(Map<String, dynamic> json) {
    return AltaForm(
      id: json['id'],
      name: json['name'],
    );
  }
}
class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getCompanies() {
    return <Company>[
      Company(1, 'Seleccione El Motivo de Alta'),
      Company(2, 'Nuevo Ingreso a CEMPRO'),
      Company(3, 'Cambio de celular'),
      Company(4, 'Cambio de correlativo'),
    ];
  }
}

Future<AltaForm> createAlbum(String usuarioGenerado, String correo, String correlativo, String fecha, String nit, String macAddres, String motivo, String rol) async {
  final http.Response response = await http.post(
    'http://18.189.26.76:8000/api/user',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "name": usuarioGenerado,
      "email": correo,
      "fechanacimiento": fecha,
      "correlativo": correlativo,
      "macaddress": macAddres,
      "nit": nit,
      "politicas": "si",
      "estado": "activo",
      "motivoalta": motivo,
      "rolldispositivio": rol
    }),


  );

  if (response.statusCode == 200) {
    // var jsonResponse = convert.jsonDecode(response.body);
    // itemCount = jsonResponse['name'];
    return AltaForm.fromJson(jsonDecode(response.body));

  } else {
    throw Exception('Failed to create album.');
  }
}
