import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cempro_gps/constantes/url_helper.dart';
import 'package:cempro_gps/formularios/politicas.dart';
import 'package:cempro_gps/helpers/mi_button.dart';
import 'package:cempro_gps/helpers/sqlLite_helper.dart';
import 'package:cempro_gps/login/login_page.dart';
import 'package:cempro_gps/modelos/login_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_mac/get_mac.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'meses_model.dart';

int contador = 0;
bool rememberMe = false;
String _macAddress = "Unknown";
final dbHelper = DatabaseHelper.instance;
String userGenerado = '' ;
int MAX = 99;
int numeroAleatorio = 1;
String nombre1 ="";
String nombre2 = "";
String lastName1 = "";
String lastName2 = "";


class FormDeAlta extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new MyHomePage(title: 'Formulario de Alta'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  String motivoAlta = 'No';
  @override
  _MyHomePageState createState() => new _MyHomePageState();

}
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController correlativo = TextEditingController();
  final TextEditingController nit = TextEditingController();
  String fecha = '';
  DateTime selectedDate = DateTime.now();
  String motivoAlta = '';
  Elementos ele = new Elementos();
  Elementos2 ele2 = new Elementos2();
  String dropdownValue = 'Año';
// To show Selected Item in Text.
  String holder = '' ;

  bool isBackButtonActivated = false;

  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;

  @override
  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;

    _dropdownMenuItemsMeses = buildDropdownMenuItemsMeses(_meses);
    _selectedMeses = _dropdownMenuItemsMeses[0].value;

    getMacAddress();
    getDropDownItem();
    getDropDownItemDias();
    BackButtonInterceptor.add(myInterceptor);
    HttpOverrides.global = new MyHttpOverrides();
  }
  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }
  //crear select mes
  List<Mes> _meses = Mes.getMeses();
  List<DropdownMenuItem<Mes>> _dropdownMenuItemsMeses;
  Mes _selectedMeses;

  List<DropdownMenuItem<Mes>> buildDropdownMenuItemsMeses(List meses) {
    List<DropdownMenuItem<Mes>> items = List();
    for (Mes mes in meses) {
      items.add(
        DropdownMenuItem(
          value: mes,
          child: Text(mes.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItemMeses(Mes selectedMes) {
    setState(() {
      _selectedMeses = selectedMes;
    });
  }

  List<DropdownMenuItem<Company>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Company>> items = List();
    for (Company company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }
  onChangeDropdownItem(Company selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
      fecha = dropdownValue+'-'+_selectedMeses.id+'-'+dropdownValueDias;
    });
  }

  void getDropDownItem(){

    setState(() {
      holder = dropdownValue ;
      // fecha = dropdownValue+'-'+_selectedMeses.id+'-'+dropdownValueDias;
    });
  }

  String dropdownValueDias = 'Día';
// To show Selected Item in Text.
  String holderDias = '' ;
  void getDropDownItemDias() {
    setState(() {
      holderDias = dropdownValueDias;
    });
  }
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
   _salirAPP(context);
    return true;
  }
  @override
  Widget build(BuildContext context) {
    // Future<void> mimac = getMacAddress();

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(193, 216, 47,  0.8),
        title: new Center(child:
        new Text(
            'Formulario de alta',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily:'Gill', fontSize: 25, color: Color.fromRGBO(14, 123, 55, 99.0))),
            ),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(200), bottomRight: Radius.circular(10)
          )
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.login, color: Colors.white,),
              onPressed: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              })
        ]
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(Colors.lightGreenAccent.withOpacity(0.1), BlendMode.srcOver),
                      child: Image.asset(
                        "assets/progreso.png",
                        width: 60,
                        height: 60,
                        fit:BoxFit.fill,
                      ),
                    ),
                    Text('  Progreso', style: TextStyle(fontSize: 40, fontFamily:'Gotan', color: Color.fromRGBO(84, 87, 89, 1.0),fontWeight: FontWeight.bold ))
                  ],
                ),

              ],
            ),
          ),
          SizedBox(
            height: 40
          ),
          new ListTile(
            title: new TextField(
                autofocus: true,
                controller: correlativo,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Correlativo',
                  prefixIcon: Icon(Icons.vpn_key, color: Color.fromRGBO(0, 99, 38, 50), size: 30),
                  hintStyle: TextStyle(color: Color.fromRGBO(84, 87, 89, 50), fontSize: 15, fontFamily: 'Gill'),
                  filled: true,
                  fillColor: Colors.white70,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: Color.fromRGBO(66, 172, 53, 50), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Color.fromRGBO(0, 99, 38, 50), width: 2),
                  ),
              ),
            ),
          ),
          SizedBox(
              height: 15
          ),
          new ListTile(
            title: new TextField(
              controller: nit,
              onChanged: (text) {
                  text = nit.text;
              },
              decoration: InputDecoration(
                hintText: 'N.I.T',
                prefixIcon: Icon(Icons.credit_card_sharp, color: Color.fromRGBO(0, 99, 38, 50), size: 30),
                hintStyle: TextStyle(color: Color.fromRGBO(84, 87, 89, 50), fontSize: 15, fontFamily: 'Gill'),
                filled: true,
                fillColor: Colors.white70,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Color.fromRGBO(66, 172, 53, 50), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Color.fromRGBO(0, 99, 38, 50), width: 2),
                ),
              ),

            ),
          ),
          SizedBox(
              height: 5
          ),
          Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromRGBO(66, 172, 53, 50),
                style: BorderStyle.solid,
                width: 1,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              )
          ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(
                        Icons.keyboard,
                        color: Color.fromRGBO(0, 99, 38, 50),
                        size: 35
                    ),
                    Text('Fecha Nacimiento  ', style: TextStyle(color: Color.fromRGBO(84, 87, 89, 50), fontSize: 15, fontFamily: 'Gill')),
                    DropdownButton<String>(
                      value: dropdownValueDias,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Color.fromRGBO(84, 87, 89, 50), fontSize: 15, fontFamily: 'Gill'),
                      underline: Container(
                        height: 2,
                        color: Color.fromRGBO(0, 99, 38, 50),
                      ),
                      onChanged: (String data) {
                        setState(() {
                          dropdownValueDias = data;
                        });
                      },
                      items: dias.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(

                          value: value,
                          child: Text(value, style: TextStyle(color: Color.fromRGBO(84, 87, 89, 50), fontSize: 14, fontFamily: 'Gill')),
                        );
                      }).toList(),
                    ),
                    DropdownButton(
                      style: TextStyle(color: Color.fromRGBO(84, 87, 89, 50), fontSize: 15, fontFamily: 'Gill'),
                      value: _selectedMeses,
                      items: _dropdownMenuItemsMeses,
                      underline: Container(
                        height: 2,
                        color: Color.fromRGBO(0, 99, 38, 50),
                      ),
                      onChanged: onChangeDropdownItemMeses,
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Color.fromRGBO(84, 87, 89, 50), fontSize: 15, fontFamily: 'Gill'),
                      underline: Container(
                        height: 2,
                        color: Color.fromRGBO(0, 99, 38, 50),
                      ),
                      onChanged: (String data) {
                        setState(() {
                          dropdownValue = data;
                          fecha = dropdownValue+'-'+_selectedMeses.id+'-'+dropdownValueDias;
                        });
                      },
                      items: actorsName.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(color: Color.fromRGBO(84, 87, 89, 50), fontSize: 15, fontFamily: 'Gill')),
                        );
                      }).toList(),
                    ),
                  ],
                )
              ],
            ),
          ),
            Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(66, 172, 53, 50),
                      style: BorderStyle.solid,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    )
                ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.list,
                        color: Color.fromRGBO(0, 99, 38, 50),
                        size: 40
                      ),
                      Text('   '),
                      DropdownButton(
                          style: TextStyle(color: Color.fromRGBO(84, 87, 89, 50), fontSize: 15, fontFamily: 'Gill'),
                          value: _selectedCompany,
                          items: _dropdownMenuItems,
                          onChanged: onChangeDropdownItem
                      ),
                    ],
                  ),
                ],
              ),
              ),
          new Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                  Column(
                    children: <Widget>[
                      FlatButton(
                          onPressed: () {
                            motivoAlta = 'Si';
                            fecha = dropdownValue+'-'+_selectedMeses.id+'-'+dropdownValueDias;
                            irPoliticas(context);
                          },
                          child: Icon(
                            Icons.policy,
                            color: Color.fromRGBO(66, 172, 53, 50),
                            size: 80,
                          )),
                      SizedBox(height: 10),
                      Text("Aceptar Políticas Progreso", style: TextStyle(color: Color.fromRGBO(84, 87, 89, 50), fontSize: 18, fontFamily: 'Gill')),
                    ],
                  ),
                Checkbox(
                  value: rememberMe,
                  focusColor: Color.fromRGBO(66, 172, 53, 50),
                  checkColor: Colors.white,
                  hoverColor: Color.fromRGBO(66, 172, 53, 50),
                  activeColor: Color.fromRGBO(66, 172, 53, 50),
                  onChanged: (bool newValue) {
                    setState(() {
                      fecha = dropdownValue+'-'+_selectedMeses.id+'-'+dropdownValueDias;
                      contador = 1;
                      rememberMe = newValue;
                      motivoAlta = 'Si';
                      getMacAddress();
                    });
                  },
                ),
                  RaisedButton(
                    onPressed: ()async {
                      setState(() {
                        fecha = dropdownValue+'-'+_selectedMeses.id+'-'+dropdownValueDias;
                        numeroAleatorio = new Random().nextInt(99);
                      });
                      var permisos = await Permission.phone.status;
                      if(permisos == PermissionStatus.granted){
                        motivoAlta = _selectedCompany.name;
                        if(correlativo.text != '' && nit.text != '' && dropdownValue != 'Año' && dropdownValueDias != 'Día' && _selectedMeses.id != '20' && motivoAlta != 'Seleccione motivo alta'){
                          checkIn(correlativo.text, nit.text, fecha, _macAddress, motivoAlta, 'Si', context);
                        }else{
                          _showDialog(context, 'Valores incorrectos', 'Ingrese campos Válidos', false);
                        }

                      }else{
                        var per = Permission.phone.request();
                      }
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      height: 55,
                      width: 200,
                      padding: const EdgeInsets.all(15.0),
                      child: Text("Regístrate", style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                    ),
                    color: Color.fromRGBO(66, 172, 53,  50),
                    // shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        side: BorderSide(color: Color.fromRGBO(66, 172, 53, 50))),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void irPoliticas(context){
  Navigator.push(context, MaterialPageRoute(builder: (context) => Politicas())
  );
  contador = 1;
}

void guardarDatos(context){
  contador = 0;
  rememberMe = false;
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage() ) );
}

