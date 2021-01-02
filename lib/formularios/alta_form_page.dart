import 'dart:async';
import 'dart:math';

// import 'package:android_device_info/android_device_info.dart';
import 'package:cempro_gps/formularios/politicas.dart';
import 'package:cempro_gps/helpers/mi_button.dart';
import 'package:cempro_gps/helpers/sqlLite_helper.dart';
import 'package:cempro_gps/login/login_page.dart';
import 'package:cempro_gps/modelos/login_class.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_mac/get_mac.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

int contador = 0;
bool rememberMe = false;
String _macAddress = "Unknown";
// String _noPhone = 'Unknown';
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

  var respuesta = await http.post(urlCheck,body: datos );
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

Future<AltaForm> createAlbum(String usuarioGenerado, String correo, String correlativo, String fecha, String nit, String macAddres, String motivo) async {
  final http.Response response = await http.post(
    'http://18.189.26.76:8000/api/user',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "name": usuarioGenerado,
      "email": correo,
      "fechanacimiento": fecha,
      "correlativo": correlativo,
      "macaddress": macAddres,
      "nit": nit,
      "politicas": "si",
      "estado": "activo",
      "motivoalta": motivo
    }),


  );

  if (response.statusCode == 200) {
    // var jsonResponse = convert.jsonDecode(response.body);
    // itemCount = jsonResponse['name'];
    return AltaForm.fromJson(jsonDecode(response.body));

  } else {
    throw Exception('Failed to create album.');
  }
}

class AltaForm {
  final int id;
  final String name;

  AltaForm({this.id, this.name});

  factory AltaForm.fromJson(Map<String, dynamic> json) {
    return AltaForm(
      id: json['id'],
      name: json['name'],
    );
  }
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
  final TextEditingController fecha = TextEditingController();
  // String correlativo ='';
  // String fecha = '';
  // String nit = '';
  String motivoAlta = '';
  String email = '';
  Elementos ele = new Elementos();
  Elementos2 ele2 = new Elementos2();

  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    super.initState();
    getMacAddress();
    // getImei();
    // getNumberPhone();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    // Future<void> mimac = getMacAddress();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Column(

        children: <Widget>[

          new ListTile(

            leading: const Icon(Icons.vpn_key_outlined),
            title: new TextField(
              controller: correlativo,
              decoration: new InputDecoration(
                hintText: "Correlativo",
              ),
            ),
          ),
          // Spacer(flex: 1),
          new ListTile(
            leading: const Icon(Icons.date_range),
            title: new TextField(
              controller: fecha,
              decoration: new InputDecoration(
                hintText: "Fecha",
              ),
            ),
          ),

          new ListTile(
            leading: const Icon(Icons.credit_card_sharp),
            title: new TextField(
              controller: nit,
              onChanged: (text) {
                  text = nit.text;
                  checkIn(text, nit.text, fecha.text);

              },
              decoration: new InputDecoration(
                hintText: "NIT",
              ),

            ),
          ),
          const Divider(
            height: 1.0,
          ),

          new ListTile(
            leading: const Icon(Icons.attach_email),
            title: new TextField(
              onChanged: (texto) {
                email = texto;

              },
              decoration: new InputDecoration(
                hintText: "Correo Electronico",
              ),
            ),
          ),

          new DropdownButton(
            hint: Text("Motivo de Alta"),
            style: TextStyle(color: Colors.green),
            icon: Icon(Icons.set_meal_sharp),
            value: _selectedCompany,
            items: _dropdownMenuItems,
            onChanged: onChangeDropdownItem,
          ),

          new Text('', style: TextStyle(color: Colors.white)),
          if(rememberMe == false || contador < 1)
          ele.wBoton("Politicas de usuario", pAccion: () => { irPoliticas(context) }),

          Text(""),
          Text("Aceptar Politicas"),
          Checkbox(
            value: rememberMe,
            onChanged: (bool newValue) {
              setState(() {
                contador = 1;
                rememberMe = newValue;

                checkIn(correlativo.text, nit.text, fecha.text);
                // print(correlativo.text);
              });
            },
          ),
          if(rememberMe == true && contador > 0)
            RaisedButton(
              onPressed: ()async {
                setState(() {
                  numeroAleatorio = new Random().nextInt(99);
                });
                var permisos = await Permission.phone.status;
                if(permisos == PermissionStatus.granted){
                checkIn(correlativo.text, nit.text, fecha.text);
                _insertVeces(1, "Nombre");
                print(res);
                nombre = _selectedCompany.name;
                if(res == 'OK'){
                  print(correlativo.text);
                  cadena1 = nombre1.substring(0, 1);
                  cadena1 = cadena1+nombre2.substring(0,2)+lastName1+numeroAleatorio.toString();
                  print(cadena1);
                  _futureAlbum = createAlbum(cadena1, email, correlativo.text, fecha.text, nit.text, _macAddress, nombre);
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage(),));
                }else{
                  _showDialog(context, "Datos incorrectos!!", 'Ingrese Campos correctos');
                  print(numeroAleatorio);
                }
                }else{
                  var per = Permission.phone.request();
                }
              },
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                height: 50,
                width: 200,
                // color: Colors.green,
                padding: const EdgeInsets.all(15.0),
                child: Text("Guardar datos", style: TextStyle(fontSize: 15), textAlign: TextAlign.center ),
              ),
              color: Colors.green,
              // shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  side: BorderSide(color: Colors.green)),
            ),

          if(contador < 1 || rememberMe == false)
            Text("Lea las politicas para continuar"),
        ],
      ),
    );
  }
}

class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getCompanies() {
    return <Company>[
      Company(1, 'Motivo de Alta'),
      Company(2, 'Nuevo Ingreso a CEMPRO'),
      Company(3, 'Cambio de celular'),
      Company(4, 'Cambio de correlativo'),
    ];
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

// Inicio funcion imei and macaddres
// Future<String> getImei() async {
//   String imei;
//   imei = await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
//   _noImei = imei;
//   return _noImei;
// }

// fin imei
//mac address
Future<String> getMacAddress() async {
  String macAddress;
    var permission =  await Permission.phone.status;
    print(PermissionStatus);
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
print("registros ingresados");
  // _showMessageInScaffold('inserted row id: $id');
}

//inicio numero de telefono
// void getNumberPhone() async {
//   // var data = {};
//   var data = await AndroidDeviceInfo().getSystemInfo();
//   var permission =  await PermissionHandler().checkPermissionStatus(PermissionGroup.phone);
//   if (permission == PermissionStatus.denied) {
//     var permissions =  await PermissionHandler().requestPermissions([PermissionGroup.phone]);
//     if (permissions[PermissionGroup.phone] == PermissionStatus.granted) {
//       data = await AndroidDeviceInfo().getSystemInfo();
//       data.addAll(data);
//     }
//   }
//   _noPhone = data['phoneNo'];
// }
void _showMessageInScaffold(String message) {
  _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      )
  );
}

void validarCheckIn(String cadena, String email, String correlativo1, String fecha1, String nit1, String _macAddress, String usuarioName, BuildContext context)async{
  print(res);
  var permission =  await Permission.phone.status;
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
          usuarioName);
      guardarDatos(context);
      // _insertVeces(1, "'" + cadena + "'");
    }
    if (res == 'KO') {
      _showDialog(context, "Datos Incorrectos!!", "No se completo el registro");
    }
  }else{
    var permission = await Permission.phone.request();

  }
  // else{
  //   _showDialog(context, "Datos Incorrectos!!", "No se completo el registro");
  // }
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
