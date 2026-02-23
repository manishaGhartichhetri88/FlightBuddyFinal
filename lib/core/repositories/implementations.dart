// Repository Implementations using Hive

import 'package:flightbuddy/core/models/entities.dart';
import 'package:flightbuddy/core/models/hive_models.dart';
import 'package:flightbuddy/core/models/mappers.dart';
import 'package:flightbuddy/core/repositories/repositories.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

// ==================== Auth Repository Impl ====================
class HiveAuthRepository implements AuthRepository {
  final Box<HiveUser> userBox;

  HiveAuthRepository(this.userBox);

  @override
  Future<User?> login(String email, String password) async {
    try {
      // In real app, call API here
      // For now, check local storage
      for (var user in userBox.values) {
        if (user.email == email) {
          return EntityMappers.hiveUserToEntity(user);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> register(String email, String password, String fullName) async {
    try {
      final newUser = HiveUser(
        id: const Uuid().v4(),
        email: email,
        fullName: fullName,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await userBox.add(newUser);
      return EntityMappers.hiveUserToEntity(newUser);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      if (userBox.isNotEmpty) {
        return EntityMappers.hiveUserToEntity(userBox.getAt(0)!);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      // Clear user data
      await userBox.clear();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return userBox.isNotEmpty;
  }

  @override
  Future<User?> updateUserProfile(User user) async {
    try {
      for (int i = 0; i < userBox.length; i++) {
        if (userBox.getAt(i)?.id == user.id) {
          final updated = HiveUser(
            id: user.id,
            email: user.email,
            fullName: user.fullName,
            phone: user.phone,
            profileImage: user.profileImage,
            createdAt: user.createdAt,
            updatedAt: DateTime.now(),
          );
          await userBox.putAt(i, updated);
          return EntityMappers.hiveUserToEntity(updated);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

// ==================== Flight Repository Impl ====================
class HiveFlightRepository implements FlightRepository {
  final Box<HiveFlight> flightBox;

  HiveFlightRepository(this.flightBox);

  @override
  Future<List<Flight>> searchFlights({
    required String fromCity,
    required String toCity,
    required DateTime departureDate,
    DateTime? returnDate,
    int passengers = 1,
  }) async {
    try {
      // In real app, call API here
      // For now, return mock matching flights
      final flights = <Flight>[];
      for (var flight in flightBox.values) {
        if (flight.fromCity.toLowerCase() == fromCity.toLowerCase() &&
            flight.toCity.toLowerCase() == toCity.toLowerCase() &&
            flight.departureTime.year == departureDate.year &&
            flight.departureTime.month == departureDate.month &&
            flight.departureTime.day == departureDate.day) {
          flights.add(EntityMappers.hiveFlightToEntity(flight));
        }
      }
      return flights;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Flight?> getFlightById(String flightId) async {
    try {
      for (var flight in flightBox.values) {
        if (flight.id == flightId) {
          return EntityMappers.hiveFlightToEntity(flight);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Flight>> getAllFlights() async {
    try {
      return flightBox.values
          .map((f) => EntityMappers.hiveFlightToEntity(f))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> saveFlightLocally(Flight flight) async {
    try {
      final hiveFlight = EntityMappers.entityToHiveFlight(flight);
      await flightBox.add(hiveFlight);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Flight>> getLocalFlights() async {
    try {
      return flightBox.values
          .map((f) => EntityMappers.hiveFlightToEntity(f))
          .toList();
    } catch (e) {
      return [];
    }
  }
}

// ==================== Booking Repository Impl ====================
class HiveBookingRepository implements BookingRepository {
  final Box<HiveBooking> bookingBox;

  HiveBookingRepository(this.bookingBox);

  @override
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
  }) async {
    final bookingId = 'BK_${const Uuid().v4().substring(0, 8).toUpperCase()}';
    final hivePassengers = passengers
        .map((p) => EntityMappers.entityToHivePassenger(p))
        .toList();

    final booking = HiveBooking(
      bookingId: bookingId,
      userId: userId,
      flightId: flightId,
      selectedSeats: selectedSeats,
      travelClass: travelClass,
      passengers: hivePassengers,
      totalPrice: totalPrice,
      status: 'confirmed',
      bookingDate: DateTime.now(),
      isReturn: isReturn,
      returnFlightId: returnFlightId,
      returnSeats: returnSeats,
    );

    await bookingBox.add(booking);
    return EntityMappers.hiveBookingToEntity(booking);
  }

  @override
  Future<Booking?> getBookingById(String bookingId) async {
    try {
      for (var booking in bookingBox.values) {
        if (booking.bookingId == bookingId) {
          return EntityMappers.hiveBookingToEntity(booking);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Booking>> getUserBookings(String userId) async {
    try {
      final bookings = <Booking>[];
      for (var booking in bookingBox.values) {
        if (booking.userId == userId) {
          bookings.add(EntityMappers.hiveBookingToEntity(booking));
        }
      }
      return bookings;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> cancelBooking(String bookingId) async {
    try {
      for (int i = 0; i < bookingBox.length; i++) {
        if (bookingBox.getAt(i)?.bookingId == bookingId) {
          final booking = bookingBox.getAt(i)!;
          booking.status = 'cancelled';
          await bookingBox.putAt(i, booking);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateBooking(Booking booking) async {
    try {
      for (int i = 0; i < bookingBox.length; i++) {
        if (bookingBox.getAt(i)?.bookingId == booking.bookingId) {
          final updated = EntityMappers.entityToHiveBooking(booking);
          await bookingBox.putAt(i, updated);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

// ==================== Passenger Repository Impl ====================
class HivePassengerRepository implements PassengerRepository {
  final Box<HivePassenger> passengerBox;

  HivePassengerRepository(this.passengerBox);

  @override
  Future<bool> addPassenger(Passenger passenger) async {
    try {
      final hivePassenger = EntityMappers.entityToHivePassenger(passenger);
      await passengerBox.add(hivePassenger);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Passenger?> getPassengerById(String passengerId) async {
    try {
      for (var passenger in passengerBox.values) {
        if (passenger.id == passengerId) {
          return EntityMappers.hivePassengerToEntity(passenger);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Passenger>> getUserPassengers(String userId) async {
    // In real implementation, passengers would have userId field
    try {
      return passengerBox.values
          .map((p) => EntityMappers.hivePassengerToEntity(p))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> updatePassenger(Passenger passenger) async {
    try {
      for (int i = 0; i < passengerBox.length; i++) {
        if (passengerBox.getAt(i)?.id == passenger.id) {
          final updated = EntityMappers.entityToHivePassenger(passenger);
          await passengerBox.putAt(i, updated);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deletePassenger(String passengerId) async {
    try {
      for (int i = 0; i < passengerBox.length; i++) {
        if (passengerBox.getAt(i)?.id == passengerId) {
          await passengerBox.deleteAt(i);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

// ==================== Payment Repository Impl ====================
class HivePaymentRepository implements PaymentRepository {
  final Box<HivePayment> paymentBox;

  HivePaymentRepository(this.paymentBox);

  @override
  Future<Payment> processPayment({
    required String bookingId,
    required double amount,
    required String paymentMethod,
  }) async {
    final paymentId = 'PAY_${const Uuid().v4().substring(0, 8).toUpperCase()}';
    final payment = HivePayment(
      paymentId: paymentId,
      bookingId: bookingId,
      amount: amount,
      paymentMethod: paymentMethod,
      status: 'completed',
      createdAt: DateTime.now(),
      completedAt: DateTime.now(),
      transactionId: const Uuid().v4(),
    );

    await paymentBox.add(payment);
    return EntityMappers.hivePaymentToEntity(payment);
  }

  @override
  Future<Payment?> getPaymentByBookingId(String bookingId) async {
    try {
      for (var payment in paymentBox.values) {
        if (payment.bookingId == bookingId) {
          return EntityMappers.hivePaymentToEntity(payment);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Payment>> getUserPayments(String userId) async {
    // In real implementation, would filter by userId
    try {
      return paymentBox.values
          .map((p) => EntityMappers.hivePaymentToEntity(p))
          .toList();
    } catch (e) {
      return [];
    }
  }
}

// ==================== Offer Repository Impl ====================
class HiveOfferRepository implements OfferRepository {
  final Box<HiveOffer> offerBox;

  HiveOfferRepository(this.offerBox);

  @override
  Future<List<Offer>> getAllOffers() async {
    try {
      return offerBox.values
          .map((o) => EntityMappers.hiveOfferToEntity(o))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Offer?> getOfferById(String offerId) async {
    try {
      for (var offer in offerBox.values) {
        if (offer.offerId == offerId) {
          return EntityMappers.hiveOfferToEntity(offer);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> savOffer(Offer offer) async {
    try {
      final hiveOffer = EntityMappers.entityToHiveOffer(offer);
      await offerBox.add(hiveOffer);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Offer>> getActiveOffers() async {
    try {
      final now = DateTime.now();
      return offerBox.values
          .where((o) => o.isActive && o.validUntil.isAfter(now))
          .map((o) => EntityMappers.hiveOfferToEntity(o))
          .toList();
    } catch (e) {
      return [];
    }
  }
}

// ==================== Notification Repository Impl ====================
class HiveNotificationRepository implements NotificationRepository {
  final Box<HiveNotification> notificationBox;

  HiveNotificationRepository(this.notificationBox);

  @override
  Future<bool> addNotification(Notification notification) async {
    try {
      final hiveNotification = EntityMappers.entityToHiveNotification(notification);
      await notificationBox.add(hiveNotification);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Notification>> getUserNotifications(String userId) async {
    try {
      final notifications = <Notification>[];
      for (var notif in notificationBox.values) {
        if (notif.userId == userId) {
          notifications.add(EntityMappers.hiveNotificationToEntity(notif));
        }
      }
      return notifications;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> markAsRead(String notificationId) async {
    try {
      for (int i = 0; i < notificationBox.length; i++) {
        if (notificationBox.getAt(i)?.id == notificationId) {
          final notif = notificationBox.getAt(i)!;
          notif.isRead = true;
          await notificationBox.putAt(i, notif);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteNotification(String notificationId) async {
    try {
      for (int i = 0; i < notificationBox.length; i++) {
        if (notificationBox.getAt(i)?.id == notificationId) {
          await notificationBox.deleteAt(i);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    try {
      return notificationBox.values
          .where((n) => n.userId == userId && !n.isRead)
          .length;
    } catch (e) {
      return 0;
    }
  }
}

// ==================== SearchHistory Repository Impl ====================
class HiveSearchHistoryRepository implements SearchHistoryRepository {
  final Box<HiveSearchHistory> searchBox;

  HiveSearchHistoryRepository(this.searchBox);

  @override
  Future<bool> saveSearchHistory(SearchHistory history) async {
    try {
      final hiveHistory = EntityMappers.entityToHiveSearchHistory(history);
      await searchBox.add(hiveHistory);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<SearchHistory>> getUserSearchHistory(String userId) async {
    try {
      // In real implementation, would filter by userId
      return searchBox.values
          .map((s) => EntityMappers.hiveSearchHistoryToEntity(s))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> clearSearchHistory(String userId) async {
    try {
      await searchBox.clear();
      return true;
    } catch (e) {
      return false;
    }
  }
}

// ==================== Seat Repository Impl ====================
class HiveSeatRepository implements SeatRepository {
  final Box<HiveSeat> seatBox;

  HiveSeatRepository(this.seatBox);

  @override
  Future<List<Seat>> getFlightSeats(String flightId, String seatClass) async {
    try {
      return seatBox.values
          .where((s) => s.seatClass == seatClass)
          .map((s) => EntityMappers.hiveSeatToEntity(s))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> updateSeatAvailability(
      String flightId, String seatNumber, bool isAvailable) async {
    try {
      for (int i = 0; i < seatBox.length; i++) {
        if (seatBox.getAt(i)?.seatNumber == seatNumber) {
          final seat = seatBox.getAt(i)!;
          seat.isAvailable = isAvailable;
          await seatBox.putAt(i, seat);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> selectSeat(
      String flightId, String seatNumber, String passengerId) async {
    try {
      for (int i = 0; i < seatBox.length; i++) {
        if (seatBox.getAt(i)?.seatNumber == seatNumber) {
          final seat = seatBox.getAt(i)!;
          seat.isSelected = true;
          seat.passengerId = passengerId;
          await seatBox.putAt(i, seat);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
