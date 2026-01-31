import 'package:flutter/material.dart';

class SearchResultScreen extends StatelessWidget {
  const SearchResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flight Results")),
      body: ListView(
        children: const [
          ListTile(title: Text("IndiGo - ₹13,500")),
          ListTile(title: Text("Vistara - ₹15,000")),
        ],
      ),
    );
  }
}
