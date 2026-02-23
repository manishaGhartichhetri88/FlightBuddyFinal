import 'package:flightbuddy/features/auth/presentation/pages/login_screen.dart';
import 'package:flightbuddy/features/auth/presentation/pages/signup_screen.dart';
import 'package:flightbuddy/features/flights/flight_list_screen.dart';
import 'package:flightbuddy/features/flights/seat_selection_screen.dart';
import 'package:flightbuddy/features/flights/passenger_details_screen.dart';
import 'package:flightbuddy/features/flights/payment_screen.dart';
import 'package:flightbuddy/features/flights/review_payment_screen.dart';
import 'package:flightbuddy/features/flights/booking_confirmation_screen.dart';
import 'package:flightbuddy/features/home/presentation/dashboard_screen.dart';
import 'package:flightbuddy/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:flightbuddy/features/splash/presentation/pages/splash_screen.dart';
import 'package:flightbuddy/main.dart';
import 'package:flightbuddy/theme/theme_data.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flight Buddy',
      theme: getApplicationTheme(),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/dashboard': (context) => const DashboardScreen(),
        "/bottom_navigation": (context) => const BottomNavScreen(),
        '/flight_search_results': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map? ?? {};
          return FlightSearchResultsScreen(
            from: args['fromCity'] ?? args['from'] ?? '',
            to: args['toCity'] ?? args['to'] ?? '',
            departureDate: args['departureDate'] ?? args['travelDate'] ?? DateTime.now(),
            passengers: args['passengers'] ?? 1,
            travelClass: args['travelClass'] ?? 'Economy',
          );
        },
        '/seat_selection': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map;
          return SeatSelectionScreen(
            flight: args['flight'],
            travelClass: args['travelClass'],
            passengers: args['passengers'],
          );
        },
        '/passenger_details': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map;
          return PassengerDetailsScreen(
            flight: args['flight'],
            selectedSeats: args['selectedSeats'],
            travelClass: args['travelClass'],
            totalPrice: args['totalPrice'],
          );
        },
        '/payment': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map;
          List? passengersList = args['passengers'];
          String userName;
          String userEmail;
          String userPhone;
          String? passport;
          String? dob;
          String? nationality;
          if (passengersList != null && passengersList.isNotEmpty) {
            final p = passengersList.first;
            userName = '${p.firstName} ${p.lastName}';
            userEmail = p.email;
            userPhone = p.phone;
            passport = p.passportNumber;
            dob = p.dateOfBirth.toString().split('T').first;
            nationality = p.nationality;
          } else {
            userName = args['userName'] ?? '';
            userEmail = args['userEmail'] ?? '';
            userPhone = args['userPhone'] ?? '';
            passport = args['passport'];
            dob = args['dob'];
            nationality = args['nationality'];
          }
          return PaymentScreen(
            flight: args['flight'],
            selectedSeats: args['selectedSeats'],
            travelClass: args['travelClass'],
            totalPrice: args['totalPrice'],
            userName: userName,
            userEmail: userEmail,
            userPhone: userPhone,
            passport: passport,
            dob: dob,
            nationality: nationality,
          );
        },

        '/review_payment': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map;
          return ReviewPaymentScreen(
            flight: args['flight'],
            selectedSeats: args['selectedSeats'],
            travelClass: args['travelClass'],
            totalPrice: args['totalPrice'],
            userName: args['userName'],
            userEmail: args['userEmail'],
            userPhone: args['userPhone'],
            passport: args['passport'],
            dob: args['dob'],
            nationality: args['nationality'],
            paymentMethod: args['paymentMethod'],
            paymentDetails: args['paymentDetails'],
          );
        },
        '/booking_confirmation': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map;
          return BookingConfirmationScreen(
            flight: args['flight'],
            selectedSeats: args['selectedSeats'],
            travelClass: args['travelClass'],
            totalPrice: args['totalPrice'],
            userName: args['userName'],
            userEmail: args['userEmail'],
            userPhone: args['userPhone'],
            passport: args['passport'],
            dob: args['dob'],
            nationality: args['nationality'],
            bookingId: args['bookingId'],
            paymentMethod: args['paymentMethod'],
            paymentDetails: args['paymentDetails'],
          );
        },

      },
    );
  }
}
