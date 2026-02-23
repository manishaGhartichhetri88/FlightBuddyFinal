# FlightBuddy Backend API Documentation
## Complete System Architecture & API Requirements

---

## 📋 Project Overview

**FlightBuddy** is a Flutter flight booking application built with:
- **Architecture:** Clean Architecture (Domain → Data → Presentation)
- **State Management:** Riverpod 3.0.3
- **Local Database:** Hive 2.2.3
- **Framework:** Flutter 3.13.0+, Dart 3.9.2

---

## 🏗️ System Architecture

### Layer Structure
```
Presentation Layer (UI)
    ↓ (consumes providers)
Riverpod Provider Layer (State Management)
    ↓ (calls use cases)
Domain Layer (Use Cases & Entities)
    ↓ (uses repositories)
Data Layer (Repositories & Hive Persistence)
    ↓ (calls API + local DB)
Backend API + Local Database
```

---

## 📱 Core Entities (Domain Models)

### 1. **User**
```dart
class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profilePicture;
  final DateTime createdAt;
  final bool emailVerified;
}
```

### 2. **Flight**
```dart
class Flight {
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
}
```

### 3. **Booking**
```dart
class Booking {
  final String bookingId;
  final String userId;
  final String flightId;
  final List<String> selectedSeats;
  final String travelClass;
  final List<Passenger> passengers;
  final double totalPrice;
  final String status; // confirmed, pending, cancelled
  final DateTime bookingDate;
  final bool isReturn;
  final String? returnFlightId;
  final List<String>? returnSeats;
}
```

### 4. **Passenger**
```dart
class Passenger {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String passportNumber;
  final String gender;
  final DateTime dateOfBirth;
}
```

### 5. **Payment**
```dart
class Payment {
  final String paymentId;
  final String bookingId;
  final double amount;
  final String paymentMethod; // card, upi, wallet
  final String status; // completed, pending, failed
  final DateTime createdAt;
  final DateTime? completedAt;
  final String transactionId;
}
```

### 6. **Seat**
```dart
class Seat {
  final String id;
  final String flightId;
  final String seatNumber;
  final String seatClass; // economy, business
  final String status; // available, booked, reserved
  final double price;
}
```

### 7. **Offer**
```dart
class Offer {
  final String offerId;
  final String title;
  final String description;
  final double discountPercentage;
  final DateTime validFrom;
  final DateTime validTo;
  final String code;
}
```

### 8. **Notification**
```dart
class Notification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type; // booking, payment, flight, offer
  final bool isRead;
  final DateTime createdAt;
}
```

### 9. **SearchHistory**
```dart
class SearchHistory {
  final String id;
  final String userId;
  final String fromCity;
  final String toCity;
  final DateTime searchDate;
}
```

---

## 🔌 Required API Endpoints

### **Authentication Endpoints**
```
POST /api/auth/register
- Body: { email, password, name, phone }
- Returns: { userId, token, user }

POST /api/auth/login
- Body: { email, password }
- Returns: { token, user, expiresIn }

POST /api/auth/logout
- Headers: { Authorization: Bearer token }
- Returns: { success }

POST /api/auth/refresh-token
- Body: { refreshToken }
- Returns: { token, expiresIn }
```

### **Flight Search Endpoints**
```
GET /api/flights/search
- Query: { fromCity, toCity, departureDate, returnDate?, passengers, travelClass }
- Returns: [ Flight[] ]

GET /api/flights/:flightId
- Returns: Flight

GET /api/flights/available-seats/:flightId
- Query: { seatClass }
- Returns: [ Seat[] ]
```

---

## 📝 Backend Implementation Summary
To support FlightBuddy the backend must provide basic user authentication, flight
catalog/search, seat availability, booking creation/update, and payment
recording.  Key flows are:

1. **User registration/login/logout** – issue JWT tokens and manage profiles.
2. **Flight searching** – receive search parameters and return matching
   flight objects; optionally include pricing per class and seat counts.
3. **Seat reservation** – query and lock seats for a flight/class when a user
   begins booking (optional), then mark seats booked on successful payment.
4. **Booking lifecycle** – create booking records linked to user, flights,
   passengers and seats; allow retrieval and cancellation.
5. **Passenger details** – store passenger demographic information required for
   airline compliance (name, passport, DOB, nationality, contact).
