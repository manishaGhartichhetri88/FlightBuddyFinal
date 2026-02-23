import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = const Color(0xFF1565C0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        elevation: 0,
        backgroundColor: primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unread Messages Section
            Text(
              'Messages',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Sample Messages
            _buildMessageTile(
              title: 'Booking Confirmation',
              message: 'Your flight booking FLT001 has been confirmed',
              time: '2 hours ago',
              isRead: false,
              icon: Icons.flight_takeoff,
              color: primary,
            ),
            const SizedBox(height: 8),
            _buildMessageTile(
              title: 'Payment Received',
              message: 'Payment of Rs 1,700 has been received successfully',
              time: '1 day ago',
              isRead: false,
              icon: Icons.check_circle,
              color: Colors.green,
            ),
            const SizedBox(height: 8),
            _buildMessageTile(
              title: 'Flight Reminder',
              message: 'Your flight departs tomorrow at 08:30 AM',
              time: '3 days ago',
              isRead: true,
              icon: Icons.notifications,
              color: Colors.orange,
            ),
            const SizedBox(height: 8),
            _buildMessageTile(
              title: 'Special Offer',
              message: 'Get 20% off on your next booking',
              time: '1 week ago',
              isRead: true,
              icon: Icons.local_offer,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTile({
    required String title,
    required String message,
    required String time,
    required bool isRead,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isRead ? Colors.grey.shade300 : Colors.blue.shade200,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    if (!isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
