import 'dart:convert';

// Import the client from the Http Packages
import 'package:cempro_gps/cards/usuario_class.dart';
import 'package:http/http.dart' show Client;

//Import the Todo Model

class ApiService {
  // Replace this with your computer's IP Address
  final String baseUrl = "http://18.189.26.76:8000/api";
  Client client = Client();

// Get All Todos
  Future<List<Usuario>> getToDos() async {
    final response = await client.get("$baseUrl/user");
    if (response.statusCode == 200) {
      return fromJson(response.body);
    } else {
      return null;
    }
  }

// Update an existing Todo
  Future<bool> updateToDo(Usuario data) async {
    final response = await client.put(
      "$baseUrl/user}",
      headers: {"content-type": "application/json"},
      body: toJson(data),
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

// Create a new Todo
  Future<bool> addToDo(Usuario data) async {
    final response = await client.post(
      "$baseUrl/logmarcajesgral",
      headers: {"content-type": "application/json"},
      body: toJson(data),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

// Delete a Todo
  Future<bool> deleteTodo(int todoId) async {
    final response = await client.delete(
      "$baseUrl/user",
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

// Get list of all Todo Statuses
  Future<List<String>> getStatuses() async {
    final response = await client.get("$baseUrl/user");
    if (response.statusCode == 200) {
      var data = (jsonDecode(response.body) as List<dynamic>).cast<String>();
      return data;
    } else {
      return null;
    }
  }
}