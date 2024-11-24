import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  String eventName = '';
  String eventDate = '';
  String eventLocation = '';

  Future<void> saveEvent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('eventName', eventName);
      await prefs.setString('eventDate', eventDate);
      await prefs.setString('eventLocation', eventLocation);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Evento guardado con éxito')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Evento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre del Evento'),
                onSaved: (value) => eventName = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
                onSaved: (value) => eventDate = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Lugar'),
                onSaved: (value) => eventLocation = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveEvent,
                child: Text('Guardar Evento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
