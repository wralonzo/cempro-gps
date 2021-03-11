import 'dart:convert';

import 'package:cempro_gps/formularios/meses_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ClavePage extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<ClavePage> {
  static var _keyValidationForm = GlobalKey<FormState>();
  TextEditingController _textEditCorrelativo = TextEditingController();
  TextEditingController _textEditNit = TextEditingController();
  TextEditingController _textEditFecha = TextEditingController();
  TextEditingController _textEditPassword = TextEditingController();
  TextEditingController _textEditPasswordVerify = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final FocusNode _correlativoFocus = FocusNode(); //added globally
  final FocusNode _nitFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode(); //added globally
  final FocusNode _passwordVerifyFocus = FocusNode();

  // funciones de esta pagina

  Future<String> resetPassword(String correlativo, String nit,
      String fechaNacimiento, String newPassword) async {
    String url = 'http://18.189.26.76:8000/api/recuperarclave';
    Map datos = {
      "correlativo": correlativo,
      "nit": nit,
      "fechanacimiento": fechaNacimiento,
      "nuevaclave": newPassword
    };

    var respuesta = await post(url, body: datos);
    // print(respuesta.body);
    var map = jsonDecode(respuesta.body);
    var mensaje = map['mensaje'];
    print(mensaje);

    if (respuesta.statusCode == 200) {
      if (mensaje == 'Clave actualizada existosamente!') {
        _showDialog(context, "Clave Actualizada!",
            mensaje + '... Para ver los cambios Inicie Sesión.');
      }
      if (mensaje == 'Usuario no existe o se encuentra deshabilitado!') {
        _showDialog(context, "Credenciales no Válidas!", mensaje);
      }
      if (mensaje == 'Usuario no existe') {
        _showDialog(context, "Credenciales no Válidas!", mensaje);
      }
    } else {
      _showDialog(context, "Error!", "Verifique acceso a internet");
    }
  }

  // fin de funciones de esta pagina
  String fecha = '';
  String holder = '';
  String dropdownValue = '2021';
// To show Selected Item in Text.

  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;

  @override
  void initState() {
    super.initState();
    isPasswordVisible = false;
    isConfirmPasswordVisible = false;

    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;

    _dropdownMenuItemsMeses = buildDropdownMenuItemsMeses(_meses);
    _selectedMeses = _dropdownMenuItemsMeses[0].value;
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
      fecha = dropdownValue + '-' + _selectedMeses.id + '-' + dropdownValueDias;
    });
  }

  void getDropDownItem() {
    setState(() {
      holder = dropdownValue;
      // fecha = dropdownValue+'-'+_selectedMeses.id+'-'+dropdownValueDias;
    });
  }

  String dropdownValueDias = '01';
