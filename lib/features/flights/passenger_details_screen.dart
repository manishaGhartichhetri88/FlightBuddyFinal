import 'package:flutter/material.dart';
import 'package:flightbuddy/core/models/flight_model.dart';

class PassengerDetailsScreen extends StatefulWidget {
  final Flight flight;
  final List<String> selectedSeats;
  final String travelClass;
  final double totalPrice;

  const PassengerDetailsScreen({
    super.key,
    required this.flight,
    required this.selectedSeats,
    required this.travelClass,
    required this.totalPrice,
  });

  @override
  State<PassengerDetailsScreen> createState() => _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState extends State<PassengerDetailsScreen> {
  final Color primary = const Color(0xFF1565C0);
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passportController;
  late TextEditingController _dobController;
  late TextEditingController _nationalityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passportController = TextEditingController();
    _dobController = TextEditingController();
    _nationalityController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passportController.dispose();
    _dobController.dispose();
    _nationalityController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    // allow optional leading + and digits between 7 and 15
    return RegExp(r'^\+?\d{7,15}\$').hasMatch(phone);
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      _dobController.text = picked.toIso8601String().split('T').first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger Details'),
        backgroundColor: primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.flight.airlineName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.flight.departureTime} - ${widget.flight.arrivalTime}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Seats: ${widget.selectedSeats.join(', ')}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Price:'),
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
            const SizedBox(height: 24),

            // Form Title
            const Text(
              'Enter Your Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Please enter your name'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!_isValidEmail(v.trim())) {
                        return 'Enter a valid email (eg. you@gmail.com)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Phone Field
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: '+977xxxxxxxxx',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Please enter phone number';
                      }
                      if (!_isValidPhone(v.trim())) {
                        return 'Enter valid phone with country code';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Passport Field
                  TextFormField(
                    controller: _passportController,
                    decoration: InputDecoration(
                      labelText: 'Passport Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.card_membership),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Passport number required'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Date of Birth
                  TextFormField(
                    controller: _dobController,
                    readOnly: true,
                    onTap: _selectDate,
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.calendar_today),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Please select date of birth'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Nationality
                  TextFormField(
                    controller: _nationalityController,
                    decoration: InputDecoration(
                      labelText: 'Nationality',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.flag),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Nationality required'
                        : null,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please correct the errors above')),
                    );
                    return;
                  }
                  Navigator.pushNamed(
                    context,
                    '/payment',
                    arguments: {
                      'flight': widget.flight,
                      'selectedSeats': widget.selectedSeats,
                      'travelClass': widget.travelClass,
                      'totalPrice': widget.totalPrice,
                      'userName': _nameController.text,
                      'userEmail': _emailController.text,
                      'userPhone': _phoneController.text,
                      'passport': _passportController.text,
                      'dob': _dobController.text,
                      'nationality': _nationalityController.text,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Continue to Payment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
