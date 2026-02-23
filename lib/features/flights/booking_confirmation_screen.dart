import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flightbuddy/core/models/entities.dart';

class BookingConfirmationScreen extends StatefulWidget {
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
  final String bookingId;
  final String? paymentMethod;
  final Map<String, String>? paymentDetails;

  const BookingConfirmationScreen({
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
    required this.bookingId,
    this.paymentMethod,
    this.paymentDetails,
  });

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  final Color primary = const Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Success Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Booking Confirmed!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Your flight has been successfully booked',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Booking ID Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: primary, width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Booking Reference',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.bookingId,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primary,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Save this reference for check-in',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Flight Details Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Flight Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('HH:mm').format(widget.flight.departureTime),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.flight.fromCity,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(Icons.flight, color: primary),
                                Text(
                                  widget.flight.duration,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  DateFormat('HH:mm').format(widget.flight.arrivalTime),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.flight.toCity,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        _buildDetailRow('Airline', widget.flight.airline),
                        _buildDetailRow('Aircraft', widget.flight.aircraftType),
                        _buildDetailRow('Flight Number', widget.flight.flightNumber),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Passenger Details Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Passenger Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow('Name', widget.userName),
                        _buildDetailRow('Email', widget.userEmail),
                        _buildDetailRow('Phone', widget.userPhone),
                        if (widget.passport != null && widget.passport!.isNotEmpty) ...[
                          const Divider(height: 16),
                          _buildDetailRow('Passport', widget.passport!),
                        ],
                        if (widget.dob != null && widget.dob!.isNotEmpty) ...[
                          const Divider(height: 16),
                          _buildDetailRow('DOB', widget.dob!),
                        ],
                        if (widget.nationality != null && widget.nationality!.isNotEmpty) ...[
                          const Divider(height: 16),
                          _buildDetailRow('Nationality', widget.nationality!),
                        ],
                        const Divider(height: 16),
                        _buildDetailRow('Seat(s)', widget.selectedSeats.join(', ')),
                        _buildDetailRow(
                          'Class',
                          widget.travelClass
                              .replaceFirst(widget.travelClass[0],
                                  widget.travelClass[0].toUpperCase())
                              .replaceAll('_', ' '),
                        ),
                        if (widget.paymentMethod != null) ...[
                          const Divider(height: 16),
                          _buildDetailRow('Paid via', widget.paymentMethod!),
                        ],
                        if (widget.paymentDetails != null && widget.paymentDetails!.isNotEmpty) ...[
                          const Divider(height: 16),
                          ...widget.paymentDetails!.entries.map((e) => _buildDetailRow(e.key, e.value)),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Price Breakdown
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Price Breakdown',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildPriceRow(
                          'Base Fare (${widget.selectedSeats.length} seat${widget.selectedSeats.length > 1 ? 's' : ''})',
                          widget.totalPrice * 0.8,
                        ),
                        _buildPriceRow('Taxes & Fees', widget.totalPrice * 0.15),
                        _buildPriceRow('Service Charge', widget.totalPrice * 0.05),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount Paid',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Rs. ${widget.totalPrice.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Important Notes
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.orange, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Important Notes',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Check-in opens 24 hours before departure\n'
                        '• Please arrive at the airport 2 hours before \n'
                        '• A confirmation email has been sent to ${widget.userEmail}\n'
                        '• Boarding pass will be available 24 hours before flight',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/dashboard',
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking details sent to your email'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: primary),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Download E-Ticket',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          Text(
            'Rs. ${amount.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
