import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Mes {
  String id;
  String name;

  Mes(this.id, this.name);

  static List<Mes> getMeses() {
    return <Mes>[
      Mes('20', 'Mes'),
      Mes('01', '01'),
      Mes('02', '02'),
      Mes('03', '03'),
      Mes('04', '04'),
      Mes('05', '05'),
      Mes('06', '06'),
      Mes('07', '07'),
      Mes('08', '08'),
      Mes('09', '09'),
      Mes('10', '10'),
      Mes('11', '11'),
      Mes('12', '12')
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
      Company(1, 'Seleccione motivo alta'),
      Company(2, 'Nuevo Ingreso a Progreso'),
      Company(3, 'Cambio de celular'),
      Company(4, 'Cambio de correlativo'),
    ];
  }
}
