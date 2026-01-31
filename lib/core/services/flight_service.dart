import '../models/flight_search.dart';

class FlightService {
  Future<List<String>> searchFlights(FlightSearch search) async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      "Nepal Airlines - ₹12,000",
      "IndiGo - ₹13,500",
      "Vistara - ₹15,000",
    ];
  }
}
