import 'package:cempro_gps/helpers/sqlLite_helper.dart';

class Login {
  int id;
  int log_name;
  String nombre;

  Login(this.id, this.log_name, this.nombre);

  Login.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    log_name = map['log_name'];
    nombre = map['nombre'];

  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnName: log_name,
      DatabaseHelper.nombre: nombre
    };
  }
}