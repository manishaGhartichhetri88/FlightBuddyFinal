// Flight Selection Screen - Clean Architecture with Riverpod

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flightbuddy/core/models/entities.dart';
import 'package:flightbuddy/core/providers/providers.dart';

class FlightSelectionScreenClean extends ConsumerWidget {
  final String fromCity;
  final String toCity;
  final DateTime departureDate;
  final DateTime? returnDate;
  final int passengers;

  const FlightSelectionScreenClean({
    super.key,
    required this.fromCity,
    required this.toCity,
    required this.departureDate,
    this.returnDate,
    required this.passengers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // Build search parameters
    final searchParams = {
      'fromCity': fromCity,
      'toCity': toCity,
      'departureDate': departureDate,
      'returnDate': returnDate,
      'passengers': passengers,
    };

    // Get flights async
    final flightsAsync = ref.watch(searchFlightsProvider(searchParams));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Flight'),
        elevation: 0,
      ),
      body: flightsAsync.when(
        data: (flights) {
          if (flights.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.flight_takeoff,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No flights found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: flights.length,
            itemBuilder: (context, index) {
              final flight = flights[index];
              return FlightCard(
                flight: flight,
                passengers: passengers,
                onSelect: () {
                  // Update selected flight
                  ref.read(selectedFlightProvider.notifier).state = flight;
                  // Navigate to seat selection or booking details
                  Navigator.pushNamed(
                    context,
                    '/seat-selection',
                    arguments: {'flight': flight, 'passengers': passengers},
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading flights\n${error.toString()}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FlightCard extends StatelessWidget {
  final Flight flight;
  final int passengers;
  final VoidCallback onSelect;
  final Color primary = const Color(0xFF1565C0);

  const FlightCard({
    super.key,
    required this.flight,
    required this.passengers,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final departureTime = DateFormat('HH:mm').format(flight.departureTime);
    final arrivalTime = DateFormat('HH:mm').format(flight.arrivalTime);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Airline and flight number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flight.airline,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Flight ${flight.flightNumber}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Text(
                  flight.aircraftType,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Flight route and time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      departureTime,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      flight.fromCity,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        flight.duration,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey[300],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.flight,
                              size: 16,
                              color: primary,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        flight.stops,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      arrivalTime,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      flight.toCity,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Divider
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 12),

            // Pricing and seats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '₹${(flight.priceEconomy * passengers).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF27AE60),
                      ),
                    ),
                    Text(
                      'per person: ₹${flight.priceEconomy.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Available Seats',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      flight.availableSeatsEconomy.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Select Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSelect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Select Flight',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
