// lib/app/routes/app_routes.dart
import 'package:flightbuddy/features/flights/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flightbuddy/core/models/flight_model.dart';

class AppRoutes {
  static const String paymentRoute = '/payment';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ... existing cases ...

      case paymentRoute:
        // Extracting the arguments passed in the Navigator call
        final args = settings.arguments as Map<String, dynamic>;
        
        return MaterialPageRoute(
          builder: (context) => PaymentScreen(
            flight: args['flight'] as Flight,
            selectedSeats: List<String>.from(args['selectedSeats']),
            travelClass: args['travelClass'] as String,
            totalPrice: args['totalPrice'] as double,
            userName: args['userName'] as String,
            userEmail: args['userEmail'] as String,
            userPhone: args['userPhone'] as String,
            passport: args['passport'] as String?,
            dob: args['dob'] as String?,
            nationality: args['nationality'] as String?,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}