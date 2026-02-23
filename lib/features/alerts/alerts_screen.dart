import 'package:flutter/material.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  @override
  Widget build(BuildContext context) {
    final alerts = [
      {
        'type': 'Price Drop',
        'title': '24% Price Drop Detected!',
        'subtitle': 'NEP→BLR flights dropped from ₹15,000 to ₹11,400',
        'color': Colors.green,
        'icon': Icons.trending_down,
      },
      {
        'type': 'Booking Reminder',
        'title': 'Your Flight is Tomorrow',
        'subtitle': 'Flight FD-405 departing at 06:30 AM from Kathmandu',
        'color': Colors.orange,
        'icon': Icons.alarm,
      },
      {
        'type': 'Check-in Available',
        'title': 'Online Check-in Open',
        'subtitle': 'Check-in for flight FD-405 is now available',
        'color': Colors.blue,
        'icon': Icons.done_all,
      },
      {
        'type': 'Last Minute Deal',
        'title': 'Limited Time Offer - 40% OFF',
        'subtitle': 'Flights from DEL to BOM only ₹4,200. Book now!',
        'color': Colors.red,
        'icon': Icons.local_offer,
      },
      {
        'type': 'Special Offer',
        'title': 'Referral Bonus Available',
        'subtitle': 'Earn ₹500 for each friend who books through your link',
        'color': Colors.purple,
        'icon': Icons.card_giftcard,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts & Deals'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                '${alerts.length} alerts',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          final alert = alerts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  color: (alert['color'] as Color).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(
                  alert['icon'] as IconData,
                  color: alert['color'] as Color,
                ),
              ),
              title: Text(
                alert['title'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    alert['subtitle'] as String,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: (alert['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          alert['type'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: alert['color'] as Color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Action for ${alert['title']}'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Text('View'),
                      ),
                    ],
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
