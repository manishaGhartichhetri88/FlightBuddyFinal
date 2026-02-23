// Use Cases - Business Logic Layer

import 'package:flightbuddy/core/models/entities.dart';
import 'package:flightbuddy/core/repositories/repositories.dart';

// ==================== Auth Use Cases ====================
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User?> call(String email, String password) async {
    return repository.login(email, password);
  }
}

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<User?> call(String email, String password, String fullName) async {
    return repository.register(email, password, fullName);
  }
}

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<bool> call() async {
    return repository.logout();
  }
}

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<User?> call() async {
    return repository.getCurrentUser();
  }
}

// ==================== Flight Use Cases ====================
class SearchFlightsUseCase {
  final FlightRepository repository;

  SearchFlightsUseCase(this.repository);

  Future<List<Flight>> call({
    required String fromCity,
    required String toCity,
    required DateTime departureDate,
    DateTime? returnDate,
    int passengers = 1,
  }) async {
    return repository.searchFlights(
      fromCity: fromCity,
      toCity: toCity,
      departureDate: departureDate,
      returnDate: returnDate,
      passengers: passengers,
    );
  }
}

class GetFlightDetailsUseCase {
  final FlightRepository repository;

  GetFlightDetailsUseCase(this.repository);

  Future<Flight?> call(String flightId) async {
    return repository.getFlightById(flightId);
  }
}

// ==================== Booking Use Cases ====================
class CreateBookingUseCase {
  final BookingRepository repository;

  CreateBookingUseCase(this.repository);

  Future<Booking> call({
    required String userId,
    required String flightId,
    required List<String> selectedSeats,
    required String travelClass,
    required List<Passenger> passengers,
    required double totalPrice,
    bool isReturn = false,
    String? returnFlightId,
    List<String>? returnSeats,
  }) async {
    return repository.createBooking(
      userId: userId,
      flightId: flightId,
      selectedSeats: selectedSeats,
      travelClass: travelClass,
      passengers: passengers,
      totalPrice: totalPrice,
      isReturn: isReturn,
      returnFlightId: returnFlightId,
      returnSeats: returnSeats,
    );
  }
}

class GetUserBookingsUseCase {
  final BookingRepository repository;

  GetUserBookingsUseCase(this.repository);

  Future<List<Booking>> call(String userId) async {
    return repository.getUserBookings(userId);
  }
}

class CancelBookingUseCase {
  final BookingRepository repository;

  CancelBookingUseCase(this.repository);

  Future<bool> call(String bookingId) async {
    return repository.cancelBooking(bookingId);
  }
}

// ==================== Passenger Use Cases ====================
class AddPassengerUseCase {
  final PassengerRepository repository;

  AddPassengerUseCase(this.repository);

  Future<bool> call(Passenger passenger) async {
    return repository.addPassenger(passenger);
  }
}

class GetUserPassengersUseCase {
  final PassengerRepository repository;

  GetUserPassengersUseCase(this.repository);

  Future<List<Passenger>> call(String userId) async {
    return repository.getUserPassengers(userId);
  }
}

// ==================== Seat Use Cases ====================
class GetFlightSeatsUseCase {
  final SeatRepository repository;

  GetFlightSeatsUseCase(this.repository);

  Future<List<Seat>> call(String flightId, String seatClass) async {
    return repository.getFlightSeats(flightId, seatClass);
  }
}

class SelectSeatUseCase {
  final SeatRepository repository;

  SelectSeatUseCase(this.repository);

  Future<bool> call(String flightId, String seatNumber, String passengerId) async {
    return repository.selectSeat(flightId, seatNumber, passengerId);
  }
}

// ==================== Payment Use Cases ====================
class ProcessPaymentUseCase {
  final PaymentRepository repository;

  ProcessPaymentUseCase(this.repository);

  Future<Payment> call({
    required String bookingId,
    required double amount,
    required String paymentMethod,
  }) async {
    return repository.processPayment(
      bookingId: bookingId,
      amount: amount,
      paymentMethod: paymentMethod,
    );
  }
}

// ==================== Offer Use Cases ====================
class GetActiveOffersUseCase {
  final OfferRepository repository;

  GetActiveOffersUseCase(this.repository);

  Future<List<Offer>> call() async {
    return repository.getActiveOffers();
  }
}

// ==================== Notification Use Cases ====================
class GetUserNotificationsUseCase {
  final NotificationRepository repository;

  GetUserNotificationsUseCase(this.repository);

  Future<List<Notification>> call(String userId) async {
    return repository.getUserNotifications(userId);
  }
}

class GetUnreadNotificationsCountUseCase {
  final NotificationRepository repository;

  GetUnreadNotificationsCountUseCase(this.repository);

  Future<int> call(String userId) async {
    return repository.getUnreadCount(userId);
  }
}

// ==================== Search History Use Cases ====================
class SaveSearchHistoryUseCase {
  final SearchHistoryRepository repository;

  SaveSearchHistoryUseCase(this.repository);

  Future<bool> call(SearchHistory history) async {
    return repository.saveSearchHistory(history);
  }
}

class GetSearchHistoryUseCase {
  final SearchHistoryRepository repository;

  GetSearchHistoryUseCase(this.repository);

  Future<List<SearchHistory>> call(String userId) async {
    return repository.getUserSearchHistory(userId);
  }
}
