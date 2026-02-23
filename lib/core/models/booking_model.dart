import 'package:hive/hive.dart';
import 'flight_model.dart';

part 'booking_model.g.dart';

@HiveType(typeId: 2) // LO 4: Using Hive for persistence
class Booking {
  @HiveField(0)
  final String bookingId;
  @HiveField(1)
  final Flight flight;
  @HiveField(2)
  final List<String> selectedSeats;
  @HiveField(3)
  final double totalPrice;
  @HiveField(4)
  final DateTime bookingDate;
  @HiveField(5)
  final String passengerName;

  Booking({
    required this.bookingId,
    required this.flight,
    required this.selectedSeats,
    required this.totalPrice,
    required this.bookingDate,
    required this.passengerName,
  });
}