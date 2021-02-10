// import 'dart:async';
// import 'dart:convert';
//
// import 'package:cempro_gps/login/login_page.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/http.dart';
//
// class Mensaje {
//   final int id;
//   final String updated_at;
//   final String description;
//
//   Mensaje({this.id, this.updated_at,  this.description});
//
//   factory Mensaje.fromJson(Map<String, dynamic> json) {
//     return Mensaje(
//       id: json['id'],
//       updated_at: json['updated_at'],
//       description: json['description'],
//     );
//   }
// }
// class JobsListView extends StatelessWidget {
//   String mensajesUrl = '18.189.26.76:8000/api/mensajesxsede';
//
//   @override
//   Widget build(BuildContext context, String name) {
//     return FutureBuilder<List<Mensaje>>(
//       future: _fetchJobs(name),
//       // builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           List<Mensaje> data = snapshot.data;
//           return _jobsListView(data);
//         } else if (snapshot.hasError) {
//           return Text("${snapshot.error}");
//         }
//         return CircularProgressIndicator();
//       },
//     );
//   }
//
//   Future<List<Mensaje>> _fetchJobs(String name) async {
//
//     Map datos = {
//       "name": name
//     };
//
//     respuesta = await post(mensajesUrl, body: datos );
//     // print(respuesta.body);
//     List jsonResponse = json.decode(respuesta.body);
//     return jsonResponse.map((mensaje) => new Mensaje.fromJson(mensaje)).toList();
//   }
//
//   ListView _jobsListView(data) {
//     return ListView.builder(
//         itemCount: data.length,
//         itemBuilder: (context, index) {
//           return _tile(data[index].updated_at, data[index].descricion, Icons.work);
//         });
//   }
//
//   ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
//     title: Text(title,
//         style: TextStyle(
//           fontWeight: FontWeight.w500,
//           fontSize: 20,
//         )),
//     subtitle: Text(subtitle),
//     leading: Icon(
//       icon,
//       color: Colors.blue[500],
//     ),
//   );
// }