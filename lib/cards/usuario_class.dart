import 'dart:convert';
// A flutter class that resemble our rest API's request response data
class Usuario {
  final int id;
  String name;
  String email;

// Flutter way of creating a constructor
  Usuario({this.id = 0, this.name = '', this.email = ''});

// factory for mapping JSON to current instance of the Todo class
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

// Instance method for converting a todo item to a map
  Map<String, dynamic> toMap() {
    return {"id": id, "name": name, "email": email};
  }

}

//  A helper method that converts a json array into List<ToDo>
List<Usuario> fromJson(String jsonData) {

  // Decode json to extract a map
  final data = json.decode(jsonData);

  // Map each todo JSON to a Todo object and return the result as a List<ToDo>
  return List<Usuario>.from(data.map((item) => Usuario.fromJson(item)));
}

// A helper method to convert the todo object to JSON String
String toJson(Usuario data) {
  // First we convert the object to a map
  final jsonData = data.toMap();

  // Then we encode the map as a JSON string
  return json.encode(jsonData);
}