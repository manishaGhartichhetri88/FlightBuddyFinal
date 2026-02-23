// Booking Details Screen - Clean Architecture with Riverpod
// Handles passenger details and booking confirmation

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flightbuddy/core/models/entities.dart';
import 'package:flightbuddy/core/providers/providers.dart';
import 'package:uuid/uuid.dart';

class BookingDetailsScreenClean extends ConsumerStatefulWidget {
  final Flight flight;
  final List<String> selectedSeats;
  final String travelClass;
  final int passengerCount;

  const BookingDetailsScreenClean({
    super.key,
    required this.flight,
    required this.selectedSeats,
    required this.travelClass,
    required this.passengerCount,
  });

  @override
  ConsumerState<BookingDetailsScreenClean> createState() =>
      _BookingDetailsScreenCleanState();
}

class _BookingDetailsScreenCleanState
    extends ConsumerState<BookingDetailsScreenClean> {
  late List<TextEditingController> firstNameControllers;
  late List<TextEditingController> lastNameControllers;
  late List<TextEditingController> emailControllers;
  late List<TextEditingController> phoneControllers;
  late List<TextEditingController> passportControllers;
  late List<TextEditingController> dobControllers;
  late List<TextEditingController> nationalityControllers;

  final Color primary = const Color(0xFF1565C0);
  int currentPassengerPage = 0;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    // ensure loading flag is cleared when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookingLoadingProvider.notifier).state = false;
      debugPrint('bookingLoading reset to false');
    });
  }

  void _initializeControllers() {
    firstNameControllers =
        List.generate(widget.passengerCount, (_) => TextEditingController());
    lastNameControllers =
        List.generate(widget.passengerCount, (_) => TextEditingController());
    emailControllers =
        List.generate(widget.passengerCount, (_) => TextEditingController());
    phoneControllers =
        List.generate(widget.passengerCount, (_) => TextEditingController());
    passportControllers =
        List.generate(widget.passengerCount, (_) => TextEditingController());
    dobControllers =
        List.generate(widget.passengerCount, (_) => TextEditingController());
    nationalityControllers =
        List.generate(widget.passengerCount, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controllers in [
      firstNameControllers,
      lastNameControllers,
      emailControllers,
      phoneControllers,
      passportControllers,
      dobControllers,
      nationalityControllers,
    ]) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  bool _validatePassengers() {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    // phone with optional leading + and 7–15 digits
    final phoneRegex = RegExp(r'^\+?\d{7,15}$');
    for (int i = 0; i < widget.passengerCount; i++) {
      final first = firstNameControllers[i].text.trim();
      final last = lastNameControllers[i].text.trim();
      final email = emailControllers[i].text.trim();
      final phone = phoneControllers[i].text.trim();
      final passport = passportControllers[i].text.trim();
      final dob = dobControllers[i].text.trim();
      final nationality = nationalityControllers[i].text.trim();
      debugPrint('validating passenger ${i+1}: first="$first" last="$last" email="$email" phone="$phone" passport="$passport" dob="$dob" nationality="$nationality"');
      if (first.isEmpty) {
        _showValidation('First name required for passenger ${i + 1}');
        return false;
      }
      if (last.isEmpty) {
        _showValidation('Last name required for passenger ${i + 1}');
        return false;
      }
      if (email.isEmpty) {
        _showValidation('Email required for passenger ${i + 1}');
        return false;
      }
      if (!emailRegex.hasMatch(email)) {
        _showValidation('Enter a valid email for passenger ${i + 1}');
        return false;
      }
      if (phone.isEmpty) {
        _showValidation('Phone number required for passenger ${i + 1}');
        return false;
      }
      if (!phoneRegex.hasMatch(phone)) {
        _showValidation('Enter a valid phone number (with country code) for passenger ${i + 1}');
        return false;
      }
      if (passport.isEmpty) {
        _showValidation('Passport number required for passenger ${i + 1}');
        return false;
      }
      if (dob.isEmpty) {
        _showValidation('Date of birth required for passenger ${i + 1}');
        return false;
      }
      if (nationality.isEmpty) {
        _showValidation('Nationality required for passenger ${i + 1}');
        return false;
      }
    }
    return true;
  }

  Future<void> _proceedToPayment() async {
    debugPrint('proceedToPayment called');
    if (!_validatePassengers()) {
      debugPrint('validation failed');
      return;
    }

    // Create passenger objects
    final passengers = <Passenger>[];
    for (int i = 0; i < widget.passengerCount; i++) {
      passengers.add(
        Passenger(
          id: const Uuid().v4(),
          firstName: firstNameControllers[i].text,
          lastName: lastNameControllers[i].text,
          email: emailControllers[i].text,
          phone: phoneControllers[i].text,
          passportNumber: passportControllers[i].text,
          dateOfBirth: DateTime.parse(dobControllers[i].text),
          nationality: nationalityControllers[i].text,
          isAdult: true,
        ),
      );
    }

    // Store passengers in provider
    ref.read(passengersProvider.notifier).state = passengers;

    // Calculate total price
    double pricePerSeat = widget.travelClass == 'Economy'
        ? widget.flight.priceEconomy
        : widget.flight.priceBusiness;
    double totalPrice = pricePerSeat * widget.selectedSeats.length;

    // update provider
    ref.read(totalPriceProvider.notifier).state = totalPrice;

    // Navigate to payment
    if (mounted) {
      debugPrint('validation succeeded, navigating...');
      ref.read(bookingLoadingProvider.notifier).state = true;
      try {
        final first = passengers.first;
        await Navigator.pushNamed(
          context,
          '/payment',
          arguments: {
            'flight': widget.flight,
            'selectedSeats': widget.selectedSeats,
            'travelClass': widget.travelClass,
            'totalPrice': totalPrice,
            'userName': '${first.firstName} ${first.lastName}',
            'userEmail': first.email,
            'userPhone': first.phone,
            'passport': first.passportNumber,
            'dob': first.dateOfBirth.toIso8601String().split('T').first,
            'nationality': first.nationality,
            'passengers': passengers,
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigated to payment screen')),
        );
      } catch (e, st) {
        debugPrint('navigation error: $e');
        debugPrint('$st');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigation failed: $e')),
        );
      } finally {
        ref.read(bookingLoadingProvider.notifier).state = false;
      }
    }
  }


  void _showValidation(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Simulated loading state
    final isLoading = ref.watch(bookingLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger Details'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.all(16),
            child: LinearProgressIndicator(
              value: (currentPassengerPage + 1) / widget.passengerCount,
              minHeight: 4,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(primary),
            ),
          ),

          // Passenger page indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Passenger ${currentPassengerPage + 1} of ${widget.passengerCount}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Form fields for current passenger
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildPassengerForm(currentPassengerPage),
            ),
          ),

          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                // Previous button
                if (currentPassengerPage > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => currentPassengerPage--);
                      },
                      child: const Text('Previous'),
                    ),
                  ),
                if (currentPassengerPage > 0) const SizedBox(width: 12),

                // Next or Confirm button
                Expanded(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _handleNextOrConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      disabledBackgroundColor: Colors.grey[400],
                    ),
                    child: Text(
                      currentPassengerPage < widget.passengerCount - 1
                          ? 'Next'
                          : 'Confirm & Pay',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading) ...[
            const SizedBox(height: 8),
            const Text('Processing...', style: TextStyle(color: Colors.grey)),
          ],
        ],
      ),
    );
  }

  void _handleNextOrConfirm() {
    final isLoading = ref.read(bookingLoadingProvider);
    debugPrint('button pressed, current page: $currentPassengerPage, isLoading=$isLoading');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('action clicked, page ${currentPassengerPage+1}, loading=$isLoading')),
    );
    if (currentPassengerPage < widget.passengerCount - 1) {
      setState(() => currentPassengerPage++);
    } else {
      _proceedToPayment();
    }
  }

  Widget _buildPassengerForm(int passengerIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First Name
        _buildTextField(
          label: 'First Name',
          controller: firstNameControllers[passengerIndex],
          icon: Icons.person,
        ),
        const SizedBox(height: 16),

        // Last Name
        _buildTextField(
          label: 'Last Name',
          controller: lastNameControllers[passengerIndex],
          icon: Icons.person,
        ),
        const SizedBox(height: 16),

        // Email
        _buildTextField(
          label: 'Email',
          controller: emailControllers[passengerIndex],
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),

        // Phone
        _buildTextField(
          label: 'Phone Number',
          controller: phoneControllers[passengerIndex],
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),

        // Passport Number
        _buildTextField(
          label: 'Passport Number',
          controller: passportControllers[passengerIndex],
          icon: Icons.credit_card,
        ),
        const SizedBox(height: 16),

        // Date of Birth
        _buildDateField(
          label: 'Date of Birth',
          controller: dobControllers[passengerIndex],
          icon: Icons.calendar_today,
          passengerIndex: passengerIndex,
        ),
        const SizedBox(height: 16),

        // Nationality
        _buildTextField(
          label: 'Nationality',
          controller: nationalityControllers[passengerIndex],
          icon: Icons.public,
        ),

        // Summary card
        const SizedBox(height: 24),
        _buildSummaryCard(passengerIndex),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(icon),
            hintText: 'Enter $label',
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required int passengerIndex,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime(2000),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              controller.text = picked.toString().split(' ')[0];
            }
          },
          child: TextField(
            controller: controller,
            enabled: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(icon),
              hintText: 'Select $label',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(int passengerIndex) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seat: ${widget.selectedSeats[passengerIndex]}',
              style: TextStyle(fontWeight: FontWeight.bold, color: primary),
            ),
            const SizedBox(height: 4),
            Text(
              'Class: ${widget.travelClass}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              'Flight: ${widget.flight.airline} ${widget.flight.flightNumber}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
