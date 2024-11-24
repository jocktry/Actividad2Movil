import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadEventsFromSharedPreferences(); // Cargar eventos desde SharedPreferences
    fetchEvents();
  }

  Future<void> loadEventsFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final String? eventName = prefs.getString('eventName');
    final String? eventDate = prefs.getString('eventDate');
    final String? eventLocation = prefs.getString('eventLocation');

    if (eventName != null && eventDate != null && eventLocation != null) {
      setState(() {
        // Agregar el evento almacenado en SharedPreferences a la lista
        events.add({
          'nameEs': eventName,
          'date': eventDate,
          'municipalityEs': eventLocation,
          'images': [], // Sin imagen en este caso
        });
      });
    }
  }

  Future<void> fetchEvents() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.euskadi.eus/culture/events/v1.0/events'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          events.addAll(data['items']);
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar los eventos');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Eventos de Euskadi')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                
                return ListTile(
                  leading: event['images'].isNotEmpty
                      ? Image(
                          image: NetworkImage(
                            event['images'][0]['imageUrl'],
                          ),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ?? 1)
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error, size: 50);
                          },
                        )
                      : Icon(Icons.event),
                  title: Text(event['nameEs']),
                  subtitle: Text(event['municipalityEs']),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/details',
                      arguments: event,
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/form'),
      ),
    );
  }
}
