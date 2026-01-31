class FlightSearch {
  String from;
  String to;
  DateTime departure;
  DateTime? returnDate;
  int travellers;
  String flightClass;
  String tripType;

  FlightSearch({
    required this.from,
    required this.to,
    required this.departure,
    this.returnDate,
    required this.travellers,
    required this.flightClass,
    required this.tripType,
  });
}
