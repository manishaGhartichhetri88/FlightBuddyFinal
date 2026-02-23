import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flightbuddy/core/models/flight_model.dart';

class FlightSearchResultsScreen extends StatefulWidget {
  final String from;
  final String to;
  final DateTime departureDate;
  final int passengers;
  final String travelClass;

  const FlightSearchResultsScreen({
    super.key,
    required this.from,
    required this.to,
    required this.departureDate,
    required this.passengers,
    required this.travelClass,
  });

  @override
  State<FlightSearchResultsScreen> createState() =>
      _FlightSearchResultsScreenState();
}

class _FlightSearchResultsScreenState extends State<FlightSearchResultsScreen> {
  final Color primary = const Color(0xFF1565C0);
  late List<Flight> filteredFlights;
  String _sortBy = 'price'; // price, duration, departure

  @override
  void initState() {
    super.initState();
    _filterFlights();
  }

  void _filterFlights() {
    filteredFlights = mockFlights
        .where((flight) =>
            flight.departureCode == widget.from.split('(')[1].replaceAll(')', '') &&
            flight.arrivalCode == widget.to.split('(')[1].replaceAll(')', ''))
        .toList();

    _sortFlights();
  }

  void _sortFlights() {
    switch (_sortBy) {
      case 'price':
        filteredFlights.sort((a, b) => a.priceEconomy.compareTo(b.priceEconomy));
        break;
      case 'duration':
        filteredFlights.sort((a, b) => a.durationMinutes.compareTo(b.durationMinutes));
        break;
      case 'departure':
        filteredFlights.sort((a, b) => a.departureTime.compareTo(b.departureTime));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Flight'),
        elevation: 0,
        backgroundColor: primary,
      ),
      body: Column(
        children: [
          // Search Summary
          Container(
            padding: const EdgeInsets.all(16),
            color: primary.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(widget.from.split('(')[1].replaceAll(')', ''), 'From'),
                Icon(Icons.flight_takeoff, color: primary, size: 24),
                _buildSummaryItem(widget.to.split('(')[1].replaceAll(')', ''), 'To'),
              ],
            ),
          ),

          // Sort Options
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: _buildSortButton('Price', 'price'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSortButton('Duration', 'duration'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSortButton('Departure', 'departure'),
                ),
              ],
            ),
          ),

          // Flight List
          Expanded(
            child: filteredFlights.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.flight_takeoff, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'No flights found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredFlights.length,
                    itemBuilder: (context, index) {
                      return _buildFlightCard(filteredFlights[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String code, String label) {
    return Column(
      children: [
        Text(
          code,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSortButton(String label, String value) {
    final isActive = _sortBy == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _sortBy = value;
          _sortFlights();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: primary,
            width: isActive ? 0 : 1,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? Colors.white : primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFlightCard(Flight flight) {
    final price = widget.travelClass == 'Business'
        ? flight.priceBusiness
        : flight.priceEconomy;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Airline Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flight.airlineCode,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primary,
                      ),
                    ),
                    Text(
                      flight.airlineName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Direct',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 16),

            // Flight Times
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flight.departureTime,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      flight.departureCode,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      flight.durationFormatted,
                      style: TextStyle(
                        fontSize: 12,
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.flight_takeoff, color: primary, size: 20),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      flight.arrivalTime,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      flight.arrivalCode,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Price and Book Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'From',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      'Rs. ${price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    const Text(
                      'per person',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/seat_selection', arguments: {
                      'flight': flight,
                      'travelClass': widget.travelClass,
                      'passengers': widget.passengers,
                    });
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Book'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