Future<String> getMacAddress() async {
  String macAddress;
    var permission =  await Permission.phone.status;
    // print(PermissionStatus);
    if (permission == PermissionStatus.granted) {
      macAddress = await GetMac.macAddress;
    }else{
      var permission = await Permission.phone.request();
    }

  _macAddress = macAddress;
  return _macAddress;
}
//fin imei and macaddress

//funcion para validar si el usuaio ya ha ingresado una vez
void _insertVeces(log_name, nombre) async {
  // row to insert
  Map<String, dynamic> row = {
    DatabaseHelper.columnName: log_name,
    DatabaseHelper.nombre: nombre
  };
  Login car = Login.fromMap(row);
  final id = await dbHelper.insert(car);
  // _showMessageInScaffold('inserted row id: $id');
}

void _showMessageInScaffold(String message) {
  _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      )
  );
}

void _showDialog(context, titulo, contenido, btnCliente) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(titulo, style: TextStyle(fontFamily: 'Gill')),
          content: Text(contenido, style: TextStyle(fontFamily: 'Gill')),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          if(btnCliente == true)
            IconButton(
              icon: Image.asset('assets/serviciocliente.png'),
              iconSize: 150,
              onPressed: () {
                _llamarServicioClient();
              },
            ),
          new FlatButton(
            child: new Text("Close", style: TextStyle(fontFamily: 'Gill')),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )


        ],
      );
    },
  );
}
Future<String> checkIn(String correlativo, String nit, String birth, macAddres, motivoAlta, politicas, context) async{
  String correo = '';
  Map datos = {
    "userid": correlativo,
    "nit": nit,
    "birth": birth
  };
  try {
  var respuesta = await http.post(
      URL_BASE+'checkin',
      headers: {
        "Accept": "application/json",
        "APP-KEY": APP_KEY,
        "APP-SECRET": APP_SECRET
      },
      body: datos
  );
  Map<String, dynamic> map = jsonDecode(respuesta.body);
  nombre1 = map['name1'];
  nombre2 = map['name2'];
  lastName1 = map['last-name1'];
  lastName2 = map['last-name2'];

    if (respuesta.statusCode == 200) {
      if (map['res'] == false) {
        _showDialog(context, 'Atención!!', map['mensaje'], true);
      } else {
        userGenerado = nombre1.substring(0, 1);
        userGenerado = userGenerado + nombre2.substring(0, 2) + lastName1 +
            numeroAleatorio.toString();
        correo = map['mail'];
        if (correo == '') {
          createUser(
              userGenerado,
              correlativo,
              nit,
              map['userid'],
              'oner',
              macAddres,
              motivoAlta,
              politicas,
              birth,
              context
          );
        } else {
          createUser(
              userGenerado,
              correlativo,
              nit,
              map['userid'],
              correo,
              macAddres,
              motivoAlta,
              politicas,
              birth,
              context
          );
        }
      }
    } else {
      _showDialog(
          context, 'Error!', 'No se encontraron los datos', false);
    }
  }catch( e ) {
    _showDialog(context, 'Error! ', 'Sin Intenet', false);
    // errorCallback( e.toString() );

  }
}