6. **Payment processing** – accept payment method (card, wallet, bank,
   eSewa/Khalti/QR), record transactions and update booking status.
7. **Offers & notifications** – optional endpoints for promotions and sending
   updates to users.
8. **Search history** – record user queries for analytics and quick access.

All data models are defined above; the backend should expose CRUD endpoints or
appropriate APIs for each and handle authorization using the user token.  The
mobile client handles routing and local state via Riverpod, so the backend can
be a simple RESTful service or GraphQL server depending on preference.

These summaries should guide developers implementing the server side.

GET /api/flights/all
- Returns: [ Flight[] ]
```

### **Booking Endpoints**
```
POST /api/bookings/create
- Body: { flightId, selectedSeats, travelClass, passengers[], totalPrice, returnFlightId?, returnSeats? }
- Headers: { Authorization: Bearer token }
- Returns: { bookingId, status, booking }

GET /api/bookings/:bookingId
- Returns: Booking

GET /api/bookings/user/:userId
- Headers: { Authorization: Bearer token }
- Returns: [ Booking[] ]

PUT /api/bookings/:bookingId
- Body: { status, passengers[] }
- Headers: { Authorization: Bearer token }
- Returns: Booking

DELETE /api/bookings/:bookingId
- Headers: { Authorization: Bearer token }
- Returns: { success }
```

### **Payment Endpoints**
```
POST /api/payments/process
- Body: { bookingId, amount, paymentMethod, cardDetails? }
- Headers: { Authorization: Bearer token }
- Returns: { paymentId, status, transactionId }

GET /api/payments/:paymentId
- Headers: { Authorization: Bearer token }
- Returns: Payment

GET /api/payments/booking/:bookingId
- Returns: Payment
```

### **User Profile Endpoints**
```
GET /api/users/:userId
- Headers: { Authorization: Bearer token }
- Returns: User

PUT /api/users/:userId
- Body: { name, phone, profilePicture?, email }
- Headers: { Authorization: Bearer token }
- Returns: User

POST /api/users/:userId/avatar
- Body: FormData (image file)
- Headers: { Authorization: Bearer token }
- Returns: { profilePicture: url }
```

### **Offers & Notifications Endpoints**
```
GET /api/offers
- Returns: [ Offer[] ]

GET /api/notifications/user/:userId
- Headers: { Authorization: Bearer token }
- Returns: [ Notification[] ]

