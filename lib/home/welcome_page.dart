import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cempro_gps/bascode/darcode_page.dart';
import 'package:cempro_gps/constantes/url_helper.dart';
import 'package:cempro_gps/login/recovery_password.dart';
import 'package:cempro_gps/pages/mapa_page.dart';
import 'package:cempro_gps/login/login_page.dart';
import 'package:cempro_gps/qrcode/generate.dart';
import 'package:cempro_gps/qrcode/scan.dart';
import 'package:cempro_gps/mensajes/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as httpPermisos;
import 'package:flutter/services.dart' show rootBundle;

class HomePage extends StatefulWidget {
  final String usuario;
  final int idUsuario;
  final String correlativo;
  final String rol;
  final String nombre;
  final String rolGPS;
  final String rolQR;
  final String rolCarne;
  final String rolMSM;
  final String rolPASS;
  // final String rolSES;
  final String rolODH;
  final String rolEVENT;
  final String rolSAP;
  final String rolNEXO;
  final String urlBUS;
  final String urlNexo;
  final String urlSAP;
  String mensajesICON;
  String logoURL;
  HomePage(
      this.usuario,
      this.idUsuario,
      this.correlativo,
      this.rol,
      this.nombre,
      this.rolGPS,
      this.rolQR,
      this.rolCarne,
      this.rolMSM,
      this.rolPASS,
      // this.rolSES,
      this.rolODH,
      this.rolEVENT,
      this.rolSAP,
      this.rolNEXO,
      this.urlBUS,
      this.urlNexo,
      this.urlSAP,
      this.mensajesICON,
      this.logoURL
  );
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var data;
  var dataMensajes;
  String logoUrl = '';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  final TextEditingController _cantidadMensajes = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showNotifications();
    initializing();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings androidInitializationSettings;
    IOSInitializationSettings iosInitializationSettings;
    InitializationSettings initializationSettings;
    BackButtonInterceptor.add(myInterceptor);
    HttpOverrides.global = new MyHttpOverrides();
    const oneSec = const Duration(seconds: 100);
    Timer.periodic(oneSec, (Timer timer) {
      _showNotifications();// This statement will be printed after every one second
    });
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }
  void initializing() async {
    androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void _showNotifications() async {
    Map msjSinLeer = {"correlativo": widget.correlativo};
    var responseMensajesSinLeer = await httpPermisos.post(URL_BASE + 'mensajesnuevos',
        headers: {
          "Accept": "application/json",
          "APP-KEY": APP_KEY,
          "APP-SECRET": APP_SECRET
        },
        body: msjSinLeer);
    dataMensajes = json.decode(responseMensajesSinLeer.body);
    // print(dataMensajes['mens'].toString());
    // setState(() {
    _cantidadMensajes.text = dataMensajes['mens'].toString();
    if(dataMensajes['mens'] > 0){
      await notification();
    }
  }

  Future<void> notification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'Channel ID', 'Channel title', 'channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'test');
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(1, 'Hola! ' + widget.usuario,
        'Tienes mensajes nuevos', notificationDetails,
        payload: "Mensajes");
  }

  Future onSelectNotification(String payLoad) async {
    if (payLoad != null) {
      Map datos = {"correlativo": widget.correlativo};
      var response = await httpPermisos.post(URL_BASE + 'mensajesporusuario',
          headers: {
            "Accept": "application/json",
            "APP-KEY": APP_KEY,
            "APP-SECRET": APP_SECRET
          },
          body: datos);

      Map msjSinLeer = {"correlativo": widget.correlativo};
      var responseMensajesSinLeer = await httpPermisos.post(URL_BASE + 'mensajesnuevos',
          headers: {
            "Accept": "application/json",
            "APP-KEY": APP_KEY,
            "APP-SECRET": APP_SECRET
          },
          body: msjSinLeer);
      dataMensajes = json.decode(responseMensajesSinLeer.body);
      data = json.decode(response.body);
      if(response.statusCode == 200){
        data = json.decode(response.body);
        int numeroMensajes = data.length;
        if(dataMensajes['mens'] > 0){
          _showDialogMensajes(context, ' Mensajes Nuevos', data[numeroMensajes-1]['descripcion'], data[numeroMensajes-1]['id']);
          _cantidadMensajes.text = dataMensajes['mens'].toString();
          // print(dataMensajes['mens'].toString());
        }

      }
    }
  }
  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }
  Future<String> leeMensajes(String usuario) async {
    Map datos = {"id": usuario};
    var response = await httpPermisos.post(URL_BASE + 'mensajeleidio',
        headers: {
          "Accept": "application/json",
          "APP-KEY": APP_KEY,
          "APP-SECRET": APP_SECRET
        },
        body: datos);
    if (response.statusCode == 200) {

    }
  }

  void _showDialogMensajes(context, titulo, contenido, idmensaje) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(titulo),
          content: new SingleChildScrollView(
            child: Container(child: Text(contenido, style: TextStyle(fontFamily: 'Gill'))),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close", style: TextStyle(fontFamily: 'Gill')),
              onPressed: () {
                Navigator.of(context).pop();

              },

            ),
            new FlatButton(
              child: new Text("Ver Mensajes", style: TextStyle(fontFamily: 'Gill')),
              onPressed: () {
                _cantidadMensajes.text = '0';
                leeMensajes(idmensaje);
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(widget.correlativo, widget.idUsuario.toString())),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // print('jajaj');
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
            },
            child: Text("Okay")),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          Fluttertoast.showToast(
            msg: 'Some text',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
          );
          return false;
        },
        child: Scaffold(
          appBar: new AppBar(
            backgroundColor: Color.fromRGBO(193, 216, 47, 0.8),
            // leading: Image.asset('assets/candado.png'),
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.rolPASS == 'Activo')
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PasswordPage(widget.nombre)),
                        );
                      }, // Handle your callback.
                      splashColor: Colors.brown.withOpacity(0.5),
                      child: Ink(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/candado.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  Text(widget.usuario,
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontFamily: 'Gill',
                          fontSize: 25,
                          color: Color.fromRGBO(14, 123, 55, 99.0))),
                ],
              ),
            ),
            actions: [
              // if( widget.rolSES == true)
              IconButton(
                // icon: Icon(Icons.power_settings_new_rounded, color: Color.fromRGBO(0, 99, 38, 50)),
                icon: new Image.asset('assets/sesion.png'),
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                iconSize: 50,
                color: Colors.black,
                splashColor: Colors.redAccent,
              )
            ],
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(200),
                    bottomRight: Radius.circular(10))),
          ),
          body: SingleChildScrollView(
              child: Center(
                  // alignment: Alignment.center,/
                  child: new Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 5),
                        Center(
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                      // SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(URL_LOGO+widget.logoURL,
                                      width: 150, height: 150, fit: BoxFit.cover),
                                ],
                              ),
                            ],
                          ),
                        ),
                // SizedBox(height: 10),
                    SizedBox(
                      height: 5,
                    ),
                Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (widget.rolGPS == 'Activo')
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MapaPage(
                                          widget.nombre,
                                          widget.idUsuario,
                                          widget.correlativo)),
                                );
                              }, // Handle your callback.
                              splashColor: Colors.redAccent,
                              child: Ink(
                                height: 100,
                                width: 165,
                                decoration: BoxDecoration(
                                  // color: Colors.redAccent,
                                  image: DecorationImage(
                                    image: AssetImage('assets/mapa.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          if (widget.rolQR == 'Activo')
                            InkWell(
                              onTap: () {
                                // print(_cantidadMensajes.text);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ScanScreen(
                                          widget.nombre,
                                          widget.idUsuario,
                                          widget.correlativo)),
                                );
                              }, // Handle your callback.
                              splashColor: Colors.brown.withOpacity(0.5),
                              child: Ink(
                                height: 100,
                                width: 178,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/qrScanner.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (widget.rolGPS == 'Activo')
                            Text('Marcaje GPS',
                                style: TextStyle(
                                    color: Color.fromRGBO(84, 87, 89, 50),
                                    fontSize: 15,
                                    fontFamily: 'Gill')),
                          if (widget.rolQR == 'Activo')
                            Text('Marcaje QR',
                                style: TextStyle(
                                    color: Color.fromRGBO(84, 87, 89, 50),
                                    fontSize: 15,
                                    fontFamily: 'Gill')),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (widget.rolCarne == 'Activo')
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BarcodePage(
                                          widget.nombre,
                                          widget.idUsuario,
                                          widget.correlativo)),
                                );
                              }, // Handle your callback.
                              splashColor: Colors.brown.withOpacity(0.5),
                              child: Ink(
                                height: 100,
                                width: 165,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/barcode.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          if (widget.rolMSM == 'Activo')
                            InkWell(
                              onTap: () {
                                _cantidadMensajes.text = '0';
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChatScreen(widget.correlativo, widget.idUsuario.toString())),
                                );
                              }, // Handle your callback.
                              splashColor: Colors.brown.withOpacity(0.5),
                              child: Ink(
                                child: new Stack(
                                  children: <Widget>[
                                    SizedBox(height: 50),
                                       Positioned(
                                        // height: ,
                                        bottom: 46,
                                        right: 43,
                                        child: new Container(
                                          padding: EdgeInsets.all(2),
                                          decoration: new BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          constraints: BoxConstraints(
                                            minWidth: 2,
                                            minHeight: 2,
                                          ),
                                          child: Container(
                                              // margin: EdgeInsets.all(12),
                                              padding: EdgeInsets.all(0),
                                            // alignment: AlignmentGeometry.,
                                            height: 25,
                                            width: 25,
                                            child: TextField(
                                                style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Gill'),
                                                textAlign: TextAlign.center,
                                                readOnly: false,
                                                enabled: false,
                                                controller: _cantidadMensajes,
                                                onChanged: (text) {
                                                  text = _cantidadMensajes.text;
                                                },
                                              )
                                          ),
                                          ),
                                        )
                                  ],
                                ),
                                height: 100,
                                width: 160,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/mensajes.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (widget.rolCarne == 'Activo')
                            Text('Marcaje Carné     ',
                                style: TextStyle(
                                    color: Color.fromRGBO(84, 87, 89, 50),
                                    fontSize: 15,
                                    fontFamily: 'Gill')),
                          if (widget.rolMSM == 'Activo')
                            Text('Mensajes',
                                style: TextStyle(
                                    color: Color.fromRGBO(84, 87, 89, 50),
                                    fontSize: 15,
                                    fontFamily: 'Gill')),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          if (widget.rolEVENT == 'Activo')
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GenerateScreen()),
                                );
                              }, // Handle your callback.
                              splashColor: Colors.brown.withOpacity(0.5),
                              child: Ink(
                                height: 100,
                                width: 185,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/qrScanner.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          if( widget.rolNEXO == 'Activo')
                            InkWell(
                              onTap: () {
                                _launchURL(widget.urlNexo);
                              }, // Handle your callback.
                              splashColor: Colors.brown.withOpacity(
                                  0.5),
                              child: Ink(
                                height: 100,
                                width: 165,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/nexo.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (widget.rolEVENT == 'Activo')
                            Text('Evento QR  ',
                                style: TextStyle(
                                    color: Color.fromRGBO(84, 87, 89, 50),
                                    fontSize: 15,
                                    fontFamily: 'Gill',
                                     )),
                          if (widget.rolNEXO == 'Activo')
                            Text('Nexo',
                                style: TextStyle(
                                    color: Color.fromRGBO(84, 87, 89, 50),
                                    fontSize: 15,
                                    fontFamily: 'Gill')),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                    child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (widget.rolODH == 'Activo')
                          InkWell(
                            onTap: () {
                              _launchURL(widget.urlBUS);
                            }, // Handle your callback.
                            splashColor: Colors.brown.withOpacity(0.5),
                            child: Ink(
                              height: 100,
                              width: 165,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/buses.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        if (widget.rolSAP == 'Activo')
                          InkWell(
                            onTap: () {
                              _launchURL(widget.urlSAP);
                            }, // Handle your callback.
                            splashColor: Colors.brown.withOpacity(0.5),
                            child: Ink(
                              height: 100,
                              width: 165,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/sap.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      // crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        if (widget.rolODH == 'Activo')
                          Text(' Planificación Servicios           ',
                              style: TextStyle(
                                  color: Color.fromRGBO(84, 87, 89, 50),
                                  fontSize: 15,
                                  fontFamily: 'Gill')),
                        if (widget.rolSAP == 'Activo')
                          Text('SAP              ',
                              style: TextStyle(
                                  color: Color.fromRGBO(84, 87, 89, 50),
                                  fontSize: 15,
                                  fontFamily: 'Gill')),
                      ],
                    )
                  ],
                )
                    // ],
                    ),
                SizedBox(height: 15),
                Center
                  (
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          // if( widget.rolODH == 'Activo')
                            InkWell(
                              onTap: () {
                                _launchURL('tel:+502 23688777');
                              }, // Handle your callback.
                              splashColor: Colors.brown.withOpacity(
                                  0.5),
                              child: Ink(
                                height: 100,
                                width: 165,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/serviciocliente.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // if( widget.rolODH == 'Activo')
                            Text('Call Center', style: TextStyle(
                                color: Color.fromRGBO(84, 87, 89, 50),
                                fontSize: 15,
                                fontFamily: 'Gill')),
                        ],
                      ),
                    ],
                  ),
                  // ],
                ),
            SizedBox(height: 30)
              ],
            ),
          ),

              ),
          ),
          bottomNavigationBar: Container(
            alignment: AlignmentDirectional.center,
            height: 50,
            color: Color.fromRGBO(0, 98, 41, 0.9),
            child: Text('Powered by Progreso', textAlign: TextAlign.center, style: TextStyle(fontSize:20, color: Colors.white, fontFamily: 'Gill'))
        ),

        )
    );
  }
}

_launchURL(String url) async {
  // const url = 'http://serviciosodh.progreso.com';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }

}
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
            child: new Text("Sí Cerrar App", style: TextStyle(fontFamily: 'Gill')),
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
