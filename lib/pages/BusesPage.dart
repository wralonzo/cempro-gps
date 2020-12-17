import 'package:flutter/material.dart';

class BusesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<BusesPage> {
  String _status = 'no-action';

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: new Text('Bueses'),
    ),
    body: new Column(
      children: <Widget>[
        new Container(width: 5.0, height: 10,),
        new Text("Administracion de buses",
          textAlign: TextAlign.center,

          style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Karla'
          ),
        ),
      ],

    ),
  );
}