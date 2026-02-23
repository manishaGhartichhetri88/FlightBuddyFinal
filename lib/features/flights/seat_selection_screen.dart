import 'package:flutter/material.dart';
import 'package:flightbuddy/core/models/flight_model.dart';
import 'package:flightbuddy/core/models/seat_model.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Flight flight;
  final String travelClass;
  final int passengers;

  const SeatSelectionScreen({
    super.key,
    required this.flight,
    required this.travelClass,
    required this.passengers,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final Color primary = const Color(0xFF1565C0);
  late List<Seat> seats;
  List<String> selectedSeats = [];

  @override
  void initState() {
    super.initState();
    seats = generateSeatMap(widget.travelClass.toLowerCase());
  }

  void _onSeatTapped(Seat seat) {
    if (seat.isBooked) return;

    setState(() {
      if (seat.isSelected) {
        selectedSeats.remove(seat.seatNumber);
        seat.isSelected = false;
      } else {
        if (selectedSeats.length < widget.passengers) {
          seat.isSelected = true;
          selectedSeats.add(seat.seatNumber);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You can only select seats for selected passengers')),
          );
        }
      }
    });
  }

  double get totalPrice {
    final pricePerSeat = widget.travelClass == 'Business'
        ? widget.flight.priceBusiness
        : widget.flight.priceEconomy;
    return selectedSeats.length * pricePerSeat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Seats'),
        backgroundColor: primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Flight Info Header
          Container(
            padding: const EdgeInsets.all(16),
            color: primary.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.flight.airlineCode,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primary,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${widget.flight.departureTime} - ${widget.flight.arrivalTime}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Text(
                  '${widget.passengers} passenger(s) - ${widget.travelClass}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          // Seat Legend
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(Colors.green, 'Available'),
                _buildLegendItem(Colors.blue, 'Selected'),
                _buildLegendItem(Colors.grey, 'Booked'),
              ],
            ),
          ),

          // Class Legend (Economy vs Business)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildClassLegend('Economy', Colors.green, false),
                _buildClassLegend('Business', Colors.amber.shade700, true),
              ],
            ),
          ),

          // Seat Map
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Screen
                  Container(
                    width: double.infinity,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'SCREEN',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Seats Grid
                  _buildSeatGrid(),
                ],
              ),
            ),
          ),

          // Bottom Price Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selected: ${selectedSeats.isEmpty ? 'None' : selectedSeats.join(', ')}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Rs. ${totalPrice.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedSeats.length == widget.passengers
                        ? () {
                            Navigator.pushNamed(
                              context,
                              '/passenger_details',
                              arguments: {
                                'flight': widget.flight,
                                'selectedSeats': selectedSeats,
                                'travelClass': widget.travelClass,
                                'totalPrice': totalPrice,
                              },
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      disabledBackgroundColor: Colors.grey,
                    ),
                    child: Text(
                      selectedSeats.length == widget.passengers
                          ? 'Continue to Payment'
                          : 'Select ${widget.passengers - selectedSeats.length} more seat(s)',
                      style: const TextStyle(
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
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildSeatGrid() {
    final numRows = widget.travelClass == 'Business' ? 15 : 30;
    final numCols = widget.travelClass == 'Business' ? 4 : 6;

    return Column(
      children: List.generate(numRows, (row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Row number
              SizedBox(
                width: 30,
                child: Text(
                  (row + 1).toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 8),

              // Seats
              ...List.generate(numCols, (col) {
                final seatIndex = row * numCols + col;
                if (seatIndex >= seats.length) return const SizedBox.shrink();

                final seat = seats[seatIndex];
                final isBusiness = seat.seatClass == 'business';
                final seatSize = isBusiness ? 44.0 : 36.0;
                final availableColor = isBusiness ? Colors.amber.shade700 : Colors.green;
                final selectedColor = isBusiness ? Colors.orangeAccent : Colors.blue;
                final bookedColor = Colors.grey;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () => _onSeatTapped(seat),
                    child: Container(
                      width: seatSize,
                      height: seatSize,
                      decoration: BoxDecoration(
                        color: seat.isBooked
                            ? bookedColor
                            : seat.isSelected
                                ? selectedColor
                                : availableColor,
                        borderRadius: BorderRadius.circular(isBusiness ? 8 : 6),
                        border: isBusiness
                            ? Border.all(color: Colors.amber.shade900, width: seat.isSelected ? 2 : 1)
                            : null,
                        boxShadow: isBusiness && !seat.isBooked
                            ? [BoxShadow(color: Colors.amber.withOpacity(0.15), blurRadius: 4, offset: const Offset(0, 2))]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          seat.seatNumber,
                          style: TextStyle(
                            fontSize: isBusiness ? 12 : 10,
                            fontWeight: FontWeight.bold,
                            color: seat.isBooked ? Colors.white : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildClassLegend(String label, Color color, bool isBusiness) {
    return Row(
      children: [
        Container(
          width: isBusiness ? 28 : 20,
          height: isBusiness ? 28 : 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(isBusiness ? 8 : 4),
            border: isBusiness ? Border.all(color: Colors.amber.shade900) : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
