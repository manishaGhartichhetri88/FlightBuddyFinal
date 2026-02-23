// Riverpod Providers for State Management

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import 'package:flightbuddy/core/models/entities.dart';
import 'package:flightbuddy/core/models/hive_models.dart';
import 'package:flightbuddy/core/models/mappers.dart';
import 'package:flightbuddy/core/repositories/implementations.dart';
import 'package:flightbuddy/core/repositories/repositories.dart';

// ==================== Hive Boxes Providers ====================
final userBoxProvider = Provider<Box<HiveUser>>((ref) {
  return Hive.box<HiveUser>('users');
});

final flightBoxProvider = Provider<Box<HiveFlight>>((ref) {
  return Hive.box<HiveFlight>('flights');
});

final bookingBoxProvider = Provider<Box<HiveBooking>>((ref) {
  return Hive.box<HiveBooking>('bookings');
});

final passengerBoxProvider = Provider<Box<HivePassenger>>((ref) {
  return Hive.box<HivePassenger>('passengers');
});

final paymentBoxProvider = Provider<Box<HivePayment>>((ref) {
  return Hive.box<HivePayment>('payments');
});

final offerBoxProvider = Provider<Box<HiveOffer>>((ref) {
  return Hive.box<HiveOffer>('offers');
});

final notificationBoxProvider = Provider<Box<HiveNotification>>((ref) {
  return Hive.box<HiveNotification>('notifications');
});

final searchHistoryBoxProvider = Provider<Box<HiveSearchHistory>>((ref) {
  return Hive.box<HiveSearchHistory>('search_history');
});

final seatBoxProvider = Provider<Box<HiveSeat>>((ref) {
  return Hive.box<HiveSeat>('seats');
});

// ==================== Repository Providers ====================
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final userBox = ref.watch(userBoxProvider);
  return HiveAuthRepository(userBox);
});

final flightRepositoryProvider = Provider<FlightRepository>((ref) {
  final flightBox = ref.watch(flightBoxProvider);
  return HiveFlightRepository(flightBox);
});

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final bookingBox = ref.watch(bookingBoxProvider);
  return HiveBookingRepository(bookingBox);
});

final passengerRepositoryProvider = Provider<PassengerRepository>((ref) {
  final passengerBox = ref.watch(passengerBoxProvider);
  return HivePassengerRepository(passengerBox);
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final paymentBox = ref.watch(paymentBoxProvider);
  return HivePaymentRepository(paymentBox);
});

final offerRepositoryProvider = Provider<OfferRepository>((ref) {
  final offerBox = ref.watch(offerBoxProvider);
  return HiveOfferRepository(offerBox);
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final notificationBox = ref.watch(notificationBoxProvider);
  return HiveNotificationRepository(notificationBox);
});

final searchHistoryRepositoryProvider = Provider<SearchHistoryRepository>((ref) {
  final searchBox = ref.watch(searchHistoryBoxProvider);
  return HiveSearchHistoryRepository(searchBox);
});

final seatRepositoryProvider = Provider<SeatRepository>((ref) {
  final seatBox = ref.watch(seatBoxProvider);
  return HiveSeatRepository(seatBox);
});

// ==================== Auth State Providers ====================
final currentUserProvider = FutureProvider<User?>((ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.getCurrentUser();
});

final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.isLoggedIn();
});

// ==================== Flight State Providers ====================
final allFlightsProvider = FutureProvider<List<Flight>>((ref) async {
  try {
    final flightBox = Hive.box<HiveFlight>('flights');
    final flights = <Flight>[];
    for (var flight in flightBox.values) {
      flights.add(EntityMappers.hiveFlightToEntity(flight));
    }
    return flights;
  } catch (e) {
    return [];
  }
});

