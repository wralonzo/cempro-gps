import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qr_flutter/qr_flutter.dart';



class GenerateScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => GenerateScreenState();
}

class GenerateScreenState extends State<GenerateScreen> {
  Map<String, String> map1;
  int contador = 0;
  String _inputErrorText;
  final TextEditingController _textController =  TextEditingController();

  GlobalKey globalKey = new GlobalKey();
  Position positionHere;

  void _getLocationHereQR() async {
    positionHere = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  @override
  void initState() {
    super.initState();
    _getLocationHereQR();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Marcaje QR'),
        backgroundColor: Colors.green,
      ),
      body: _miWidgetQR(),
    );
  }

  _miWidgetQR() {
    return  Center(
      child:  Column(
        children: <Widget>[
          SizedBox(height: 10),
          if(contador == 0)
          Row(
            children: <Widget>[
              Text("     "),
              Expanded(
                child:  TextField(
                  controller: _textController,
                  decoration:  InputDecoration(
                    hintText: "Ingrese Tipo de Marcaje",
                    errorText: _inputErrorText,
                  ),
                ),

              ),RaisedButton(
                  color: Colors.green,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    height: 50,
                    width: 100,
                    // color: Colors.green,
                    padding: const EdgeInsets.all(15.0),
                    child: Text("Generar", style: TextStyle(fontSize: 15), textAlign: TextAlign.center ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      side: BorderSide(color: Colors.green)),

                  onPressed: ()  {
                    _inputErrorText = null;
                    setState((){
                      _getLocationHereQR();
                    });
                    if(_textController.text == ''){
                      validarTexto(_textController.text, context);
                    }else {
                      String aux = _textController.text;
                      map1 = {
                        '"Latitud"': positionHere.latitude.toString(),
                        '"Longitud"': positionHere.longitude.toString(),
                        '"nombreqr"': '"$aux"'
                      };
                      contador = 1;
                    }
                  }
              ),
              Text('    ')

            ],
          ),
          Expanded(
            child:  Center(
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: map1.toString(),

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void validarTexto(String texto, context){
  if(texto == ''){
    _showDialog(context, "Alerta!", "Por favor llenar el campo de texto");
  }
}
void _showDialog(context, titulo, contenido) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(titulo),
        content: new Text(contenido),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}