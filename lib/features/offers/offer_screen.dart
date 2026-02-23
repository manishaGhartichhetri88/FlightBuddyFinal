import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OfferScreen extends ConsumerWidget {
  const OfferScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = const Color(0xFF1565C0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Special Offers'),
        elevation: 0,
        backgroundColor: primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Offers
            _buildOfferCard(
              title: 'Summer Sale',
              description: 'Get up to 30% off on flights',
              discount: '30%',
              icon: Icons.local_offer,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            _buildOfferCard(
              title: 'Early Bird Special',
              description: 'Book 30 days in advance and save',
              discount: '25%',
              icon: Icons.schedule,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildOfferCard(
              title: 'Weekend Getaway',
              description: 'Special rates for weekend trips',
              discount: '20%',
              icon: Icons.weekend,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            _buildOfferCard(
              title: 'Group Travel',
              description: 'Book for 5+ passengers and get discounts',
              discount: '15%',
              icon: Icons.people,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferCard({
    required String title,
    required String description,
    required String discount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              discount,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
