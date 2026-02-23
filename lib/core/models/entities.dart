// Domain Entities (Plain Dart objects - not tied to Hive or any framework)

import 'package:equatable/equatable.dart';

// ==================== User Entity ====================
class User extends Equatable {
  final String id;
  final String email;
  final String? fullName;
  final String? phone;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    this.fullName,
    this.phone,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        phone,
        profileImage,
        createdAt,
        updatedAt,
      ];

  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// ==================== Flight Entity ====================
class Flight extends Equatable {
  final String id;
  final String airline;
  final String flightNumber;
  final String fromCity;
  final String toCity;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String duration;
  final double priceEconomy;
  final double priceBusiness;
  final int availableSeatsEconomy;
  final int availableSeatsBusiness;
  final String aircraftType;
  final bool isReturn;
  final DateTime? returnDate;
  final String stops;

  const Flight({
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

  @override
  List<Object?> get props => [
        id,
        airline,
        flightNumber,
        fromCity,
        toCity,
        departureTime,
        arrivalTime,
        duration,
        priceEconomy,
        priceBusiness,
        availableSeatsEconomy,
        availableSeatsBusiness,
        aircraftType,
        isReturn,
        returnDate,
        stops,
      ];

  Flight copyWith({
    String? id,
    String? airline,
    String? flightNumber,
    String? fromCity,
    String? toCity,
    DateTime? departureTime,
    DateTime? arrivalTime,
    String? duration,
    double? priceEconomy,
    double? priceBusiness,
    int? availableSeatsEconomy,
    int? availableSeatsBusiness,
    String? aircraftType,
    bool? isReturn,
    DateTime? returnDate,
    String? stops,
  }) {
    return Flight(
      id: id ?? this.id,
      airline: airline ?? this.airline,
      flightNumber: flightNumber ?? this.flightNumber,
      fromCity: fromCity ?? this.fromCity,
      toCity: toCity ?? this.toCity,
      departureTime: departureTime ?? this.departureTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      duration: duration ?? this.duration,
      priceEconomy: priceEconomy ?? this.priceEconomy,
      priceBusiness: priceBusiness ?? this.priceBusiness,
      availableSeatsEconomy: availableSeatsEconomy ?? this.availableSeatsEconomy,
      availableSeatsBusiness:
          availableSeatsBusiness ?? this.availableSeatsBusiness,
      aircraftType: aircraftType ?? this.aircraftType,
      isReturn: isReturn ?? this.isReturn,
      returnDate: returnDate ?? this.returnDate,
      stops: stops ?? this.stops,
    );
  }
}

// ==================== Seat Entity ====================
class Seat extends Equatable {
  final String seatNumber;
  final String seatClass;
  final bool isAvailable;
  final bool isSelected;
  final String? passengerId;

  const Seat({
    required this.seatNumber,
    required this.seatClass,
    required this.isAvailable,
    this.isSelected = false,
    this.passengerId,
  });

  @override
  List<Object?> get props =>
      [seatNumber, seatClass, isAvailable, isSelected, passengerId];

  Seat copyWith({
    String? seatNumber,
    String? seatClass,
    bool? isAvailable,
    bool? isSelected,
    String? passengerId,
  }) {
    return Seat(
      seatNumber: seatNumber ?? this.seatNumber,
      seatClass: seatClass ?? this.seatClass,
      isAvailable: isAvailable ?? this.isAvailable,
      isSelected: isSelected ?? this.isSelected,
      passengerId: passengerId ?? this.passengerId,
    );
  }
}

// ==================== Passenger Entity ====================
class Passenger extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String passportNumber;
  final DateTime dateOfBirth;
  final String nationality;
  final bool isAdult;

  const Passenger({
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

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        passportNumber,
        dateOfBirth,
        nationality,
        isAdult,
      ];

  String get fullName => '$firstName $lastName';

  Passenger copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? passportNumber,
    DateTime? dateOfBirth,
    String? nationality,
    bool? isAdult,
  }) {
    return Passenger(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      passportNumber: passportNumber ?? this.passportNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      nationality: nationality ?? this.nationality,
      isAdult: isAdult ?? this.isAdult,
    );
  }
}

