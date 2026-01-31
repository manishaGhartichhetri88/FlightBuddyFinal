import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.support_agent),
            title: Text('Flight Support'),
            subtitle: Text('Your booking is confirmed'),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('System'),
            subtitle: Text('New features coming soon'),
          ),
        ],
      ),
    );
  }
}
