// Abstract Repository Interfaces

import 'package:flightbuddy/core/models/entities.dart';

abstract class AuthRepository {
  Future<User?> login(String email, String password);
  Future<User?> register(String email, String password, String fullName);
  Future<User?> getCurrentUser();
  Future<bool> logout();
  Future<bool> isLoggedIn();
  Future<User?> updateUserProfile(User user);
}

abstract class FlightRepository {
  Future<List<Flight>> searchFlights({
    required String fromCity,
    required String toCity,
    required DateTime departureDate,
    DateTime? returnDate,
    int passengers = 1,
  });

  Future<Flight?> getFlightById(String flightId);
  Future<List<Flight>> getAllFlights();
  Future<bool> saveFlightLocally(Flight flight);
  Future<List<Flight>> getLocalFlights();
}

abstract class BookingRepository {
  Future<Booking> createBooking({
    required String userId,
    required String flightId,
    required List<String> selectedSeats,
    required String travelClass,
    required List<Passenger> passengers,
    required double totalPrice,
    bool isReturn = false,
    String? returnFlightId,
    List<String>? returnSeats,
  });

  Future<Booking?> getBookingById(String bookingId);
  Future<List<Booking>> getUserBookings(String userId);
  Future<bool> cancelBooking(String bookingId);
  Future<bool> updateBooking(Booking booking);
}

abstract class PassengerRepository {
  Future<bool> addPassenger(Passenger passenger);
  Future<Passenger?> getPassengerById(String passengerId);
  Future<List<Passenger>> getUserPassengers(String userId);
  Future<bool> updatePassenger(Passenger passenger);
  Future<bool> deletePassenger(String passengerId);
}

abstract class PaymentRepository {
  Future<Payment> processPayment({
    required String bookingId,
    required double amount,
    required String paymentMethod,
  });

  Future<Payment?> getPaymentByBookingId(String bookingId);
  Future<List<Payment>> getUserPayments(String userId);
}

abstract class OfferRepository {
  Future<List<Offer>> getAllOffers();
  Future<Offer?> getOfferById(String offerId);
  Future<bool> savOffer(Offer offer);
  Future<List<Offer>> getActiveOffers();
}

abstract class NotificationRepository {
  Future<bool> addNotification(Notification notification);
  Future<List<Notification>> getUserNotifications(String userId);
  Future<bool> markAsRead(String notificationId);
  Future<bool> deleteNotification(String notificationId);
  Future<int> getUnreadCount(String userId);
}

abstract class SearchHistoryRepository {
  Future<bool> saveSearchHistory(SearchHistory history);
  Future<List<SearchHistory>> getUserSearchHistory(String userId);
  Future<bool> clearSearchHistory(String userId);
}

abstract class SeatRepository {
  Future<List<Seat>> getFlightSeats(String flightId, String seatClass);
  Future<bool> updateSeatAvailability(String flightId, String seatNumber, bool isAvailable);
  Future<bool> selectSeat(String flightId, String seatNumber, String passengerId);
}
