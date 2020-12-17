import 'package:cempro_gps/cards/modulos.dart';
import 'package:cempro_gps/formularios/alta_form_page.dart';
import 'package:cempro_gps/formularios/politicas.dart';
import 'package:cempro_gps/login/login_page.dart';
import 'package:cempro_gps/pages/BusesPage.dart';
import 'package:cempro_gps/pages/ViaticosPage.dart';
import 'package:cempro_gps/pages/marcaje_page.dart';
import 'package:flutter/material.dart';

import '../main.dart';
// import 'package:cempro_gps/services/auth.service.dart';

class HomePage extends StatelessWidget {final snackBar = SnackBar(
  content: Text("e.message"),
);

  @override
  Widget build(BuildContext context) => new Scaffold(

      appBar: new AppBar(
      backgroundColor: Colors.green,
      automaticallyImplyLeading: false,
      title: new Text('Cempro GPS'),
      actions: [
        Image.asset('assets/logo.png',fit: BoxFit.contain,height: 32, color: Colors.white), // here add notification icon
        Container(padding: const EdgeInsets.all(2.0))
      ],
    ),
    body: new Container(


      alignment: Alignment.center,
      child: new Column(

          children: <Widget>[
            new Text('Benvenido USUARIO1 !', style: TextStyle(color: Colors.white)),
          new Text('Benvenido USUARIO1 !', style: TextStyle(color: Colors.green)),
            new Text('Benvenido USUARIO1 !', style: TextStyle(color: Colors.white)),
            // MaterialButton(
            //   minWidth: 200.0,
            //   height: 100.0,
            //   color: Colors.lightGreen,
            //   child: Text('Formulario de Alta', style: TextStyle(color: Colors.white)),
            //   onPressed: (){
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => FormDeAlta()),
            //     );
            //   },
            // ),
            new Text('Benvenido USUARIO1 !', style: TextStyle(color: Colors.white)),
            MaterialButton(
              minWidth: 200.0,
              height: 100.0,
              color: Colors.green,
              child: Text('Marcajes', style: TextStyle(color: Colors.white)),
              onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MarcajePage()),
                  );
                  },
            ),

            new Text('Benvenido USUARIO1 !', style: TextStyle(color: Colors.white)),
            MaterialButton(
              minWidth: 200.0,
              height: 100.0,
              color: Colors.lightGreen,
              child: Text('Buses', style: TextStyle(color: Colors.white)),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BusesPage()),
                );
              },
            ),

            new Text('Benvenido USUARIO1 !', style: TextStyle(color: Colors.white)),
            MaterialButton(
              minWidth: 200.0,
              height: 100.0,
              color: Colors.lightBlueAccent,
              child: Text('Viaticos', style: TextStyle(color: Colors.white)),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViaticosPage()),
                );
              },
            ),
            new Text('Benvenido USUARIO1 !', style: TextStyle(color: Colors.white)),
            MaterialButton(
              minWidth: 200.0,
              height: 100.0,
              color: Colors.cyan,
              child: Text('Politicas de usuario', style: TextStyle(color: Colors.white)),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Politicas()),
                );
              },
            ),
            new Text('Benvenido USUARIO1 !', style: TextStyle(color: Colors.white)),
            MaterialButton(
              minWidth: 200.0,
              height: 100.0,
              color: Colors.orangeAccent,
              child: Text('Salir', style: TextStyle(color: Colors.white)),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login())
                  // onPressed: ()=> exit(0),

                );
              },
            ),
      ],

      ),
    ),
  );
}
List<Modulos> persons = [
  Modulos(name: 'Geolocalización', profileImg: 'assets/logo.png', bio: "Software Developer", ruta: '/cartas'),
  Modulos(name: 'Formulario de alta', profileImg: 'assets/logo.png', bio: "UI Designer", ruta: '/cartas'),
  Modulos(name: 'Cuerdo de licencia', profileImg: 'assets/logo.png', bio: "Software Tester", ruta: '/welcome')
];

Widget personDetailCard(Person) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Card(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(Person.profileImg)
                      )
                  )),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(Person.name,
                  style: TextStyle (
                      color: Colors.white,
                      fontSize: 18
                  ),
                ),
                Text(Person.ruta,
                  style: TextStyle (
                      color: Colors.red,
                      fontSize: 18
                  ),
                ),
                Text(Person.bio,
                  style: TextStyle (
                      color: Colors.white,
                      fontSize: 12
                  ),
                  
                ),

              ],
            ),
          ],

        ),
      ),
    ),
  );
}


class CustomListTile extends StatelessWidget{

  final IconData icon;
  final  String text;
  final Function onTap;

  CustomListTile(this.icon, this.text, this.onTap);
  @override
  Widget build(BuildContext context){
    //ToDO
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child:Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade400))
        ),
        child: InkWell(
            splashColor: Colors.orangeAccent,
            onTap: onTap,
            child: Container(
                height: 40,
                child: Row(
                  mainAxisAlignment : MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Icon(icon),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                      ),
                      Text(text, style: TextStyle(
                          fontSize: 16
                      ),),
                    ],),
                    Icon(Icons.arrow_right)
                  ],)
            )
        ),
      ),
    );
  }
}


void _showToast(context) {
  final scaffold = Scaffold.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: const Text('Added to favorite'),
      action: SnackBarAction(
          label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}