// To show Selected Item in Text.
  String holderDias = '';
  void getDropDownItemDias() {
    setState(() {
      holderDias = dropdownValueDias;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Recuperar Clave'),
        backgroundColor: Colors.lightGreen,
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(200),
                bottomRight: Radius.circular(10))),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.only(top: 32.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                // getWidgetImageLogo(),
                getWidgetRegistrationCard(),
              ],
            )),
      ),
    );
  }

  Widget getWidgetImageLogo() {
    return Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(top: 32, bottom: 32),
          child: Icon(Icons.ac_unit),
        ));
  }

  Widget getWidgetRegistrationCard() {
    // final FocusNode _passwordEmail = FocusNode();
    // final FocusNode _passwordFocus = FocusNode();
    // final FocusNode _passwordConfirmFocus = FocusNode();

    var textFormField = TextFormField(
        controller: _textEditPassword,
        focusNode: _passwordFocus,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        validator: _validatePassword,
        obscureText: !isPasswordVisible,
        decoration: InputDecoration(
            labelText: 'Nueva Clave',
            suffixIcon: IconButton(
              icon: Icon(isConfirmPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                  _validatePasswordVerify(
                      _textEditPassword.text, _textEditPassword.text);
                });
              },
            ),
            icon: Icon(Icons.vpn_key)));
    var textFormFieldConfirmPass = TextFormField(
        controller: _textEditPasswordVerify,
        focusNode: _passwordVerifyFocus,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        validator: _validateConfirmPassword,
        obscureText: !isConfirmPasswordVisible,
        decoration: InputDecoration(
            labelText: 'Confirmar Clave',
            suffixIcon: IconButton(
              icon: Icon(isConfirmPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  isConfirmPasswordVisible = !isConfirmPasswordVisible;
                  _validatePasswordVerify(_textEditPasswordVerify.text,
                      _textEditPasswordVerify.text);
                });
              },
            ),
            icon: Icon(Icons.vpn_key)));
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _keyValidationForm,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text(
                    'Actualizar Clave',
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                ), // title: login
                Container(
                  child: TextFormField(
                    controller: _textEditCorrelativo,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: _validateUserName,
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(_correlativoFocus);
                    },
                    decoration: InputDecoration(
                        labelText: 'Correlativo',
                        //prefixIcon: Icon(Icons.email),
                        icon: Icon(Icons.bookmark)),
                  ),
                ), //text field : user name
                Container(
                  child: TextFormField(
                    controller: _textEditNit,
                    focusNode: _nitFocus,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: _validateEmail,
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(_passwordFocus);
                    },
                    decoration: InputDecoration(
                        labelText: 'N.I.T',
                        //prefixIcon: Icon(Icons.email),
                        icon: Icon(Icons.book)),
                  ),
                ),
                SizedBox(height: 20), //text field: email
                new Center(
                  child: Column(
                    children: <Widget>[
                      Text('Seleccione su Fecha de Nacimiento',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 13)),
                    ],
                  ),
                ),
                Center(
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
                            items: dias
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 13)),
                              );
                            }).toList(),
                          ),
                          Text("  Mes "),
                          DropdownButton(
                            style: TextStyle(color: Colors.green, fontSize: 13),
                            value: _selectedMeses,
                            items: _dropdownMenuItemsMeses,
                            onChanged: onChangeDropdownItemMeses,
                          ),
                          Text(" Año "),
                          DropdownButton<String>(
                            value: dropdownValue,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 13),
                            underline: Container(
                              height: 2,
                              color: Colors.green,
                            ),
                            onChanged: (String data) {
                              setState(() {
                                dropdownValue = data;
                                fecha = dropdownValue +
                                    '-' +
                                    _selectedMeses.id +
                                    '-' +
                                    dropdownValueDias;
                              });
                            },
                            items: actorsName
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 13)),
                              );
                            }).toList(),
                          ),
                        ],
                      )
                    ],
                  ),
                ), //text field: password
                Container(
                  child: textFormField,
                ),
                Container(
                  child: textFormFieldConfirmPass,
                ),
                Container(
                  margin: EdgeInsets.only(top: 32.0),
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    elevation: 5.0,
                    padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: Text(
                      'Actualizar Clave',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    onPressed: () {
                      if (_keyValidationForm.currentState.validate()) {}
                      if (match_password(_textEditPassword.text,
                              _textEditPasswordVerify.text) ==
                          true) {
                        resetPassword(_textEditCorrelativo.text,
                            _textEditNit.text, fecha, _textEditPassword.text);
                        // print(_textEditPassword.text);
                      } else {
                        _showDialog(context, "Error en Claves!",
                            "Ingrese Claves Iguales");
                      }
                      _textEditCorrelativo.text = '';
                      _textEditNit.text = '';
                      _textEditPassword.text = '';
                      _textEditPasswordVerify.text = '';
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                ), //button: login
                Container(
                    margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '',
                        ),
                        InkWell(
                          splashColor: Colors.blueAccent.withOpacity(0.5),
                          onTap: () {
                            _onTappedTextlogin();
                          },
                          child: Text(
                            '',
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _validateUserName(String value) {
    return value.trim().isEmpty ? "Nombre Vacío" : null;
  }

  String _validateEmail(String value) {
    // Pattern pattern =
    //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    // RegExp regex = new RegExp(pattern);
    // if (!regex.hasMatch(value)) {
    //   return 'Correo Incorrecto';
    // } else {
    //   return null;
    // }
    return value.length < 7 ? 'Minimo 7 Caracteres' : null;
  }

  String _validatePassword(String value) {
    return value.length < 5 ? 'Minimo 5 Caracteres' : null;
  }

  String _validateConfirmPassword(String value) {
    return value.length < 5 ? 'Minimo 5 Caracteres' : null;
  }

  bool match_password(String pass, String passVerify) {
    if (pass == passVerify) {
      return true;
    } else {
      return false;
    }
  }

  String _validatePasswordVerify(String value, String temp) {
    return value.toString() == temp.toString() ? 'Claves Diferentes' : null;
  }

  void _limpiarInputs(
      String valueC, String valueN, String valueP, String valueVp) {
    valueC = '';
    valueN = '';
    valueP = '';
    valueVp = '';
  }

  void _onTappedTextlogin() {}
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

List<String> dias = [
  '01',
  '02',
  '03',
  '04',
  '05',
  '06',
  '07',
  '08',
  '09',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23',
  '24',
  '25',
  '26',
  '27',
  '28',
  '29',
  '30',
  '31',
];
List<String> actorsName = [
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
];
