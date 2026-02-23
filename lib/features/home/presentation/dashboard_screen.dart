import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flightbuddy/features/flights/presentation/flight_search_results_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String tripType = 'One way';
  String fromCity = 'Nepal (NEP)';
  String toCity = 'Bangalore (BLR)';
  DateTime departureDate = DateTime.now();
  DateTime? returnDate;
  int passengers = 1;
  String travelClass = 'Economy';

  final cities = [
    "Nepal (NEP)",
    "Delhi (DEL)",
    "Bangalore (BLR)",
    "Mumbai (BOM)",
    "Dubai (DXB)",
    "London (LHR)"
  ];

  final Color primary = const Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Greeting
              Text(
                "Hi Manisha",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Where would you like to fly today?",
                style: TextStyle(color: Colors.blueGrey.shade700),
              ),
              const SizedBox(height: 25),

              /// Trip Selector
              _tripSelector(),
              const SizedBox(height: 25),

              /// Search Card
              _searchCard(),
              const SizedBox(height: 30),

              /// Recent Bookings
              Text(
                "Your Recent Bookings",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: primary,
                ),
              ),
              const SizedBox(height: 15),
              _bookingCard("FD-405", "NEP → BLR", "Feb 25, 2026", "₹13,500", "Confirmed"),
              _bookingCard("FD-312", "DEL → BOM", "Feb 28, 2026", "₹8,900", "Upcoming"),

              const SizedBox(height: 30),

              /// Offers
              Text(
                "Hot Offers",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: primary,
                ),
              ),
              const SizedBox(height: 15),
              _offerCard("25% OFF with Mastercard"),
              _offerCard("33% OFF with Visa"),
              _offerCard("Earn 2x Points"),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// =========================
  /// TRIP SELECTOR
  /// =========================
  Widget _tripSelector() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ['One way', 'Round', 'Multi-city'].map((type) {
          bool selected = tripType == type;
          return GestureDetector(
            onTap: () {
              setState(() {
                tripType = type;
                if (tripType != "Round") returnDate = null;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? primary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                type,
                style: TextStyle(
                  color: selected ? Colors.white : primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// =========================
  /// SEARCH CARD
  /// =========================
  Widget _searchCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        children: [
          /// FROM & TO
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: fromCity,
                  decoration: const InputDecoration(
                    labelText: "From",
                    border: OutlineInputBorder(),
                  ),
                  items: cities
                      .map((city) => DropdownMenuItem(
                            value: city,
                            child: Text(city, overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => fromCity = val ?? fromCity),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.swap_vert),
                color: primary,
                onPressed: () {
                  setState(() {
                    final temp = fromCity;
                    fromCity = toCity;
                    toCity = temp;
                  });
                },
              ),
              Expanded(
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: toCity,
                  decoration: const InputDecoration(
                    labelText: "To",
                    border: OutlineInputBorder(),
                  ),
                  items: cities
                      .map((city) => DropdownMenuItem(
                            value: city,
                            child: Text(city, overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => toCity = val ?? toCity),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          /// DEPARTURE
          _infoTile(
            icon: Icons.calendar_today,
            title: "Departure",
            value: DateFormat('dd MMM yyyy').format(departureDate),
            onTap: _selectDate,
          ),

          /// RETURN (ONLY FOR ROUND TRIP)
          if (tripType == "Round") ...[
            const SizedBox(height: 12),
            _infoTile(
              icon: Icons.calendar_month,
              title: "Return",
              value: returnDate == null
                  ? "Select return date"
                  : DateFormat('dd MMM yyyy').format(returnDate!),
              onTap: _selectReturnDate,
            ),
          ],

          const SizedBox(height: 12),

          /// PASSENGERS
          _infoTile(
            icon: Icons.people,
            title: "Passengers",
            value: "$passengers Adult",
            onTap: _selectPassengers,
          ),

          const SizedBox(height: 12),

          /// CLASS
          DropdownButtonFormField<String>(
            initialValue: travelClass,
            decoration: const InputDecoration(
              labelText: "Class",
              border: OutlineInputBorder(),
            ),
            items: ['Economy', 'Business', 'First']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) => setState(() => travelClass = val ?? travelClass),
          ),

          const SizedBox(height: 20),

          /// SEARCH BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlightSearchResultsScreen(
                      fromCity: fromCity,
                      toCity: toCity,
                      departureDate: departureDate,
                      returnDate: tripType == 'Round' ? returnDate : null,
                      passengers: passengers,
                      travelClass: travelClass,
                    ),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  "SEARCH FLIGHTS",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// INFO TILE
  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: primary),
      title: Text(title),
      subtitle: Text(value),
      onTap: onTap,
    );
  }

  /// DEPARTURE DATE PICKER
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: departureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) setState(() => departureDate = picked);
  }

  /// RETURN DATE PICKER
  Future<void> _selectReturnDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: departureDate,
      firstDate: departureDate,
      lastDate: DateTime(2030),
    );

    if (picked != null) setState(() => returnDate = picked);
  }

  /// PASSENGER SELECTOR
  void _selectPassengers() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        height: 200,
        child: Column(
          children: [
            const Text("Select Passengers", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    if (passengers > 1) setState(() => passengers--);
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text("$passengers", style: const TextStyle(fontSize: 20)),
                IconButton(
                  onPressed: () => setState(() => passengers++),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// OFFERS
  Widget _offerCard(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        children: [
          Icon(Icons.local_offer, color: primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w600, color: primary),
            ),
          ),
          Icon(Icons.arrow_forward, color: primary, size: 20),
        ],
      ),
    );
  }

  /// BOOKING CARD
  Widget _bookingCard(
    String flightCode,
    String route,
    String date,
    String price,
    String status,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
        border: Border.all(
          color: status == "Confirmed" ? Colors.green : Colors.orange,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    flightCode,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    route,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: status == "Confirmed"
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color:
                        status == "Confirmed" ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(date, style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
              Text(
                price,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }}