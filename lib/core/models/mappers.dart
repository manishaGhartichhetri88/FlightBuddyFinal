// Mappers to convert between Hive models and Domain entities

import 'package:flightbuddy/core/models/entities.dart';
import 'package:flightbuddy/core/models/hive_models.dart';

class EntityMappers {
  // ==================== User Mappings ====================
  static User hiveUserToEntity(HiveUser hive) {
    return User(
      id: hive.id,
      email: hive.email,
      fullName: hive.fullName,
      phone: hive.phone,
      profileImage: hive.profileImage,
      createdAt: hive.createdAt,
      updatedAt: hive.updatedAt,
    );
  }

  static HiveUser entityToHiveUser(User entity) {
    return HiveUser(
      id: entity.id,
      email: entity.email,
      fullName: entity.fullName,
      phone: entity.phone,
      profileImage: entity.profileImage,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // ==================== Flight Mappings ====================
  static Flight hiveFlightToEntity(HiveFlight hive) {
    return Flight(
      id: hive.id,
      airline: hive.airline,
      flightNumber: hive.flightNumber,
      fromCity: hive.fromCity,
      toCity: hive.toCity,
      departureTime: hive.departureTime,
      arrivalTime: hive.arrivalTime,
      duration: hive.duration,
      priceEconomy: hive.priceEconomy,
      priceBusiness: hive.priceBusiness,
      availableSeatsEconomy: hive.availableSeatsEconomy,
      availableSeatsBusiness: hive.availableSeatsBusiness,
      aircraftType: hive.aircraftType,
      isReturn: hive.isReturn,
      returnDate: hive.returnDate,
      stops: hive.stops,
    );
  }

  static HiveFlight entityToHiveFlight(Flight entity) {
    return HiveFlight(
      id: entity.id,
      airline: entity.airline,
      flightNumber: entity.flightNumber,
      fromCity: entity.fromCity,
      toCity: entity.toCity,
      departureTime: entity.departureTime,
      arrivalTime: entity.arrivalTime,
      duration: entity.duration,
      priceEconomy: entity.priceEconomy,
      priceBusiness: entity.priceBusiness,
      availableSeatsEconomy: entity.availableSeatsEconomy,
      availableSeatsBusiness: entity.availableSeatsBusiness,
      aircraftType: entity.aircraftType,
      isReturn: entity.isReturn,
      returnDate: entity.returnDate,
      stops: entity.stops,
    );
  }

  // ==================== Seat Mappings ====================
  static Seat hiveSeatToEntity(HiveSeat hive) {
    return Seat(
      seatNumber: hive.seatNumber,
      seatClass: hive.seatClass,
      isAvailable: hive.isAvailable,
      isSelected: hive.isSelected,
      passengerId: hive.passengerId,
    );
  }

  static HiveSeat entityToHiveSeat(Seat entity) {
    return HiveSeat(
      seatNumber: entity.seatNumber,
      seatClass: entity.seatClass,
      isAvailable: entity.isAvailable,
      isSelected: entity.isSelected,
      passengerId: entity.passengerId,
    );
  }

  // ==================== Passenger Mappings ====================
  static Passenger hivePassengerToEntity(HivePassenger hive) {
    return Passenger(
      id: hive.id,
      firstName: hive.firstName,
      lastName: hive.lastName,
      email: hive.email,
      phone: hive.phone,
      passportNumber: hive.passportNumber,
      dateOfBirth: hive.dateOfBirth,
      nationality: hive.nationality,
      isAdult: hive.isAdult,
    );
  }

  static HivePassenger entityToHivePassenger(Passenger entity) {
    return HivePassenger(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phone: entity.phone,
      passportNumber: entity.passportNumber,
      dateOfBirth: entity.dateOfBirth,
      nationality: entity.nationality,
      isAdult: entity.isAdult,
    );
  }

  // ==================== Booking Mappings ====================
  static Booking hiveBookingToEntity(HiveBooking hive) {
    return Booking(
      bookingId: hive.bookingId,
      userId: hive.userId,
      flightId: hive.flightId,
      selectedSeats: hive.selectedSeats,
      travelClass: hive.travelClass,
      passengers: hive.passengers
          .map((p) => hivePassengerToEntity(p))
          .toList(),
      totalPrice: hive.totalPrice,
      status: hive.status,
      bookingDate: hive.bookingDate,
      paymentDate: hive.paymentDate,
      paymentMethod: hive.paymentMethod,
      isReturn: hive.isReturn,
      returnFlightId: hive.returnFlightId,
      returnSeats: hive.returnSeats,
    );
  }

  static HiveBooking entityToHiveBooking(Booking entity) {
    return HiveBooking(
      bookingId: entity.bookingId,
      userId: entity.userId,
      flightId: entity.flightId,
      selectedSeats: entity.selectedSeats,
      travelClass: entity.travelClass,
      passengers: entity.passengers
          .map((p) => entityToHivePassenger(p))
          .toList(),
      totalPrice: entity.totalPrice,
      status: entity.status,
      bookingDate: entity.bookingDate,
      paymentDate: entity.paymentDate,
      paymentMethod: entity.paymentMethod,
      isReturn: entity.isReturn,
      returnFlightId: entity.returnFlightId,
      returnSeats: entity.returnSeats,
    );
  }

  // ==================== Payment Mappings ====================
  static Payment hivePaymentToEntity(HivePayment hive) {
    return Payment(
      paymentId: hive.paymentId,
      bookingId: hive.bookingId,
      amount: hive.amount,
      paymentMethod: hive.paymentMethod,
      status: hive.status,
      createdAt: hive.createdAt,
      completedAt: hive.completedAt,
      transactionId: hive.transactionId,
    );
  }

  static HivePayment entityToHivePayment(Payment entity) {
    return HivePayment(
      paymentId: entity.paymentId,
      bookingId: entity.bookingId,
      amount: entity.amount,
      paymentMethod: entity.paymentMethod,
      status: entity.status,
      createdAt: entity.createdAt,
      completedAt: entity.completedAt,
      transactionId: entity.transactionId,
    );
  }

  // ==================== Offer Mappings ====================
  static Offer hiveOfferToEntity(HiveOffer hive) {
    return Offer(
      offerId: hive.offerId,
      title: hive.title,
      description: hive.description,
      discountPercentage: hive.discountPercentage,
      validFrom: hive.validFrom,
      validUntil: hive.validUntil,
      couponCode: hive.couponCode,
      isActive: hive.isActive,
    );
  }

  static HiveOffer entityToHiveOffer(Offer entity) {
    return HiveOffer(
      offerId: entity.offerId,
      title: entity.title,
      description: entity.description,
      discountPercentage: entity.discountPercentage,
      validFrom: entity.validFrom,
      validUntil: entity.validUntil,
      couponCode: entity.couponCode,
      isActive: entity.isActive,
    );
  }

  // ==================== Notification Mappings ====================
  static Notification hiveNotificationToEntity(HiveNotification hive) {
    return Notification(
      id: hive.id,
      userId: hive.userId,
      title: hive.title,
      message: hive.message,
      type: hive.type,
      isRead: hive.isRead,
      createdAt: hive.createdAt,
      relatedId: hive.relatedId,
    );
  }

  static HiveNotification entityToHiveNotification(Notification entity) {
    return HiveNotification(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      message: entity.message,
      type: entity.type,
      isRead: entity.isRead,
      createdAt: entity.createdAt,
      relatedId: entity.relatedId,
    );
  }

  // ==================== SearchHistory Mappings ====================
  static SearchHistory hiveSearchHistoryToEntity(HiveSearchHistory hive) {
    return SearchHistory(
      fromCity: hive.fromCity,
      toCity: hive.toCity,
      departureDate: hive.departureDate,
      returnDate: hive.returnDate,
      passengers: hive.passengers,
      searchedAt: hive.searchedAt,
    );
  }

  static HiveSearchHistory entityToHiveSearchHistory(SearchHistory entity) {
    return HiveSearchHistory(
      fromCity: entity.fromCity,
      toCity: entity.toCity,
      departureDate: entity.departureDate,
      returnDate: entity.returnDate,
      passengers: entity.passengers,
      searchedAt: entity.searchedAt,
    );
  }
}
