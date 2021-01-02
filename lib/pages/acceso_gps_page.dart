import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AccesoGpsPage extends StatefulWidget{
  @override
  _AccesoGpsPageState createState() => _AccesoGpsPageState();
}

class _AccesoGpsPageState extends State<AccesoGpsPage> {
  void initState() {
    super.initState();
    permisoGPS(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text('Para continuar active el GPS'),
          MaterialButton(
            child: Text('Solicitar Acceso', style: TextStyle(color: Colors.white)),
            color: Colors.green,
            shape: StadiumBorder(),
            elevation: 0,
            splashColor:  Colors.transparent,
            onPressed: () async {
              // final status = await PermissionGroup.location()
              // final status = await PermissionHandler().checkPermissionStatus(PermissionGroup.location) ;
              //
              // print( status );
              // accessGPS(status, context);
              // PermissionHandler().requestPermissions([PermissionGroup.camera, PermissionGroup.location]);
              // Navigator.pushReplacementNamed(context, 'mapa');
              permisoGPS(context);


              //moficicar permisos
            })
          ],)
      )
    );
  }
}


void accessGPS ( PermissionStatus status, context) async{
  switch (status){

    // case Permi.unknown:
    //   PermissionHandler().openAppSettings();
    //   break;
    // case PermissionStatus.granted:
    //   Navigator.pushReplacementNamed(context, 'mapa');
    //   break;
    // case PermissionStatus.disabled:
    // case PermissionStatus.denied:
    // case PermissionStatus.restricted:
    //   await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
    // break;
      // PermissionHandler().openAppSettings();


    case PermissionStatus.undetermined:
      openAppSettings();
      break;
    case PermissionStatus.granted:
      // TODO: Handle this case.
      Navigator.pushReplacementNamed(context, 'mapa');
      break;
    case PermissionStatus.denied:
    case PermissionStatus.restricted:
    case PermissionStatus.permanentlyDenied:
      Permission.location.request();
      break;
  }
}

void permisoGPS(context) async{
  final status = await Permission.location.status;
  if(status == PermissionStatus.denied){
    Permission.location.request();
  }
  if(status == PermissionStatus.restricted){
    // PermissionHandler().openAppSettings();
    Permission.location.request();
  }if(status == PermissionStatus.permanentlyDenied){
    Permission.location.request();
  }if(status == PermissionStatus.undetermined){
    Permission.location.request();
  }if(status == PermissionStatus.granted){
  }else{
    openAppSettings();
  }
}