import 'package:flutter/material.dart';

class ViaticosPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<ViaticosPage> {
  String _status = 'no-action';

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: new Text('Viaticos'),
    ),
    body: new Column(
      children: <Widget>[
        new Container(width: 5.0, height: 10,),
        new Text("Administracion de Viaticos",
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