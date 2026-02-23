// Clean Architecture Flight Search Screen with Riverpod

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flightbuddy/core/providers/providers.dart';

class FlightSearchScreenClean extends ConsumerStatefulWidget {
  const FlightSearchScreenClean({super.key});

  @override
  ConsumerState<FlightSearchScreenClean> createState() =>
      _FlightSearchScreenCleanState();
}

class _FlightSearchScreenCleanState
    extends ConsumerState<FlightSearchScreenClean> {
  late TextEditingController fromController;
  late TextEditingController toController;
  late TextEditingController departureDateController;
  late TextEditingController returnDateController;
  late TextEditingController passengersController;

  DateTime selectedDepartureDate = DateTime.now();
  DateTime? selectedReturnDate;
  bool isRoundTrip = false;
  int passengerCount = 1;
  final Color primary = const Color(0xFF1565C0);

  @override
  void initState() {
    super.initState();
    fromController = TextEditingController();
    toController = TextEditingController();
    departureDateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(selectedDepartureDate),
    );
    returnDateController = TextEditingController();
    passengersController = TextEditingController(text: '1');
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    departureDateController.dispose();
    returnDateController.dispose();
    passengersController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(bool isReturnDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isReturnDate ? selectedReturnDate ?? DateTime.now() : selectedDepartureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        if (isReturnDate) {
          selectedReturnDate = pickedDate;
          returnDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        } else {
          selectedDepartureDate = pickedDate;
          departureDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
          // Reset return date if it's before departure date
          if (selectedReturnDate != null && selectedReturnDate!.isBefore(pickedDate)) {
            selectedReturnDate = null;
            returnDateController.clear();
          }
        }
      });
    }
  }

  Future<void> _searchFlights() async {
    if (fromController.text.isEmpty || toController.text.isEmpty) {
      _showErrorDialog('Please select departure and destination cities');
      return;
    }

    ref.read(searchLoadingProvider.notifier).state = true;

    try {
      final searchParams = {
        'fromCity': fromController.text,
        'toCity': toController.text,
        'departureDate': selectedDepartureDate,
        'returnDate': isRoundTrip ? selectedReturnDate : null,
        'passengers': passengerCount,
      };

      // This will trigger the search
      // ignore: unused_result
      ref.refresh(searchFlightsProvider(searchParams));

      // Save to search history (TODO): repository call omitted for now
      // Assuming current user ID is available
      // await searchRepo.saveSearchHistory(...);

    } catch (e) {
      _showErrorDialog('Error searching flights: ${e.toString()}');
    } finally {
      ref.read(searchLoadingProvider.notifier).state = false;
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(searchLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Flights'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Trip Type Toggle
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isRoundTrip = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: !isRoundTrip ? primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'One Way',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: !isRoundTrip ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isRoundTrip = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isRoundTrip ? primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Round Trip',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isRoundTrip ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // From City
            TextField(
              controller: fromController,
              decoration: InputDecoration(
                hintText: 'From',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.flight_takeoff),
                suffixIcon: fromController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          fromController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 12),

            // To City
            TextField(
              controller: toController,
              decoration: InputDecoration(
                hintText: 'To',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.flight_land),
                suffixIcon: toController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          toController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 12),

            // Departure Date
            GestureDetector(
              onTap: () => _selectDate(false),
              child: TextField(
                controller: departureDateController,
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Departure Date',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Return Date (Only if Round Trip)
            if (isRoundTrip)
              Column(
                children: [
                  GestureDetector(
                    onTap: () => _selectDate(true),
                    child: TextField(
                      controller: returnDateController,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Return Date',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),

            // Passengers
            TextField(
              controller: passengersController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  passengerCount = int.tryParse(value) ?? 1;
                  if (passengerCount < 1) passengerCount = 1;
                  if (passengerCount > 9) passengerCount = 9;
                  passengersController.text = passengerCount.toString();
                });
              },
              decoration: InputDecoration(
                hintText: 'Number of Passengers',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),

            // Search Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _searchFlights,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  disabledBackgroundColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Search Flights',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Recently Searched (Placeholder)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.history, color: primary),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Pro tip: Use search history to quickly find your favorite routes',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
