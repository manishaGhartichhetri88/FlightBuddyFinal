import 'package:hive/hive.dart';

part 'hive_models.g.dart';

// ==================== User Model ====================
@HiveType(typeId: 0)
class HiveUser extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String email;

  @HiveField(2)
  String? fullName;

  @HiveField(3)
  String? phone;

  @HiveField(4)
  String? profileImage;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime updatedAt;

  HiveUser({
    required this.id,
    required this.email,
    this.fullName,
    this.phone,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
  });
}

// ==================== Flight Model ====================
@HiveType(typeId: 1)
class HiveFlight extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String airline;

  @HiveField(2)
  String flightNumber;

  @HiveField(3)
  String fromCity;

  @HiveField(4)
  String toCity;

  @HiveField(5)
  DateTime departureTime;

  @HiveField(6)
  DateTime arrivalTime;

  @HiveField(7)
  String duration;

  @HiveField(8)
  double priceEconomy;

  @HiveField(9)
  double priceBusiness;

  @HiveField(10)
  int availableSeatsEconomy;

  @HiveField(11)
  int availableSeatsBusiness;

  @HiveField(12)
  String aircraftType;

  @HiveField(13)
  bool isReturn;

  @HiveField(14)
  DateTime? returnDate;

  @HiveField(15)
  String stops;

  HiveFlight({
    required this.id,
    required this.airline,
    required this.flightNumber,
    required this.fromCity,
    required this.toCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.priceEconomy,
    required this.priceBusiness,
    required this.availableSeatsEconomy,
    required this.availableSeatsBusiness,
    required this.aircraftType,
    required this.isReturn,
    this.returnDate,
    required this.stops,
  });
}

// ==================== Seat Model ====================
@HiveType(typeId: 2)
class HiveSeat extends HiveObject {
  @HiveField(0)
  String seatNumber;

  @HiveField(1)
  String seatClass; // 'Economy', 'Business'

  @HiveField(2)
  bool isAvailable;

  @HiveField(3)
  bool isSelected;

  @HiveField(4)
  String? passengerId;

  HiveSeat({
    required this.seatNumber,
    required this.seatClass,
    required this.isAvailable,
    this.isSelected = false,
    this.passengerId,
  });
}

// ==================== Booking Model ====================
@HiveType(typeId: 3)
class HiveBooking extends HiveObject {
  @HiveField(0)
  String bookingId;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String flightId;

  @HiveField(3)
  List<String> selectedSeats;

  @HiveField(4)
  String travelClass;

  @HiveField(5)
  List<HivePassenger> passengers;

  @HiveField(6)
  double totalPrice;

  @HiveField(7)
  String status; // 'confirmed', 'pending', 'cancelled'

  @HiveField(8)
  DateTime bookingDate;

  @HiveField(9)
  DateTime? paymentDate;

  @HiveField(10)
  String? paymentMethod;

  @HiveField(11)
  bool isReturn;

  @HiveField(12)
  String? returnFlightId;

  @HiveField(13)
  List<String>? returnSeats;

  HiveBooking({
    required this.bookingId,
    required this.userId,
    required this.flightId,
    required this.selectedSeats,
    required this.travelClass,
    required this.passengers,
    required this.totalPrice,
    required this.status,
    required this.bookingDate,
    this.paymentDate,
    this.paymentMethod,
    required this.isReturn,
    this.returnFlightId,
    this.returnSeats,
  });
}

// ==================== Passenger Model ====================
@HiveType(typeId: 4)
class HivePassenger extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String firstName;

  @HiveField(2)
  String lastName;

  @HiveField(3)
  String email;

  @HiveField(4)
  String phone;

  @HiveField(5)
  String passportNumber;

  @HiveField(6)
  DateTime dateOfBirth;

  @HiveField(7)
  String nationality;

  @HiveField(8)
  bool isAdult;

  HivePassenger({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.passportNumber,
    required this.dateOfBirth,
    required this.nationality,
    required this.isAdult,
  });
}

// ==================== Search History Model ====================
@HiveType(typeId: 5)
class HiveSearchHistory extends HiveObject {
  @HiveField(0)
  String fromCity;

  @HiveField(1)
  String toCity;

  @HiveField(2)
  DateTime departureDate;

  @HiveField(3)
  DateTime? returnDate;

  @HiveField(4)
  int passengers;

  @HiveField(5)
  DateTime searchedAt;

  HiveSearchHistory({
    required this.fromCity,
    required this.toCity,
    required this.departureDate,
    this.returnDate,
    required this.passengers,
    required this.searchedAt,
  });
}

// ==================== Payment Model ====================
@HiveType(typeId: 6)
class HivePayment extends HiveObject {
  @HiveField(0)
  String paymentId;

  @HiveField(1)
  String bookingId;

  @HiveField(2)
  double amount;

  @HiveField(3)
  String paymentMethod; // 'card', 'paypal', 'google_pay', 'apple_pay'

  @HiveField(4)
  String status; // 'pending', 'completed', 'failed'

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime? completedAt;

  @HiveField(7)
  String? transactionId;

  HivePayment({
    required this.paymentId,
    required this.bookingId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.transactionId,
  });
}

// ==================== Offer/Promotion Model ====================
@HiveType(typeId: 7)
class HiveOffer extends HiveObject {
  @HiveField(0)
  String offerId;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  double discountPercentage;

  @HiveField(4)
  DateTime validFrom;

  @HiveField(5)
  DateTime validUntil;

  @HiveField(6)
  String? couponCode;

  @HiveField(7)
  bool isActive;

  HiveOffer({
    required this.offerId,
    required this.title,
    required this.description,
    required this.discountPercentage,
    required this.validFrom,
    required this.validUntil,
    this.couponCode,
    required this.isActive,
  });
}

// ==================== Notification Model ====================
@HiveType(typeId: 8)
class HiveNotification extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String title;

  @HiveField(3)
  String message;

  @HiveField(4)
  String type; // 'booking', 'offer', 'alert', 'general'

  @HiveField(5)
  bool isRead;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  String? relatedId; // booking ID, etc.

  HiveNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.relatedId,
  });
}