// ==================== Booking Entity ====================
class Booking extends Equatable {
  final String bookingId;
  final String userId;
  final String flightId;
  final List<String> selectedSeats;
  final String travelClass;
  final List<Passenger> passengers;
  final double totalPrice;
  final String status;
  final DateTime bookingDate;
  final DateTime? paymentDate;
  final String? paymentMethod;
  final bool isReturn;
  final String? returnFlightId;
  final List<String>? returnSeats;

  const Booking({
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

  @override
  List<Object?> get props => [
        bookingId,
        userId,
        flightId,
        selectedSeats,
        travelClass,
        passengers,
        totalPrice,
        status,
        bookingDate,
        paymentDate,
        paymentMethod,
        isReturn,
        returnFlightId,
        returnSeats,
      ];

  Booking copyWith({
    String? bookingId,
    String? userId,
    String? flightId,
    List<String>? selectedSeats,
    String? travelClass,
    List<Passenger>? passengers,
    double? totalPrice,
    String? status,
    DateTime? bookingDate,
    DateTime? paymentDate,
    String? paymentMethod,
    bool? isReturn,
    String? returnFlightId,
    List<String>? returnSeats,
  }) {
    return Booking(
      bookingId: bookingId ?? this.bookingId,
      userId: userId ?? this.userId,
      flightId: flightId ?? this.flightId,
      selectedSeats: selectedSeats ?? this.selectedSeats,
      travelClass: travelClass ?? this.travelClass,
      passengers: passengers ?? this.passengers,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      bookingDate: bookingDate ?? this.bookingDate,
      paymentDate: paymentDate ?? this.paymentDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isReturn: isReturn ?? this.isReturn,
      returnFlightId: returnFlightId ?? this.returnFlightId,
      returnSeats: returnSeats ?? this.returnSeats,
    );
  }
}

// ==================== Payment Entity ====================
class Payment extends Equatable {
  final String paymentId;
  final String bookingId;
  final double amount;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? transactionId;

  const Payment({
    required this.paymentId,
    required this.bookingId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.transactionId,
  });

  @override
  List<Object?> get props => [
        paymentId,
        bookingId,
        amount,
        paymentMethod,
        status,
        createdAt,
        completedAt,
        transactionId,
      ];

  Payment copyWith({
    String? paymentId,
    String? bookingId,
    double? amount,
    String? paymentMethod,
    String? status,
    DateTime? createdAt,
    DateTime? completedAt,
    String? transactionId,
  }) {
    return Payment(
      paymentId: paymentId ?? this.paymentId,
      bookingId: bookingId ?? this.bookingId,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      transactionId: transactionId ?? this.transactionId,
    );
  }
}

// ==================== Offer Entity ====================
class Offer extends Equatable {
  final String offerId;
  final String title;
  final String description;
  final double discountPercentage;
  final DateTime validFrom;
  final DateTime validUntil;
  final String? couponCode;
  final bool isActive;

  const Offer({
    required this.offerId,
    required this.title,
    required this.description,
    required this.discountPercentage,
    required this.validFrom,
    required this.validUntil,
    this.couponCode,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        offerId,
        title,
        description,
        discountPercentage,
        validFrom,
        validUntil,
        couponCode,
        isActive,
      ];
}

// ==================== Notification Entity ====================
class Notification extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final String? relatedId;

  const Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.relatedId,
  });

  @override
  List<Object?> get props =>
      [id, userId, title, message, type, isRead, createdAt, relatedId];

  Notification copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    DateTime? createdAt,
    String? relatedId,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      relatedId: relatedId ?? this.relatedId,
    );
  }
}

// ==================== Search History Entity ====================
class SearchHistory extends Equatable {
  final String fromCity;
  final String toCity;
  final DateTime departureDate;
  final DateTime? returnDate;
  final int passengers;
  final DateTime searchedAt;

  const SearchHistory({
    required this.fromCity,
    required this.toCity,
    required this.departureDate,
    this.returnDate,
    required this.passengers,
    required this.searchedAt,
  });

  @override
  List<Object?> get props => [
        fromCity,
        toCity,
        departureDate,
        returnDate,
        passengers,
        searchedAt,
      ];
}
