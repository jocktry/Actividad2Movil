import 'package:flutter/material.dart';
import './screens/home_screen.dart';
import './screens/form_screen.dart';
import './screens/datails_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventos de Euskadi',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/details': (context) => DetailsScreen(),
        '/form': (context) => FormScreen(),
      },
    );
  }
}
