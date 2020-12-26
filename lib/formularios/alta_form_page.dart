import 'package:android_device_info/android_device_info.dart';
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
import 'dart:async';

int contador = 0;
bool rememberMe = false;
String _macAddress = "Unknown";
String _noPhone = 'Unknown';
String _noImei = "Unknown";
final dbHelper = DatabaseHelper.instance;
Future<AltaForm> _futureAlbum;

Future<AltaForm> createAlbum(String correo, String correlativo, String fecha, String nit, String macAddres) async {
  final http.Response response = await http.post(
    'http://18.189.26.76:8000/api/user',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "email": correo,
      "fechanacimiento": fecha,
      "correlativo": correlativo,
      "macaddress": macAddres,
      "nit": nit,
      "politicas": "si",
      "estado": "activo"
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

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


class _MyHomePageState extends State<MyHomePage> {

  String correlativo ='';
  String fecha = '';
  String nit = '';
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
    getNumberPhone();
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
              onChanged: (texto) {
                correlativo = texto;
              },
              decoration: new InputDecoration(
                hintText: "Correlativo",
              ),
            ),
          ),
          // Spacer(flex: 1),
          new ListTile(
            leading: const Icon(Icons.date_range),
            title: new TextField(
              onChanged: (texto) {
                fecha = texto;
              },
              decoration: new InputDecoration(
                hintText: "Fecha",
              ),
            ),
          ),

          new ListTile(
            leading: const Icon(Icons.credit_card_sharp),
            title: new TextField(
              onChanged: (texto) {
                nit = texto;
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

          // new ListTile(
          //   leading: const Icon(Icons.label),
          //   title: Text(_noPhone),
          //   subtitle: Text('No Phone'),
          //   trailing: const Icon(Icons.check_circle, color: Colors.green,),
          // ),
          // const Divider(
          //   height: 1.0,
          // ),
          // new ListTile(
          //   leading: const Icon(Icons.label),
          //   title:  Text(_macAddress),
          //   subtitle: const Text('No. Mac Adddres'),
          //   trailing: const Icon(Icons.check_circle, color: Colors.green),
          // ),
          // new ListTile(
          //   leading: const Icon(Icons.email),
          //   title: Text(_noImei),
          //   subtitle: Text('Email'),
          //   trailing: const Icon(Icons.check_circle, color: Colors.green,),
          // ),

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
                // _futureAlbum = createAlbum("correlativo api", "2020-12-12", "4545646", _macAddress);
              });
            },
          ),
          if(rememberMe == true && contador > 0)
            RaisedButton(
              onPressed: () {
                guardarDatos(context);
                _insertVeces(1, "'"+_noPhone+"'");
                _futureAlbum = createAlbum(email, correlativo, fecha, nit, _macAddress);
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
      Company(2, 'Persona de nuevo ingreso a la APP'),
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
  try{
    macAddress = await GetMac.macAddress;
  }on PlatformException{
    macAddress = "Fallo al obtener el nacaddress";
  }
  _macAddress = macAddress;
  return _macAddress;
}
//fin imei and macaddress
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
void getNumberPhone() async {
  // var data = {};
  var data = await AndroidDeviceInfo().getSystemInfo();
  var permission =
  await PermissionHandler().checkPermissionStatus(PermissionGroup.phone);
  if (permission == PermissionStatus.denied) {
    var permissions =
    await PermissionHandler().requestPermissions([PermissionGroup.phone]);
    if (permissions[PermissionGroup.phone] == PermissionStatus.granted) {
      data = await AndroidDeviceInfo().getSystemInfo();
      data.addAll(data);
    }
  }
  _noPhone = data['phoneNo'];
}
void _showMessageInScaffold(String message) {
  _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      )
  );
}
// void getImei() async{
//   DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//   const MethodChannel _channel = const MethodChannel('device_id');
//   // var data =
//   _noImei = await _channel.invokeMethod('getIMEI');
// }
// Future<void> getImei() async {
//   // const MethodChannel _channel = const MethodChannel('device_id');
//
//   _noImei  = await DeviceId.getID;
//   return _noImei ;
// }