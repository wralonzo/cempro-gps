import 'package:flutter/material.dart';

class MarcajePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<MarcajePage> {
  String _status = 'no-action';

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: new Text('Marcajes'),
    ),
    body: new Column(
      children: <Widget>[
        new Container(width: 5.0, height: 10,),
        new Text("Administracion de Marcajes",
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