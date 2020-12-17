import 'package:cempro_gps/formularios/politicas.dart';
import 'package:cempro_gps/home/welcome_page.dart';
import 'package:cempro_gps/login/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

class _MyHomePageState extends State<MyHomePage> {
  bool rememberMe = false;
  int contador = 0;
  void _onRememberMeChanged(bool newValue) => setState(() {
    rememberMe = newValue;

    if (rememberMe) {
      // TODO: Here goes your functionality that remembers the user.
    } else {
      // TODO: Forget the user
    }
  });

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Added to favorite'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    super.initState();
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

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
        // leading: new IconButton(
        //   icon: new Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => HomePage()),
        //     );
        //   },
        // ),
      ),
      body: new Column(
        children: <Widget>[
          new ListTile(
            leading: const Icon(Icons.person),
            title: new TextField(
              decoration: new InputDecoration(
                hintText: "Fecha",
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.phone),
            title: new TextField(
              decoration: new InputDecoration(
                hintText: "Correlativo",
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.email),
            title: new TextField(
              decoration: new InputDecoration(
                hintText: "Fecha nacimiento",
              ),
            ),
          ),
          const Divider(
            height: 1.0,
          ),
          new ListTile(
            leading: const Icon(Icons.label),
            title: const Text('Wilson'),
            subtitle: const Text('Nombre'),
            trailing: const Icon(Icons.check_circle, color: Colors.green,),
          ),
          new ListTile(
            leading: const Icon(Icons.today),
            title: const Text('123456-6'),
            subtitle: const Text('NIT'),
            trailing: const Icon(Icons.check_circle, color: Colors.green,),
          ),
          new ListTile(
            leading: const Icon(Icons.label),
            title: const Text('45549019'),
            subtitle: const Text('No. Celular'),
            trailing: const Icon(Icons.check_circle, color: Colors.green,),
          ),
          new ListTile(
            leading: const Icon(Icons.label),
            title: const Text('132141432443'),
            subtitle: const Text('IMEI'),
            trailing: const Icon(Icons.check_circle, color: Colors.green,),
          ),

          new DropdownButton(
            hint: Text("Motivo de Alta"),
            style: TextStyle(color: Colors.green),
            icon: Icon(Icons.set_meal_sharp),
            value: _selectedCompany,
            items: _dropdownMenuItems,
            onChanged: onChangeDropdownItem,
          ),

          new Text('Revisar polititcas!', style: TextStyle(color: Colors.white)),
          MaterialButton(
            minWidth: 200.0,
            height: 50.0,
            color: Colors.green,
            child: Text('Politicas de usuario', style: TextStyle(color: Colors.white)),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Politicas()),
              );
              contador = 1 +1 ;
            },
          ),
          Text("Aceptar Politicas"),
          Checkbox(
              value: rememberMe,
            onChanged: (bool newValue) {
              setState(() {
                rememberMe = newValue;
                // Navigator.pushNamed(context, '/home');
              });
            },
          ),
          if(rememberMe == true && contador > 0)
            MaterialButton(
              minWidth: 200.0,
              height: 50.0,
              color: Colors.green,
              child: Text('Guardar Datos', style: TextStyle(color: Colors.white)),
              onPressed:  (){
                contador = 0;
                rememberMe = false;
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login() )
                );
              },
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
