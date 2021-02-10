import 'dart:async';
import 'dart:math';

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

import 'meses_model.dart';

int contador = 0;
bool rememberMe = false;
bool checkMarcador = false;

String _macAddress = "Unknown";
// String _nocontacts = 'Unknown';
final dbHelper = DatabaseHelper.instance;
Future<AltaForm> _futureAlbum;
String urlCheck = "http://18.189.26.76:8000/api/checkin";
String nombre1 = '';
String nombre2 = '';
String lastName1 = '';
String lastName2 = '';
String res = 'KO';
String cadena1 = '' ;
int MAX = 99;
int numeroAleatorio = 1;

Future<String> checkIn(String userId, String nit, String birth) async{

  Map datos = {
    "userid": userId,
    "nit": nit,
    "birth": birth
  };

  var respuesta = await http.post(urlCheck, body: datos );
  // print(respuesta.body);
  Map<String, dynamic> map = jsonDecode(respuesta.body);
  nombre1 = map['name1'];
  nombre2 = map['name2'];
  lastName1 = map['last-name1'];
  lastName2 = map['last-name2'];
  if(map['res'] == false){
    res = "KO";
  }else{
    res = 'OK';
  }
    // res = map['res'];
  print(res);

}


class FormDeAlta extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Formulario de Alta',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(

        primarySwatch: Colors.green,
      ),
      home: new MyHomePage(title: 'Formulario de Alta'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  String nombre = '';
  @override
  _MyHomePageState createState() => new _MyHomePageState();

}
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController correlativo = TextEditingController();
  final TextEditingController nit = TextEditingController();
  String fecha = '';
  DateTime selectedDate = DateTime.now();
  bool confirmaEmail = true;
  String motivoAlta = '';
  String email = '';
  Elementos ele = new Elementos();
  Elementos2 ele2 = new Elementos2();
  String dropdownValue = '2021';
// To show Selected Item in Text.
  String holder = '' ;
  String rolldispositivo = 'Marcaje' ;


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

  String dropdownValueDias = '01';
