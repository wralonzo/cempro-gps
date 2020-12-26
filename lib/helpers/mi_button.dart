import 'package:flutter/material.dart';
class Elementos {
  RaisedButton wBoton(String pTexto, {Function pAccion}) {
    var oBoton = RaisedButton(
        onPressed: () {
          pAccion();
        },
        textColor: Colors.white,
        padding: const EdgeInsets.all(0.0),
        child: Container(
          height: 50,
          width: 200,
          // color: Colors.green,
          padding: const EdgeInsets.all(15.0),
          child: Text(pTexto, style: TextStyle(fontSize: 15), textAlign: TextAlign.center ),
        ),
        color: Colors.green,
        // shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(25.0),
          side: BorderSide(color: Colors.green)),
    );

    return oBoton;
  }
}


class Elementos2 {
RaisedButton wBoton(String pTexto, {Function pAccion, pAccion2}) {
  var oBoton = RaisedButton(
    onPressed: () {
      pAccion();
      pAccion2();
    },
    textColor: Colors.white,
    padding: const EdgeInsets.all(0.0),
    child: Container(
      height: 50,
      width: 200,
      // color: Colors.green,
      padding: const EdgeInsets.all(15.0),
      child: Text(pTexto, style: TextStyle(fontSize: 15), textAlign: TextAlign.center ),
    ),
    color: Colors.green,
    // shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
    shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(25.0),
        side: BorderSide(color: Colors.green)),
  );

  return oBoton;
}
}