final searchFlightsProvider =
    FutureProvider.family<List<Flight>, Map<String, dynamic>>((ref, params) async {
  try {
    final flightBox = Hive.box<HiveFlight>('flights');
    // Debug logging to help diagnose loading issues
    debugPrint('searchFlightsProvider called with params: $params');
    debugPrint('Flight box opened: ${flightBox.isOpen}, count: ${flightBox.length}');

    final fromCity = params['fromCity'] as String;
    final toCity = params['toCity'] as String;
    final departureDate = params['departureDate'] as DateTime;

    final flights = <Flight>[];
    for (var flight in flightBox.values) {
      try {
        debugPrint('Examining flight: ${flight.id} ${flight.fromCity} -> ${flight.toCity} @ ${flight.departureTime}');
      } catch (_) {}

      if (flight.fromCity.toLowerCase() == fromCity.toLowerCase() &&
          flight.toCity.toLowerCase() == toCity.toLowerCase() &&
          flight.departureTime.year == departureDate.year &&
          flight.departureTime.month == departureDate.month &&
          flight.departureTime.day == departureDate.day) {
        flights.add(EntityMappers.hiveFlightToEntity(flight));
      }
    }

    debugPrint('searchFlightsProvider returning ${flights.length} flights');
    return flights;
  } catch (e) {
    debugPrint('Error searching flights: $e');
    return [];
  }
});

final selectedFlightProvider = StateProvider<Flight?>((ref) => null);

// ==================== Booking State Providers ====================
final selectedSeatsProvider = StateProvider<List<String>>((ref) => []);

final selectedClassProvider = StateProvider<String>((ref) => 'Economy');

final passengersProvider = StateProvider<List<Passenger>>((ref) => []);

final userBookingsProvider = FutureProvider.family<List<Booking>, String>((ref, userId) async {
  final bookingRepo = ref.watch(bookingRepositoryProvider);
  return bookingRepo.getUserBookings(userId);
});

final bookingDetailsProvider = StateProvider<Booking?>((ref) => null);

// ==================== Seat State Providers ====================
final flightSeatsProvider =
    FutureProvider.family<List<Seat>, Map<String, String>>((ref, params) async {
  final seatRepo = ref.watch(seatRepositoryProvider);
  return seatRepo.getFlightSeats(params['flightId']!, params['seatClass']!);
});

// ==================== Payment State Providers ====================
final paymentMethodProvider = StateProvider<String>((ref) => 'card');

final totalPriceProvider = StateProvider<double>((ref) => 0.0);

// ==================== Offer State Providers ====================
final activeOffersProvider = FutureProvider<List<Offer>>((ref) async {
  final offerRepo = ref.watch(offerRepositoryProvider);
  return offerRepo.getActiveOffers();
});

final allOffersProvider = FutureProvider<List<Offer>>((ref) async {
  final offerRepo = ref.watch(offerRepositoryProvider);
  return offerRepo.getAllOffers();
});

// ==================== Notification State Providers ====================
final userNotificationsProvider =
    FutureProvider.family<List<Notification>, String>((ref, userId) async {
  final notifRepo = ref.watch(notificationRepositoryProvider);
  return notifRepo.getUserNotifications(userId);
});

final unreadNotificationsProvider =
    FutureProvider.family<int, String>((ref, userId) async {
  final notifRepo = ref.watch(notificationRepositoryProvider);
  return notifRepo.getUnreadCount(userId);
});

// ==================== Search History State Providers ====================
final searchHistoryProvider =
    FutureProvider.family<List<SearchHistory>, String>((ref, userId) async {
  final searchRepo = ref.watch(searchHistoryRepositoryProvider);
  return searchRepo.getUserSearchHistory(userId);
});

// ==================== Combined/Computed Providers ====================
final bookingTotalProvider = StateProvider<double>((ref) {
  final selectedSeats = ref.watch(selectedSeatsProvider);
  final selectedClass = ref.watch(selectedClassProvider);
  final selectedFlight = ref.watch(selectedFlightProvider);

  if (selectedFlight == null) return 0.0;

  double pricePerSeat = selectedClass == 'Economy'
      ? selectedFlight.priceEconomy
      : selectedFlight.priceBusiness;

  return pricePerSeat * selectedSeats.length;
});

// ==================== Loading States ====================
final loginLoadingProvider = StateProvider<bool>((ref) => false);

final searchLoadingProvider = StateProvider<bool>((ref) => false);

final bookingLoadingProvider = StateProvider<bool>((ref) => false);

final paymentLoadingProvider = StateProvider<bool>((ref) => false);

// ==================== Error States ====================
final errorMessageProvider = StateProvider<String?>((ref) => null);

