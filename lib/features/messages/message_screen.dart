import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      {
        'icon': Icons.flight_takeoff,
        'title': 'Flight Booking Confirmation',
        'subtitle': 'Your booking for NEP→BLR on Feb 25 is confirmed',
        'time': '2 hours ago'
      },
      {
        'icon': Icons.info,
        'title': 'Special Offer',
        'subtitle': 'Get 25% off on your next flight booking!',
        'time': '5 hours ago'
      },
      {
        'icon': Icons.check_circle,
        'title': 'Payment Successful',
        'subtitle': 'Payment of ₹13,500 received for booking #FB12345',
        'time': 'Yesterday'
      },
      {
        'icon': Icons.notifications_active,
        'title': 'Seat Selection',
        'subtitle': 'Select your preferred seats for flight FD-405',
        'time': 'Yesterday'
      },
      {
        'icon': Icons.luggage,
        'title': 'Baggage Info',
        'subtitle': 'You have included 1 checked baggage (20kg)',
        'time': '2 days ago'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          return Column(
            children: [
              ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    msg['icon'] as IconData,
                    color: const Color(0xFF1565C0),
                  ),
                ),
                title: Text(
                  msg['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(msg['subtitle'] as String),
                trailing: Text(
                  msg['time'] as String,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${msg['title']} - Full details would open here')),
                  );
                },
              ),
              if (index < messages.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(color: Colors.grey.shade200),
                ),
            ],
          );
        },
      ),
    );
  }
}