Future<AltaForm> createUser(
    String usuarioGenerado,
    String correlativo,
    String nit,
    String userId,
    String correo,
    String macAddress,
    String motivoAlta,
    String politicas,
    String fecha,
    context
    ) async {
  Map datos = {
    "name": usuarioGenerado,
    "correlativo": correlativo,
    "nit": nit,
    "userid": userId,
    "email": correo,
    "macaddress": macAddress,
    "motivoalta": motivoAlta,
    "politicas": politicas,
    "estado": "Activo",
    "rolldispositivio": "app",
    "fechanacimiento": fecha
  };
try {
  var respuesta = await http.post(
      URL_BASE + 'user',
      headers: {
        "Accept": "application/json",
        "APP-KEY": APP_KEY,
        "APP-SECRET": APP_SECRET
      },
      body: datos
  );
  Map<String, dynamic> map = jsonDecode(respuesta.body);
  if (respuesta.statusCode == 200 || respuesta.statusCode == 201) {
    if (map['res'] == false) {
      if (map['mensaje'] == 'Llamar al 2368 8777 para solicitar su clave') {
        _insertVeces(1, "Nombre");
        _showDialog(context, 'Atención!!', map['mensaje'], true);
      }
      else {
        _showDialog(context, 'Atención!!', map['mensaje'], true);
      }
      _showDialog(context, 'Atención!!', map['mensaje'], true);
    } else {
      // _showDialog(context, 'Atención!!', map['mensaje'], false);
      _insertVeces(1, "Nombre");
      Navigator.of(context).pop();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LoginPage())
      );
    }
  } else {
    _showDialog(context, 'Sin respuesta', 'Sin conexión al servidor de marcaciones', true);
  }
} catch( e ) {
  _showDialog(context, 'Error! ', "Sin conexión al servidor de marcaciones", false);
  // errorCallback( e.toString() );

}
}

