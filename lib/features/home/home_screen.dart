import 'package:flutter/material.dart';
import '../flight_search/flight_search_screen.dart';
import '../offers/offers_screen.dart';
import '../alerts/alerts_screen.dart';
import '../messages/message_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Buddy'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _navCard(
              context,
              title: 'Search Flights',
              icon: Icons.flight_takeoff,
              page: const FlightSearchScreen(),
            ),
            _navCard(
              context,
              title: 'Offers',
              icon: Icons.local_offer,
              page: const OffersScreen(),
            ),
            _navCard(
              context,
              title: 'Alerts',
              icon: Icons.notifications,
              page: const AlertsScreen(),
            ),
            _navCard(
              context,
              title: 'Messages',
              icon: Icons.message,
              page: const MessagesScreen(),
            ),
            _navCard(
              context,
              title: 'Profile',
              icon: Icons.person,
              page: const ProfileScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget page,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
      ),
    );
  }
}
