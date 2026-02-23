// Flight Model
class Flight {
  final String id;
  final String airlineName;
  final String airlineCode;
  final String departureTime;
  final String arrivalTime;
  final String departureCity;
  final String arrivalCity;
  final String departureCode;
  final String arrivalCode;
  final int durationMinutes;
  final double priceEconomy;
  final double priceBusiness;
  final int seatsEconomyAvailable;
  final int seatsBusinessAvailable;
  final String date;
  final bool directFlight;
  final String airplane;

  Flight({
    required this.id,
    required this.airlineName,
    required this.airlineCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.departureCity,
    required this.arrivalCity,
    required this.departureCode,
    required this.arrivalCode,
    required this.durationMinutes,
    required this.priceEconomy,
    required this.priceBusiness,
    required this.seatsEconomyAvailable,
    required this.seatsBusinessAvailable,
    required this.date,
    required this.directFlight,
    required this.airplane,
  });

  String get durationFormatted {
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  String get formattedPrice {
    return 'Rs. ${priceEconomy.toStringAsFixed(0)}';
  }
}

// Mock Flight Data
final List<Flight> mockFlights = [
  Flight(
    id: 'FD405',
    airlineName: 'FlyDirect Airways',
    airlineCode: 'FD',
    departureTime: '06:30',
    arrivalTime: '10:45',
    departureCity: 'Kathmandu',
    arrivalCity: 'Bangalore',
    departureCode: 'KTM',
    arrivalCode: 'BLR',
    durationMinutes: 255,
    priceEconomy: 13500,
    priceBusiness: 24500,
    seatsEconomyAvailable: 45,
    seatsBusinessAvailable: 12,
    date: '2026-02-25',
    directFlight: true,
    airplane: 'Boeing 738',
  ),
  Flight(
    id: 'IA312',
    airlineName: 'Indian Airways',
    airlineCode: 'IA',
    departureTime: '08:15',
    arrivalTime: '13:20',
    departureCity: 'Kathmandu',
    arrivalCity: 'Bangalore',
    departureCode: 'KTM',
    arrivalCode: 'BLR',
    durationMinutes: 305,
    priceEconomy: 11200,
    priceBusiness: 19500,
    seatsEconomyAvailable: 32,
    seatsBusinessAvailable: 8,
    date: '2026-02-25',
    directFlight: true,
    airplane: 'Airbus A320',
  ),
  Flight(
    id: 'BA208',
    airlineName: 'Best Air Lines',
    airlineCode: 'BA',
    departureTime: '14:00',
    arrivalTime: '18:30',
    departureCity: 'Kathmandu',
    arrivalCity: 'Bangalore',
    departureCode: 'KTM',
    arrivalCode: 'BLR',
    durationMinutes: 270,
    priceEconomy: 10500,
    priceBusiness: 18000,
    seatsEconomyAvailable: 28,
    seatsBusinessAvailable: 5,
    date: '2026-02-25',
    directFlight: true,
    airplane: 'Boeing 787',
  ),
  Flight(
    id: 'FD410',
    airlineName: 'FlyDirect Airways',
    airlineCode: 'FD',
    departureTime: '16:45',
    arrivalTime: '21:00',
    departureCity: 'Kathmandu',
    arrivalCity: 'Bangalore',
    departureCode: 'KTM',
    arrivalCode: 'BLR',
    durationMinutes: 255,
    priceEconomy: 12800,
    priceBusiness: 23000,
    seatsEconomyAvailable: 55,
    seatsBusinessAvailable: 15,
    date: '2026-02-25',
    directFlight: true,
    airplane: 'Boeing 738',
  ),
];
