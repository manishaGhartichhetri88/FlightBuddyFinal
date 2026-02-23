import 'package:flutter/material.dart';

class SearchResultScreen extends StatelessWidget {
  const SearchResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flight Results")),
      body: ListView(
        children: const [
          ListTile(title: Text("IndiGo - rs13,500")),
          ListTile(title: Text("Vistara - rs15,000")),
        ],
      ),
    );
  }
}
