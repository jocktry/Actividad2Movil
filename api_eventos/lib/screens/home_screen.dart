import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.euskadi.eus/culture/events/v1.0/events'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          events = data['items'];
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
                      ? Image.network(
                          event['images'][0]['imageUrl'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
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
