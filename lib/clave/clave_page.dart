import 'package:flutter/material.dart';

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
  final FocusNode _nitFocus = FocusNode(); //added globally
  final FocusNode _fechaFocus = FocusNode(); //adadded globally
  final FocusNode _passwordFocus = FocusNode(); //added globally
  final FocusNode _passwordVerifyFocus = FocusNode();

  @override
  void initState() {
    isPasswordVisible = false;
    isConfirmPasswordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Recuperar Clave'),
        backgroundColor: Colors.green,
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
        validator: _validateConfirmPassword,
        obscureText: !isConfirmPasswordVisible,
        decoration: InputDecoration(
            labelText: 'Nueva Clave',
            suffixIcon: IconButton(
              icon: Icon(isConfirmPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  isConfirmPasswordVisible = !isConfirmPasswordVisible;
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
                ), //text field: email
                Container(
                  child: TextFormField(
                    controller: _textEditFecha,
                    focusNode: _fechaFocus,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: _validatePassword,
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(_fechaFocus);
                    },
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                        labelText: 'Fecha Nacimiento',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.data_usage),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        icon: Icon(Icons.date_range)),
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
                      'Guardar',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    onPressed: () {
                      if (_keyValidationForm.currentState.validate()) {
                        _onTappedButtonRegister();
                        match_password(_textEditPassword.text,
                            _textEditPasswordVerify.text);
                      }
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
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Correo Incorrecto';
    } else {
      return null;
    }
  }

  String _validatePassword(String value) {
    return value.length < 5 ? 'Minimo 5 Caracteres' : null;
  }

  String _validateConfirmPassword(String value) {
    return value.length < 5 ? 'Minimo 5 Caracteres' : null;
  }

  void match_password(String pass, String passVerify) {
    if (pass == passVerify) {
      print('ok');
    } else {
      print('password invalid');
    }
  }

  String _validatePasswordVerify(String value, String temp) {
    return value.toString() == temp.toString() ? 'Claves Diferentes' : null;
  }

  void _onTappedButtonRegister() {}

  void _onTappedTextlogin() {}
}
