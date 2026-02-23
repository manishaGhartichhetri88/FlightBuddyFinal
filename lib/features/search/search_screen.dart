import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// =========================
/// SEARCH SCREEN
/// =========================
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String tripType = 'One way';
  String fromCity = 'Nepal (NEP)';
  String toCity = 'Bangalore (BLR)';
  DateTime departureDate = DateTime.now();
  DateTime? returnDate;
  int passengers = 1;
  String travelClass = 'Economy';

  final Color primary = const Color(0xFF1565C0);
  final List<String> cities = [
    "Nepal (NEP)",
    "Delhi (DEL)",
    "Bangalore (BLR)",
    "Mumbai (BOM)",
    "Dubai (DXB)",
    "London (LHR)"
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Search Flights")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _tripSelector(width),
            const SizedBox(height: 20),

            // FROM & TO cities (responsive)
            Row(
              children: [
                Expanded(
                  child: _cityDropdown("From", fromCity, (val) => setState(() => fromCity = val!)),
                ),
                const SizedBox(width: 8),
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
                const SizedBox(width: 8),
                Expanded(
                  child: _cityDropdown("To", toCity, (val) => setState(() => toCity = val!)),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Departure & Return dates
            _infoTile(
              icon: Icons.calendar_today,
              title: "Departure",
              value: DateFormat('dd/MM/yyyy').format(departureDate),
              onTap: _selectDepartureDate,
            ),
            if (tripType == 'Round') ...[
              const SizedBox(height: 12),
              _infoTile(
                icon: Icons.calendar_today,
                title: "Return",
                value: returnDate != null
                    ? DateFormat('dd/MM/yyyy').format(returnDate!)
                    : "Select return date",
                onTap: _selectReturnDate,
              ),
            ],

            const SizedBox(height: 12),

            // Passengers
            _infoTile(
              icon: Icons.people,
              title: "Passengers",
              value: "$passengers Adult",
              onTap: _selectPassengers,
            ),

            const SizedBox(height: 12),

            // Travel Class
            DropdownButtonFormField<String>(
              value: travelClass,
              decoration: const InputDecoration(
                labelText: "Class",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
              items: ['Economy', 'Business', 'First']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) => setState(() => travelClass = val!),
            ),

            const SizedBox(height: 20),

            // Search button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primary, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {
                  print(
                      "Trip: $tripType, From: $fromCity, To: $toCity, Passengers: $passengers, Class: $travelClass");
                },
                child: const Text("SEARCH FLIGHTS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // TRIP SELECTOR (responsive)
  // =========================
  Widget _tripSelector(double width) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ['One way', 'Round', 'Multi-city'].map((type) {
          final bool selected = tripType == type;
          return GestureDetector(
            onTap: () {
              setState(() {
                tripType = type;
                if (tripType != "Round") returnDate = null;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? primary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                type,
                style: TextStyle(color: selected ? Colors.white : primary, fontWeight: FontWeight.w600),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // =========================
  // CITY DROPDOWN
  // =========================
  Widget _cityDropdown(String label, String value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14)),
      items: cities.map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(),
      onChanged: onChanged,
    );
  }

  // =========================
  // INFO TILE
  // =========================
  Widget _infoTile({required IconData icon, required String title, required String value, required VoidCallback onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: primary),
      title: Text(title),
      subtitle: Text(value),
      onTap: onTap,
    );
  }

  // =========================
  // DATE PICKERS
  // =========================
  Future<void> _selectDepartureDate() async {
    final picked = await showDatePicker(context: context, initialDate: departureDate, firstDate: DateTime.now(), lastDate: DateTime(2030));
    if (picked != null) setState(() => departureDate = picked);
  }

  Future<void> _selectReturnDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: departureDate.add(const Duration(days: 1)),
      firstDate: departureDate.add(const Duration(days: 1)),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => returnDate = picked);
  }

  // =========================
  // PASSENGERS MODAL
  // =========================
  void _selectPassengers() {
    showModalBottomSheet(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Container(
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
                      if (passengers > 1) setModalState(() => passengers--);
                      setState(() {});
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Text("$passengers", style: const TextStyle(fontSize: 20)),
                  IconButton(
                    onPressed: () {
                      setModalState(() => passengers++);
                      setState(() {});
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}