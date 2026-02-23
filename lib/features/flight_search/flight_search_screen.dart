import 'package:flutter/material.dart';

class FlightSearchScreen extends StatelessWidget {
  const FlightSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: const Text('Search Flights')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _inputField('From'),
            const SizedBox(height: 12),
            _inputField('To'),
            const SizedBox(height: 12),
            _inputField('Departure Date'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Search Flights'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}