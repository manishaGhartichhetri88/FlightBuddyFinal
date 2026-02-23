// Import actual screens from feature folders
import 'package:flightbuddy/features/home/presentation/dashboard_screen.dart';
import 'package:flightbuddy/features/booking/booking_screen.dart';
import 'package:flightbuddy/features/offers/offer_screen.dart';
import 'package:flightbuddy/features/inbox/inbox_screen.dart';
import 'package:flightbuddy/features/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flightbuddy/core/models/hive_models.dart';

// Initialize sample flights in Hive database
Future<void> _initializeSampleFlights(Box<HiveFlight> flightBox) async {
  final sampleFlights = [
    HiveFlight(
      id: 'FLT001',
      airline: 'Nepal Air',
      flightNumber: 'NA101',
      fromCity: 'Nepal (NEP)',
      toCity: 'Bangalore (BLR)',
      departureTime: DateTime(2026, 2, 23, 8, 30),
      arrivalTime: DateTime(2026, 2, 23, 10, 30),
      duration: '2h 0m',
      priceEconomy: 1700,
      priceBusiness: 3500,
      availableSeatsEconomy: 50,
      availableSeatsBusiness: 20,
      aircraftType: 'Boeing 737',
      isReturn: false,
      returnDate: null,
      stops: '0',
    ),
    HiveFlight(
      id: 'FLT002',
      airline: 'Royal Nepal Airlines',
      flightNumber: 'RA202',
      fromCity: 'Nepal (NEP)',
      toCity: 'Bangalore (BLR)',
      departureTime: DateTime(2026, 2, 23, 11, 15),
      arrivalTime: DateTime(2026, 2, 23, 13, 15),
      duration: '2h 0m',
      priceEconomy: 1800,
      priceBusiness: 3800,
      availableSeatsEconomy: 45,
      availableSeatsBusiness: 18,
      aircraftType: 'Airbus A320',
      isReturn: false,
      returnDate: null,
      stops: '0',
    ),
    HiveFlight(
      id: 'FLT003',
      airline: 'Buddha Air',
      flightNumber: 'BA303',
      fromCity: 'Nepal (NEP)',
      toCity: 'Bangalore (BLR)',
      departureTime: DateTime(2026, 2, 23, 14, 45),
      arrivalTime: DateTime(2026, 2, 23, 16, 45),
      duration: '2h 0m',
      priceEconomy: 1600,
      priceBusiness: 3200,
      availableSeatsEconomy: 60,
      availableSeatsBusiness: 25,
      aircraftType: 'Boeing 737',
      isReturn: false,
      returnDate: null,
      stops: '0',
    ),
    HiveFlight(
      id: 'FLT004',
      airline: 'Nepal Air',
      flightNumber: 'NA104',
      fromCity: 'Nepal (NEP)',
      toCity: 'Bangalore (BLR)',
      departureTime: DateTime(2026, 2, 23, 18, 30),
      arrivalTime: DateTime(2026, 2, 23, 20, 30),
      duration: '2h 0m',
      priceEconomy: 1900,
      priceBusiness: 4000,
      availableSeatsEconomy: 40,
      availableSeatsBusiness: 15,
      aircraftType: 'Airbus A320',
      isReturn: false,
      returnDate: null,
      stops: '0',
    ),
  ];

  await flightBox.addAll(sampleFlights);
}

void main() async {
  // Initialize Hive for local database
  await Hive.initFlutter();
  
  // Register Hive adapters for all models
  Hive.registerAdapter(HiveUserAdapter());
  Hive.registerAdapter(HiveFlightAdapter());
  Hive.registerAdapter(HiveSeatAdapter());
  Hive.registerAdapter(HiveBookingAdapter());
  Hive.registerAdapter(HivePassengerAdapter());
  Hive.registerAdapter(HiveSearchHistoryAdapter());
  Hive.registerAdapter(HivePaymentAdapter());
  Hive.registerAdapter(HiveOfferAdapter());
  Hive.registerAdapter(HiveNotificationAdapter());
  
  // Open all required boxes
  await Future.wait([
    Hive.openBox<HiveUser>('users'),
    Hive.openBox<HiveFlight>('flights'),
    Hive.openBox<HiveSeat>('seats'),
    Hive.openBox<HiveBooking>('bookings'),
    Hive.openBox<HivePassenger>('passengers'),
    Hive.openBox<HiveSearchHistory>('search_history'),
    Hive.openBox<HivePayment>('payments'),
    Hive.openBox<HiveOffer>('offers'),
    Hive.openBox<HiveNotification>('notifications'),
  ]);

  // Add sample flights to database if empty
  final flightBox = Hive.box<HiveFlight>('flights');
  if (flightBox.isEmpty) {
    await _initializeSampleFlights(flightBox);
  }
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlightBuddy',
      theme: ThemeData(
        primaryColor: const Color(0xFF1565C0),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: const Color(0xFF1565C0)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1565C0),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const BottomNavScreen(),
    );
  }
}

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;
  final Color primary = const Color(0xFF1565C0);

  // All screens only defined once here
  final List<Widget> _screens = const [
    DashboardScreen(),
    BookingScreen(),
    OfferScreen(),
    InboxScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_num),
            label: "Booking",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: "Offer",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: "Inbox",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}