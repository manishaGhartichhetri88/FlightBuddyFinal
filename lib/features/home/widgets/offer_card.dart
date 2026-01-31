import 'package:flutter/material.dart';

class OfferCard extends StatelessWidget {
  final String title;

  const OfferCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(title),
      ),
    );
  }
}
