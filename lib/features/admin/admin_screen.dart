import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.flight),
            title: Text("Manage Flights"),
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text("Manage Users"),
          ),
          ListTile(
            leading: Icon(Icons.analytics),
            title: Text("View Reports"),
          ),
        ],
      ),
    );
  }
}