_llamarServicioClient() async{
  const appLLamada = 'tel:+502 23688777';
  if(await launch(appLLamada)){
    await launch(appLLamada);
  }else{
    throw 'No se pudo abrir la App de llamadas';
  }
}
List <String> dias =[
  'Día','01','02', '03', '04', '05', '06', '07', '08', '09', '10',
  '11','12', '13', '14', '15', '16', '17', '18', '19',
  '20','21', '22', '23', '24', '25', '26', '27', '28', '29',
  '30','31',
];
List <String> actorsName = [
  'Año',
  '2021',
  '2020',
  '2019',
  '2018',
  '2017',
  '2016',
  '2015',
  '2014',
  '2013',
  '2012',
  '2011',
  '2010',
  '2009',
  '2008',
  '2007',
  '2006',
  '2005',
  '2004',
  '2003',
  '2002',
  '2001',
  '2000',
  '1999',
  '1998',
  '1997',
  '1996',
  '1995',
  '1994',
  '1993',
  '1992',
  '1991',
  '1990',
  '1989',
  '1988',
  '1987',
  '1986',
  '1985',
  '1984',
  '1983',
  '1982',
  '1981',
  '1980',
  '1979',
  '1978',
  '1977',
  '1976',
  '1975',
  '1974',
  '1973',
  '1972',
  '1971',
  '1970',
  '1969',
  '1968',
  '1967',
  '1966',
  '1965',
  '1964',
  '1963',
  '1962',
  '1961',
  '1960',
  '1959',
  '1958',
  '1957',
  '1956',
  '1955',
  '1954',
  '1953',
  '1952',
  '1951',
  '1950',
  '1949',
  '1948',
  '1947',
  '1946',
  '1945',
  '1944',
  '1943',
  '1942',
  '1941',
  '1940'
] ;

void _salirAPP(context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Cerrar APP!", style: TextStyle(fontFamily: 'Gill')),
        content: new Text('Desea Cerrar la APP ??', style: TextStyle(fontFamily: 'Gill')),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Cerrar App", style: TextStyle(fontFamily: 'Gill')),
            onPressed: () {
              exit(0);
            },
          ),
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Cancelar", style: TextStyle(fontFamily: 'Gill')),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
