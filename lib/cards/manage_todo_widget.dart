import 'package:cempro_gps/cards/usuario_class.dart';
import 'package:flutter/material.dart';

import 'api_service.dart';


class ManageTodoWidget extends StatefulWidget {
  final Usuario todo; // a new or existing todo
  final Function saveChanges; // Function passed by the parent widget to save changes

  const ManageTodoWidget({Key key, this.todo, this.saveChanges})
      : super(key: key);

  @override
  _ManageTodoWidgetState createState() => _ManageTodoWidgetState();
}

class _ManageTodoWidgetState extends State<ManageTodoWidget> {
  ApiService _apiService;
  Future<List<String>> _statuses;

// Define the form key that preserve the state of the form
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _statuses = _apiService.getStatuses();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextFormField(
                initialValue: widget.todo.name,
                onSaved: (value) {
                  widget.todo.name = value; // on saved we persist the form state
                },
              ),
              TextFormField(
                initialValue: widget.todo.email,
                onSaved: (value) {
                  widget.todo.email = value; // on saved we persist the form state
                },
              ),


              FlatButton(
                child: Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  _form.currentState.save(); // we call the save method in order to invoke the onsaved method on form fields
                  this.widget.saveChanges(widget.todo); // call the save changes method that was passed by the parent widget
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}