PUT /api/notifications/:notificationId/read
- Headers: { Authorization: Bearer token }
- Returns: Notification
```

---

## 💾 Database Schema (SQL/NoSQL)

### **Users Table**
```sql
CREATE TABLE users (
  id VARCHAR(36) PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  profile_picture VARCHAR(500),
  email_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

### **Flights Table**
```sql
CREATE TABLE flights (
  id VARCHAR(36) PRIMARY KEY,
  airline VARCHAR(255) NOT NULL,
  flight_number VARCHAR(20) UNIQUE NOT NULL,
  from_city VARCHAR(100) NOT NULL,
  to_city VARCHAR(100) NOT NULL,
  departure_time TIMESTAMP NOT NULL,
  arrival_time TIMESTAMP NOT NULL,
  duration VARCHAR(50),
  price_economy DECIMAL(10, 2),
  price_business DECIMAL(10, 2),
  available_seats_economy INT,
  available_seats_business INT,
  aircraft_type VARCHAR(100),
  is_return BOOLEAN,
  return_date TIMESTAMP,
  stops INT,
  created_at TIMESTAMP
);
```

### **Bookings Table**
```sql
CREATE TABLE bookings (
  booking_id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) NOT NULL,
  flight_id VARCHAR(36) NOT NULL,
  selected_seats JSON,
  travel_class VARCHAR(50),
  total_price DECIMAL(10, 2),
  status VARCHAR(50),
  booking_date TIMESTAMP,
  is_return BOOLEAN,
  return_flight_id VARCHAR(36),
  return_seats JSON,
  created_at TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (flight_id) REFERENCES flights(id)
);
```

### **Passengers Table**
```sql
CREATE TABLE passengers (
  id VARCHAR(36) PRIMARY KEY,
  booking_id VARCHAR(36),
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  email VARCHAR(255),
  phone VARCHAR(20),
  passport_number VARCHAR(50),
  gender VARCHAR(10),
  date_of_birth DATE,
  created_at TIMESTAMP,
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);
```

### **Payments Table**
```sql
CREATE TABLE payments (
  payment_id VARCHAR(36) PRIMARY KEY,
  booking_id VARCHAR(36) NOT NULL,
  amount DECIMAL(10, 2),
  payment_method VARCHAR(50),
  status VARCHAR(50),
  transaction_id VARCHAR(100),
  created_at TIMESTAMP,
  completed_at TIMESTAMP,
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);
```

### **Seats Table**
```sql
CREATE TABLE seats (
  id VARCHAR(36) PRIMARY KEY,
  flight_id VARCHAR(36) NOT NULL,
  seat_number VARCHAR(10),
  seat_class VARCHAR(50),
  status VARCHAR(50),
  price DECIMAL(10, 2),
  FOREIGN KEY (flight_id) REFERENCES flights(id),
  UNIQUE(flight_id, seat_number)
);
```

### **Offers Table**
```sql
CREATE TABLE offers (
  offer_id VARCHAR(36) PRIMARY KEY,
  title VARCHAR(255),
  description TEXT,
  discount_percentage DECIMAL(5, 2),
  code VARCHAR(50) UNIQUE,
  valid_from TIMESTAMP,
  valid_to TIMESTAMP,
  created_at TIMESTAMP
);
```

### **Notifications Table**
```sql
CREATE TABLE notifications (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) NOT NULL,
  title VARCHAR(255),
  message TEXT,
  type VARCHAR(50),
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
```

### **Search History Table**
```sql
CREATE TABLE search_history (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) NOT NULL,
  from_city VARCHAR(100),
  to_city VARCHAR(100),
  search_date TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
```

---

## 🔐 Authentication & Security

### **JWT Token Structure**
```json
{
  "sub": "user_id",
  "email": "user@email.com",
  "iat": 1708689600,
  "exp": 1708776000
}
```

### **Security Requirements**
- All endpoints require `Authorization: Bearer {token}` header (except auth endpoints)
- Passwords must be hashed using bcrypt
- HTTPS/SSL required for all API calls
- Rate limiting: 100 requests/minute per IP
- CORS enabled for Flutter app domain

---

## 📊 Riverpod Providers (State Management)

### **Box Providers** (Hive Local Database)
```dart
final userBoxProvider = Provider<Box<HiveUser>>
final flightBoxProvider = Provider<Box<HiveFlight>>
final bookingBoxProvider = Provider<Box<HiveBooking>>
final passengerBoxProvider = Provider<Box<HivePassenger>>
final paymentBoxProvider = Provider<Box<HivePayment>>
final offerBoxProvider = Provider<Box<HiveOffer>>
final notificationBoxProvider = Provider<Box<HiveNotification>>
final searchHistoryBoxProvider = Provider<Box<HiveSearchHistory>>
final seatBoxProvider = Provider<Box<HiveSeat>>
```

### **Repository Providers**
```dart
final authRepositoryProvider = Provider<AuthRepository>
final flightRepositoryProvider = Provider<FlightRepository>
final bookingRepositoryProvider = Provider<BookingRepository>
final passengerRepositoryProvider = Provider<PassengerRepository>
final paymentRepositoryProvider = Provider<PaymentRepository>
final offerRepositoryProvider = Provider<OfferRepository>
final notificationRepositoryProvider = Provider<NotificationRepository>
final searchHistoryRepositoryProvider = Provider<SearchHistoryRepository>
final seatRepositoryProvider = Provider<SeatRepository>
```

### **Async Data Providers** (FutureProvider)
```dart
final allFlightsProvider = FutureProvider<List<Flight>>
final searchFlightsProvider = FutureProvider.family<List<Flight>, Map>
final userBookingsProvider = FutureProvider.family<List<Booking>, String>
final flightSeatsProvider = FutureProvider.family<List<Seat>, Map>
final userNotificationsProvider = FutureProvider.family<List<Notification>, String>
```

### **State Providers** (StateProvider)
```dart
final selectedFlightProvider = StateProvider<Flight?>
final selectedSeatsProvider = StateProvider<List<String>>
final selectedClassProvider = StateProvider<String>
final passengersProvider = StateProvider<List<Passenger>>
final paymentMethodProvider = StateProvider<String>
final totalPriceProvider = StateProvider<double>
```

---

## 📱 User Flows & Navigation

### **1. Authentication Flow**
```
Splash Screen
    ↓
Login/Register Screen
    ↓
Dashboard (Home Screen)
```

### **2. Flight Booking Flow**
```
Dashboard (Home)
    ↓ (SEARCH FLIGHTS)
Flight Search Results
    ↓ (Select Flight)
Flight Details
    ↓ (Continue)
Seat Selection
    ↓ (Continue)
Booking Details (Passenger Info)
    ↓ (Continue)
Payment Screen
    ↓ (Complete Payment)
Booking Confirmation
```

### **3. User Navigation Tabs**
```
Home     → Dashboard (search & quick bookings)
Booking  → View all bookings (upcoming & past)
Offer    → Special offers & discounts
Inbox    → Messages & notifications
Profile  → User profile & settings
```

---

## 🎯 Key Features Implemented

### ✅ **Completed**
- Clean Architecture structure
- Hive local database with 9 entities
- Riverpod state management (40+ providers)
- 4 sample flights pre-populated
- Flight search with filtering
- Seat selection (6x6 grid with class toggle)
- Booking flow with passenger details
- Payment processing screen
- Booking confirmation screen
- Dashboard with clean UI
- Bottom navigation (Home, Booking, Offer, Inbox, Profile)
- Booking screen (upcoming & past bookings)
- Offers screen with discount cards
- Inbox screen with messages
- Profile screen

### 🔄 **Next Steps for Backend**
1. Implement all API endpoints listed above
2. Set up database tables
3. Create authentication system (JWT)
4. Implement payment gateway integration
5. Set up notifications system
6. Create admin dashboard for flight management
7. Implement search history tracking
8. Add email verification
9. Create mobile push notifications

---

## 🔗 API Response Format

### **Success Response**
```json
{
  "success": true,
  "data": { ... },
  "message": "Operation successful"
}
```

### **Error Response**
```json
{
  "success": false,
  "error": "error_code",
  "message": "Error description",
  "statusCode": 400
}
```

---

## 📝 Sample API Calls

### **Search Flights**
```
GET /api/flights/search?fromCity=Nepal%20(NEP)&toCity=Bangalore%20(BLR)&departureDate=2026-02-23&passengers=1&travelClass=Economy

Response:
{
  "success": true,
  "data": [
    {
      "id": "FLT001",
      "airline": "Nepal Air",
      "flightNumber": "NA101",
      "fromCity": "Nepal (NEP)",
      "toCity": "Bangalore (BLR)",
      "departureTime": "2026-02-23T08:30:00Z",
      "arrivalTime": "2026-02-23T10:30:00Z",
      "duration": "2h 0m",
      "priceEconomy": 1700,
      "priceBusiness": 3500,
      "availableSeatsEconomy": 50,
      "availableSeatsBusiness": 20,
      "aircraftType": "Boeing 737"
    }
  ]
}
```

### **Create Booking**
```
POST /api/bookings/create

Body:
{
  "flightId": "FLT001",
  "selectedSeats": ["A1", "A2"],
  "travelClass": "Economy",
  "passengers": [
    {
      "firstName": "John",
      "lastName": "Doe",
      "email": "john@example.com",
      "phone": "+977123456789",
      "passportNumber": "AB1234567",
      "gender": "Male",
      "dateOfBirth": "1990-01-01"
    }
  ],
  "totalPrice": 3400
}

Response:
{
  "success": true,
  "data": {
    "bookingId": "BK_A1B2C3D4",
    "status": "confirmed",
    "booking": { ... }
  }
}
```

---

## 🛠️ Technologies Stack

### **Frontend (Flutter)**
- Flutter 3.13.0+
- Dart 3.9.2
- flutter_riverpod 3.0.3
- hive_flutter 2.2.3
- intl (date formatting)
- uuid (unique IDs)

### **Backend (Recommended)**
- Node.js + Express / Python + Django / Java + Spring Boot
- PostgreSQL / MySQL / MongoDB
- JWT for authentication
- Payment gateway (Stripe/PayPal)
- Push notification service (Firebase Cloud Messaging)

---

## 📞 Contact & Support

For backend implementation guidance, refer to this document and ensure all API endpoints match the entity structures and data flows defined here.