// To show Selected Item in Text.
  String holderDias = '' ;
  void getDropDownItemDias(){

    setState(() {
      holderDias = dropdownValueDias;
    });
  }
  @override
  Widget build(BuildContext context) {
    // Future<void> mimac = getMacAddress();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(200), bottomRight: Radius.circular(10)
          )
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.login, color: Colors.white,),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              })
        ]
      ),
      body: new ListView(

        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                        "assets/progreso.png",
                        width: 30,
                        height: 30,
                        fit:BoxFit.fill
                    ),
                    Text('  Progreso', style: TextStyle(fontSize: 25, fontFamily:'Montserrat', color: Colors.black,fontWeight: FontWeight.bold ))
                  ],
                ),

              ],
            ),
          ),
          SizedBox(
            height: 60
          ),
          new ListTile(
            title: new TextField(
                autofocus: true,
                controller: correlativo,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Ingrese su Correlativo',
                  prefixIcon: Icon(Icons.vpn_key_outlined),
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white70,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: Colors.green, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.green, width: 2),
                  ),
              ),
            ),
          ),
          SizedBox(
              height: 20
          ),
          new ListTile(
            title: new TextField(
              controller: nit,
              onChanged: (text) {
                  text = nit.text;
                  checkIn(text, nit.text, fecha);

              },
              decoration: InputDecoration(
                hintText: 'Ingrese su Correlativo',
                prefixIcon: Icon(Icons.credit_card_sharp),
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white70,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.green, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.green, width: 2),
                ),
              ),

            ),
          ),
          SizedBox(height: 20),
          new Center(
            child: Column(
              children: <Widget>[
                Text('Seleccione su Fecha de Nacimiento', style: TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),

          ),
          new Center(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("     "),
                    Text("Día  "),
                    DropdownButton<String>(
                      value: dropdownValueDias,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.green, fontSize: 13),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String data) {
                        setState(() {
                          dropdownValueDias = data;
                        });
                      },
                      items: dias.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(color: Colors.green, fontSize: 13)),
                        );
                      }).toList(),
                    ),

                    Text("      Mes  "),
                    DropdownButton(
                      style: TextStyle(color: Colors.green, fontSize: 13),
                      value: _selectedMeses,
                      items: _dropdownMenuItemsMeses,
                      onChanged: onChangeDropdownItemMeses,
                    ),
                    Text("   Año  "),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.redAccent, fontSize: 13),
                      underline: Container(
                        height: 2,
                        color: Colors.green,
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
                          child: Text(value, style: TextStyle(color: Colors.green, fontSize: 13)),
                        );
                      }).toList(),
                    ),


                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 30),
          new Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,

              children: <Widget>[
                new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownButton(
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                          icon: Icon(Icons.list, color: Colors.green, size: 50),
                          value: _selectedCompany,
                          items: _dropdownMenuItems,
                          onChanged: onChangeDropdownItem
                      ),
                      new Text(
                        '    Marcador', style: TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                      Checkbox(
                        value: checkMarcador,
                        onChanged: (bool newValue) {
                          setState(() {
                            checkMarcador = newValue;
                            getMacAddress();
                            fecha = dropdownValue+'-'+_selectedMeses.id+'-'+dropdownValueDias;
                            checkIn(correlativo.text, nit.text, fecha);
                            // print(correlativo.text);
                            if(checkMarcador == true){
                              rolldispositivo = 'Marcador';
                            }else{
                              rolldispositivo = 'Marcaje';
                            }
                          });
                        },
                      ),
                      ]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[


                ]
                ),
              ],
            ),
          ),
          SizedBox(height: 30),

          new Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if(rememberMe == false || contador < 1)
                  Column(
                    children: <Widget>[
                      FlatButton(
                          onPressed: () {
                            fecha = dropdownValue+'-'+_selectedMeses.id+'-'+dropdownValueDias;
                            irPoliticas(context);
                          },
                          child: Icon(
                            Icons.policy,
                            color: Colors.green,
                            size: 60,
                          )),
                      Text("Aceptar Políticas Progeso"),
                    ],
                  ),

                    // ],
                  // ),

                SizedBox(height: 30),
                Checkbox(
                  value: rememberMe,
                  onChanged: (bool newValue) {
                    setState(() {
                      fecha = dropdownValue+'-'+_selectedMeses.id+'-'+dropdownValueDias;
                      contador = 1;
                      rememberMe = newValue;
                      getMacAddress();
                      checkIn(correlativo.text, nit.text, fecha);
                      print(fecha);
                      print(rolldispositivo);
                    });
                  },
                ),
                Text("Aceptar Politicas de CEMPRO"),
                SizedBox(height: 60),
                if(rememberMe == true && contador > 0)

                  RaisedButton(
                    onPressed: ()async {
                      setState(() {
                        fecha = dropdownValue+'-'+_selectedMeses.id+'-'+dropdownValueDias;
                        numeroAleatorio = new Random().nextInt(99);
                      });
                      var permisos = await Permission.contacts.status;
                      if(permisos == PermissionStatus.granted){
                        checkIn(correlativo.text, nit.text, fecha);
                        _insertVeces(1, "Nombre");
                        // print(res);
                        nombre = _selectedCompany.name;
                        if(res == 'OK'){

                          cadena1 = nombre1.substring(0, 1);
                          cadena1 = cadena1+nombre2.substring(0,2)+lastName1+numeroAleatorio.toString();
                          print(_macAddress);
                          _futureAlbum = createAlbum(cadena1, email, correlativo.text, fecha, nit.text, _macAddress, nombre, rolldispositivo);
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage(),));
                        }else{
                          _showDialog(context, "Datos incorrectos!!", 'Ingrese Campos correctos');
                          print(numeroAleatorio);
                          print(_macAddress);

                        }
                      }else{
                        var per = Permission.contacts.request();
                      }
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      height: 50,
                      width: 200,
                      // color: Colors.green,
                      padding: const EdgeInsets.all(15.0),
                      child: Text("Regístrate", style: TextStyle(fontSize: 15), textAlign: TextAlign.center ),
                    ),
                    color: Colors.green,
                    // shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        side: BorderSide(color: Colors.green)),
                  ),

                if(contador < 1 || rememberMe == false)
                  Text("")
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
    var permission =  await Permission.contacts.status;
    // print(PermissionStatus);
    if (permission == PermissionStatus.granted) {
      macAddress = await GetMac.macAddress;
    }else{
      var permission = await Permission.contacts.request();
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
print("registros ingresados");
  // _showMessageInScaffold('inserted row id: $id');
}

void _showMessageInScaffold(String message) {
  _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      )
  );
}

void validarCheckIn(String cadena, String email, String correlativo1, String fecha1, String nit1, String _macAddress, String usuarioName,String rol, BuildContext context)async{
  // print(res);
  var permission =  await Permission.contacts.status;
  print(permission);
  if (permission == PermissionStatus.granted) {
    if (res == 'OK') {
      _futureAlbum = createAlbum(
          cadena,
          email,
          correlativo1,
          fecha1,
          nit1,
          _macAddress,
          usuarioName, rol);
      guardarDatos(context);
      // _insertVeces(1, "'" + cadena + "'");
    }
    if (res == 'KO') {
      _showDialog(context, "Datos Incorrectos!!", "No se completo el registro");
    }
  }else{
    var permission = await Permission.contacts.request();

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

List <String> dias =[
  '01','02', '03', '04', '05', '06', '07', '08', '09', '10',
  '11','12', '13', '14', '15', '16', '17', '18', '19',
  '20','21', '22', '23', '24', '25', '26', '27', '28', '29',
  '30','31',
];
List <String> actorsName = [
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
