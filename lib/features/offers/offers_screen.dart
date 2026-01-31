import 'package:flutter/material.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offers')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _OfferTile('25% OFF with Mastercard'),
          _OfferTile('33% OFF with Visa'),
          _OfferTile('Festival Special Discounts'),
        ],
      ),
    );
  }
}

class _OfferTile extends StatelessWidget {
  final String text;
  const _OfferTile(this.text);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.discount, color: Colors.green),
        title: Text(text),
      ),
    );
  }
}
