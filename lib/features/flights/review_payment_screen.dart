import 'package:flutter/material.dart';
import 'package:flightbuddy/core/models/flight_model.dart';

class ReviewPaymentScreen extends StatelessWidget {
  final Flight flight;
  final List<String> selectedSeats;
  final String travelClass;
  final double totalPrice;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String? passport;
  final String? dob;
  final String? nationality;
  final String paymentMethod;
  final Map<String, String>? paymentDetails;

  const ReviewPaymentScreen({
    super.key,
    required this.flight,
    required this.selectedSeats,
    required this.travelClass,
    required this.totalPrice,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    this.passport,
    this.dob,
    this.nationality,
    required this.paymentMethod,
    this.paymentDetails,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFF1565C0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review & Confirm'),
        backgroundColor: primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please review your booking before proceeding',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            _detailCard('Flight', '${flight.airlineName} (${flight.airlineCode})'),
            _detailCard('Route', '${flight.departureCity} → ${flight.arrivalCity}'),
            _detailCard('Departure', flight.departureTime),
            _detailCard('Seats', selectedSeats.join(', ')),
            _detailCard('Class', travelClass),
            _detailCard('Total', 'Rs. ${totalPrice.toStringAsFixed(0)}'),
            _detailCard('Passenger', userName),
            _detailCard('Email', userEmail),
            _detailCard('Phone', userPhone),
            if (passport != null && passport!.isNotEmpty) _detailCard('Passport', passport!),
            if (dob != null && dob!.isNotEmpty) _detailCard('DOB', dob!),
            if (nationality != null && nationality!.isNotEmpty) _detailCard('Nationality', nationality!),
            _detailCard('Payment via', paymentMethod),
            if (paymentDetails != null && paymentDetails!.isNotEmpty)
              ...paymentDetails!.entries.map((e) => _detailCard(e.key, e.value)),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/booking_confirmation',
                    arguments: {
                      'flight': flight,
                      'selectedSeats': selectedSeats,
                      'travelClass': travelClass,
                      'totalPrice': totalPrice,
                      'userName': userName,
                      'userEmail': userEmail,
                      'userPhone': userPhone,
                      'bookingId': 'FB\$${DateTime.now().millisecondsSinceEpoch}',
                      'paymentMethod': paymentMethod,
                      'paymentDetails': paymentDetails,
                    },
                  );
                },

                child: const Text(
                  'Confirm Payment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _detailCard(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
