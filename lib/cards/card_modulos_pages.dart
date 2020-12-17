import 'package:flutter/material.dart';
import 'package:cempro_gps/cards/modulos.dart';
class CardPage extends StatefulWidget {

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<CardPage> {

  List<Modulos> persons = [
    Modulos(name: 'Bill Will', profileImg: 'assets/logo.png', bio: "Software Developer"),
    Modulos(name: 'Andy Smith', profileImg: 'assets/logo.png', bio: "UI Designer"),
    Modulos(name: 'Creepy Sto', profileImg: 'assets/logo.png', bio: "Software Tester")
  ];

  Widget personDetailCard(Person) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.grey[800],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(Person.profileImg)
                        )
                    )),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(Person.name,
                    style: TextStyle (
                        color: Colors.white,
                        fontSize: 18
                    ),
                  ),
                  Text(Person.bio,
                    style: TextStyle (
                        color: Colors.white,
                        fontSize: 12
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    color: Colors.white;
    return Scaffold(
      body: Padding(
      padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // decoration: new BoxDecoration(color: Colors.red),
              children: <Widget>[
                // decoration: new BoxDecoration(color: Colors.red),
                Text('Cempro GPS',
                  style: TextStyle (
                      color: Colors.green,
                      fontSize: 25
                  ),
                ),
                Image.asset('assets/logo.png',fit: BoxFit.contain,height: 32, color: Colors.white), // here add notification icon
              ],
            ),

            Column(
                children: persons.map((p) {
                  return personDetailCard(p);
                }).toList()
            )
          ],
        ),
      ),
    );
  }
}


