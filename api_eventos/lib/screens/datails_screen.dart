import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> event =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: Text(event['nameEs'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            event['images'].isNotEmpty
                ? Image.network(event['images'][0]['imageUrl'])
                : SizedBox(height: 200, child: Placeholder()),
            SizedBox(height: 16),
            Text('Lugar: ${event['establishmentEs']}', style: TextStyle(fontSize: 18)),
            Text('Fecha: ${event['startDate']}', style: TextStyle(fontSize: 18)),
            Text('Municipio: ${event['municipalityEs']}', style: TextStyle(fontSize: 18)),
            Text('Precio: ${event['priceEs']}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
