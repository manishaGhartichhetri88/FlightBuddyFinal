import 'package:flightbuddy/core/models/flight_search.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FlightSearch stores data correctly', () {
    final flight = FlightSearch(
      from: 'KTM',
      to: 'BLR',
      departure: DateTime(2025),
      travellers: 1,
      flightClass: 'Economy',
      tripType: 'One way',
    );

    expect(flight.from, 'KTM');
  });
}
