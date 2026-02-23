// Frame 10: Select Your Flight
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flightbuddy/core/models/entities.dart';
import 'package:flightbuddy/core/providers/providers.dart';
import 'booking_details_screen_clean.dart';

class FlightSearchResultsScreen extends ConsumerStatefulWidget {
  final String fromCity;
  final String toCity;
  final DateTime departureDate;
  final DateTime? returnDate;
  final int passengers;
  final String travelClass;

  const FlightSearchResultsScreen({
    super.key,
    required this.fromCity,
    required this.toCity,
    required this.departureDate,
    this.returnDate,
    required this.passengers,
    required this.travelClass,
  });

  @override
  ConsumerState<FlightSearchResultsScreen> createState() =>
      _FlightSearchResultsScreenState();
}

class _FlightSearchResultsScreenState
    extends ConsumerState<FlightSearchResultsScreen> {
  late String selectedClass;
  late Flight? selectedFlight;
  late final Map<String, dynamic> _searchParams;

  @override
  void initState() {
    super.initState();
    selectedClass = widget.travelClass;
    selectedFlight = null;
    _searchParams = {
      'fromCity': widget.fromCity,
      'toCity': widget.toCity,
      'departureDate': widget.departureDate,
      'returnDate': widget.returnDate,
      'passengers': widget.passengers,
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure the search provider runs once the widget is mounted with correct params
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        debugPrint('Refreshing searchFlightsProvider from FlightSearchResultsScreen with $_searchParams');
        // ignore: unused_result
        ref.refresh(searchFlightsProvider(_searchParams));
      } catch (e) {
        debugPrint('Error refreshing searchFlightsProvider: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = const Color(0xFF42A5F5);
    final primaryColor = const Color(0xFF1565C0);

    // Use the cached search params so Riverpod family key matches
    final flightsAsync = ref.watch(searchFlightsProvider(_searchParams));

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Select Your Flight', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: flightsAsync.when(
          data: (flights) {
            if (flights.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flight_takeoff, size: 80, color: Colors.white.withOpacity(0.5)),
                    const SizedBox(height: 16),
                    Text('No flights found', style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.7))),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Route Header with Route Visualization
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        // Route with Cities
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // From City
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    widget.fromCity.split('(')[1].replaceAll(')', ''),
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                            // Route Line with Airplane
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 2,
                                          color: Colors.blue.shade300,
                                          margin: const EdgeInsets.symmetric(horizontal: 8),
                                        ),
                                      ),
                                      Icon(Icons.flight_takeoff, color: primaryColor, size: 24),
                                      Expanded(
                                        child: Container(
                                          height: 2,
                                          color: Colors.blue.shade300,
                                          margin: const EdgeInsets.symmetric(horizontal: 8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // To City
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    widget.toCity.split('(')[1].replaceAll(')', ''),
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Date and Passenger Info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.blue.shade300),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today, color: primaryColor, size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    DateFormat('dd/MMM/yyyy').format(widget.departureDate),
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.blue.shade300),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.person, color: primaryColor, size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${widget.passengers} passenger${widget.passengers > 1 ? 's' : ''}',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Class Selector
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _buildClassButton(
                          label: 'Economy',
                          isSelected: selectedClass == 'Economy',
                          onTap: () => setState(() => selectedClass = 'Economy'),
                        ),
                        const SizedBox(width: 12),
                        _buildClassButton(
                          label: 'Business',
                          isSelected: selectedClass == 'Business',
                          onTap: () => setState(() => selectedClass = 'Business'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Flight Cards
                  ...flights.map((flight) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildFlightCard(
                      flight,
                      primaryColor,
                      isSelected: selectedFlight?.id == flight.id,
                      onTap: () => setState(() => selectedFlight = flight),
                    ),
                  )),

                  const SizedBox(height: 20),

                  // Continue Button
                  if (selectedFlight != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FlightDetailsScreen(
                                flight: selectedFlight!,
                                fromCity: widget.fromCity,
                                toCity: widget.toCity,
                                departureDate: widget.departureDate,
                                passengers: widget.passengers,
                                selectedClass: selectedClass,
                              ),
                            ),
                          );
                        },
                        child: Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor)),
                      ),
                    ),
                ],
              ),
            );
          },
          loading: () => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white),
                const SizedBox(height: 16),
                Text(
                  'Loading flights...',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          error: (err, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 80, color: Colors.white.withOpacity(0.5)),
                const SizedBox(height: 16),
                Text(
                  'Error loading flights',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please try again',
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClassButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF666666) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black87,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlightCard(Flight flight, Color primary, {required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primary : Colors.transparent,
            width: isSelected ? 2 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Times & Cities Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Departure
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(flight.departureTime),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.redAccent),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      flight.fromCity.split('(')[1].replaceAll(')', ''),
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                // Duration & Route
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flight_takeoff, color: primary, size: 18),
                    const SizedBox(height: 2),
                    Text(
                      flight.duration.replaceAll('h ', 'hrs '),
                      style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                // Arrival
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(flight.arrivalTime),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.redAccent),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      flight.toCity.split('(')[1].replaceAll(')', ''),
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),
            
            // Dotted Divider
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: List.generate(
                        20,
                        (index) => Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            height: 1,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Airline & Price Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Airline with placeholder icon
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.flight,
                            color: primary,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              flight.airline,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              flight.flightNumber,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Rs ${selectedClass == 'Economy' ? flight.priceEconomy : flight.priceBusiness}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      Text(
                        selectedClass,
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
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

// Frame 11: Flight Details
class FlightDetailsScreen extends ConsumerWidget {
  final Flight flight;
  final String fromCity;
  final String toCity;
  final DateTime departureDate;
  final int passengers;
  final String selectedClass;

  const FlightDetailsScreen({
    super.key,
    required this.flight,
    required this.fromCity,
    required this.toCity,
    required this.departureDate,
    required this.passengers,
    required this.selectedClass,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bgColor = const Color(0xFF42A5F5);
    final primaryColor = const Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Flight Details', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Flight Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
                ),
                child: Column(
                  children: [
                    // Route Times
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('HH:mm').format(flight.departureTime),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(flight.fromCity, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          ],
                        ),
                        Icon(Icons.flight_takeoff, color: primaryColor, size: 40),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              DateFormat('HH:mm').format(flight.arrivalTime),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(flight.toCity, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Map Section (placeholder)
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on, color: primaryColor, size: 40),
                            const SizedBox(height: 8),
                            Text(
                              '${flight.fromCity} → ${flight.toCity}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              'International Airport',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),

                    // Details
                    _buildDetailRow('Date', DateFormat('dd/MM/yyyy').format(departureDate)),
                    const SizedBox(height: 12),
                    _buildDetailRow('Time', DateFormat('HH:mm').format(flight.departureTime)),
                    const SizedBox(height: 12),
                    _buildDetailRow('Airline', flight.airline),
                    const SizedBox(height: 12),
                    _buildDetailRow('Aircraft', flight.aircraftType),
                    const SizedBox(height: 12),
                    _buildDetailRow('Passengers', '$passengers Adult'),

                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),

                    // Price
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Price', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(
                            'Rs ${selectedClass == 'Economy' ? flight.priceEconomy : flight.priceBusiness}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeatSelectionScreenUpdated(
                              flight: flight,
                              fromCity: fromCity,
                              toCity: toCity,
                              departureDate: departureDate,
                              passengers: passengers,
                              selectedClass: selectedClass,
                            ),
                          ),
                        );
                      },
                      child: Text('Continue', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// Frames 12 & 13: Seat Selection with Class Toggle
class SeatSelectionScreenUpdated extends ConsumerStatefulWidget {
  final Flight flight;
  final String fromCity;
  final String toCity;
  final DateTime departureDate;
  final int passengers;
  final String selectedClass;

  const SeatSelectionScreenUpdated({
    super.key,
    required this.flight,
    required this.fromCity,
    required this.toCity,
    required this.departureDate,
    required this.passengers,
    required this.selectedClass,
  });

  @override
  ConsumerState<SeatSelectionScreenUpdated> createState() =>
      _SeatSelectionScreenUpdatedState();
}

class _SeatSelectionScreenUpdatedState
    extends ConsumerState<SeatSelectionScreenUpdated> {
  late String currentClass;
  late Set<String> selectedSeats;
  final int seatsPerRow = 6;
  final int rows = 6;

  @override
  void initState() {
    super.initState();
    currentClass = widget.selectedClass;
    selectedSeats = {};
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = const Color(0xFF42A5F5);
    final primaryColor = const Color(0xFF1565C0);
    final seatColor = currentClass == 'Economy' ? const Color(0xFF1565C0) : const Color(0xFF76FF03);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('${currentClass} Class Seat', style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Class Selector
              Row(
                children: [
                  _buildClassTab('Economy', 'Economy', primaryColor, seatColor),
                  const SizedBox(width: 12),
                  _buildClassTab('Business', 'Business', primaryColor, seatColor),
                ],
              ),

              const SizedBox(height: 20),

              // Legend
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildLegendItem('Selected', seatColor),
                    _buildLegendItem('Emergency exit', Colors.orange),
                    _buildLegendItem('Reserved', Colors.grey),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Seat Grid
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < rows; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int j = 0; j < seatsPerRow; j++)
                              _buildSeat(seatColor, '\$${String.fromCharCode(65 + i)}${j + 1}', i, j),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    Text(
                      'Selected: ${selectedSeats.length}/${widget.passengers}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: selectedSeats.length == widget.passengers
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingDetailsScreenClean(
                                flight: widget.flight,
                                selectedSeats: selectedSeats.toList(),
                                travelClass: currentClass,
                                passengerCount: widget.passengers,
                              ),
                            ),
                          );
                        }
                      : null,
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassTab(String label, String value, Color primary, Color seatColor) {
    final isSelected = currentClass == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => currentClass = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? primary : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  Widget _buildSeat(Color seatColor, String seatNumber, int row, int col) {
    final isSelected = selectedSeats.contains(seatNumber);
    final isEmergencyExit = (row == 0 || row == rows - 1) && col > 2;
    final isReserved = row == 2 && col == 3;

    Color backgroundColor = Colors.grey.shade300;
    if (isEmergencyExit) {
      backgroundColor = Colors.orange;
    } else if (isReserved) {
      backgroundColor = Colors.grey;
    } else if (isSelected) {
      backgroundColor = seatColor;
    } else {
      backgroundColor = Colors.grey.shade200;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {
          if (!isEmergencyExit && !isReserved && selectedSeats.length < widget.passengers || isSelected) {
            setState(() {
              if (isSelected) {
                selectedSeats.remove(seatNumber);
              } else if (selectedSeats.length < widget.passengers) {
                selectedSeats.add(seatNumber);
              }
            });
          }
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
            border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
          ),
          child: Center(
            child: Text(
              seatNumber.split('\$')[1],
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: (isEmergencyExit || isReserved) ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
