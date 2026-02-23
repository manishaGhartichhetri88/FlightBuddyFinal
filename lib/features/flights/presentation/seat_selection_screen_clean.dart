// Seat Selection Screen - Clean Architecture with Riverpod

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flightbuddy/core/models/entities.dart';
import 'package:flightbuddy/core/providers/providers.dart';

class SeatSelectionScreenClean extends ConsumerStatefulWidget {
  final Flight flight;
  final int passengers;

  const SeatSelectionScreenClean({
    super.key,
    required this.flight,
    required this.passengers,
  });

  @override
  ConsumerState<SeatSelectionScreenClean> createState() =>
      _SeatSelectionScreenCleanState();
}

class _SeatSelectionScreenCleanState
    extends ConsumerState<SeatSelectionScreenClean> {
  final Color primary = const Color(0xFF1565C0);
  late String selectedClass;

  @override
  void initState() {
    super.initState();
    selectedClass = 'Economy';
  }

  @override
  Widget build(BuildContext context) {
    final selectedSeats = ref.watch(selectedSeatsProvider);
    final selectedClassState = ref.watch(selectedClassProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Seats'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Class Selection
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildClassButton(
                    'Economy',
                    selectedClassState == 'Economy',
                    () {
                      ref.read(selectedClassProvider.notifier).state =
                          'Economy';
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildClassButton(
                    'Business',
                    selectedClassState == 'Business',
                    () {
                      ref.read(selectedClassProvider.notifier).state =
                          'Business';
                    },
                  ),
                ),
              ],
            ),
          ),

          // Seat Information
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSeatLegend('Available', Colors.grey[300]!),
                _buildSeatLegend('Selected', Colors.green),
                _buildSeatLegend('Booked', Colors.red),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Seats Grid
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Generate mock seat layout
                  _buildSeatsGrid(selectedSeats),
                ],
              ),
            ),
          ),

          // Summary and Continue Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Seats: ${selectedSeats.isEmpty ? 'None' : selectedSeats.join(', ')}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total Price: ₹${_calculatePrice(selectedSeats, selectedClassState).toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF27AE60),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedSeats.length == widget.passengers
                        ? () {
                            ref
                                .read(selectedClassProvider.notifier)
                                .state = selectedClassState;
                            Navigator.pushNamed(
                              context,
                              '/booking-details',
                              arguments: {
                                'flight': widget.flight,
                                'selectedSeats': selectedSeats,
                                'travelClass': selectedClassState,
                              },
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      disabledBackgroundColor: Colors.grey[400],
                    ),
                    child: Text(
                      'Continue (${selectedSeats.length}/${widget.passengers})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primary : Colors.transparent,
          border: Border.all(
            color: isSelected ? primary : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSeatLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: Colors.grey[400]!),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSeatsGrid(List<String> selectedSeats) {
    const rows = ['A', 'B', 'C', 'D', 'E', 'F'];
    const columns = 6;

    return Column(
      children: List.generate(rows.length, (rowIndex) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(columns, (colIndex) {
              final seatNumber = '${rows[rowIndex]}${colIndex + 1}';
              final isSelected = selectedSeats.contains(seatNumber);
              final isBooked = rowIndex < 2 && colIndex < 3; // Mock booked seats

              return GestureDetector(
                onTap: !isBooked && selectedSeats.length < widget.passengers
                    ? () {
                        ref
                            .read(selectedSeatsProvider.notifier)
                            .state = isSelected
                            ? selectedSeats
                                .where((s) => s != seatNumber)
                                .toList()
                            : [...selectedSeats, seatNumber];
                      }
                    : null,
                child: Container(
                  width: 38,
                  height: 38,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isBooked
                        ? Colors.red
                        : isSelected
                            ? Colors.green
                            : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.grey[400]!,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      seatNumber,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: (isBooked || isSelected)
                            ? Colors.white
                            : Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  double _calculatePrice(List<String> seats, String seatClass) {
    double pricePerSeat = seatClass == 'Economy'
        ? widget.flight.priceEconomy
        : widget.flight.priceBusiness;
    return pricePerSeat * seats.length;
  }
}
