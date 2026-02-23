# Quick Start Guide - Using New Clean Architecture

## What Has Been Implemented

Your Flight Booking app now has a **complete Clean Architecture** with:

✅ **Hive Database** - Local data persistence  
✅ **Riverpod State Management** - Reactive UI  
✅ **Repository Pattern** - Clean data access layer  
✅ **Domain Entities** - Business logic layer  
✅ **Use Cases** - Organized business operations  
✅ **Example Screens** - Login, Search, Selection, Seats  

---

## File Structure Overview

```
lib/
├── core/
│   ├── models/
│   │   ├── entities.dart (Domain objects - no framework dependency)
│   │   ├── hive_models.dart (Hive database models with @HiveType)
│   │   └── mappers.dart (Convert between Hive ↔ Domain)
│   ├── repositories/
│   │   ├── repositories.dart (Abstract interfaces)
│   │   └── implementations.dart (Hive implementations)
│   ├── usecases/
│   │   └── usecases.dart (Business logic operations)
│   ├── providers/
│   │   └── providers.dart (Riverpod state management)
│   └── ... (other core files)
├── features/
│   ├── auth/presentation/
│   │   └── login_screen_clean.dart (✨ NEW - Login with Riverpod)
│   ├── flight_search/presentation/
│   │   └── flight_search_screen_clean.dart (✨ NEW - Search with Riverpod)
│   ├── flights/presentation/
│   │   ├── flight_selection_screen_clean.dart (✨ NEW - Results)
│   │   └── seat_selection_screen_clean.dart (✨ NEW - Seats)
│   └── ... (other features)
└── main.dart (✨ UPDATED - Hive + Riverpod setup)
```

---

## Updates Made to main.dart

```dart
// BEFORE
void main() {
  runApp(const MyApp());
}

// AFTER
void main() async {
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register adapters
  Hive.registerAdapter(HiveUserAdapter());
  Hive.registerAdapter(HiveFlightAdapter());
  // ... (all other adapters)
  
  // Open boxes
  await Future.wait([
    Hive.openBox<HiveUser>('users'),
    Hive.openBox<HiveFlight>('flights'),
    // ... (all boxes)
  ]);
  
  // Wrap with ProviderScope
  runApp(const ProviderScope(child: MyApp()));
}
```

---

## How to Use New Screens

### 1️⃣ **Login Screen** (`login_screen_clean.dart`)
Clean implementation with Riverpod state management.

**Features:**
- Login & Register modes
- Email/Password validation
- Loading state handling
- Error dialogs
- Social login buttons (UI only)

**Usage:**
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const LoginScreenClean()),
);
```

**Key Code:**
```dart
// Access auth repository
final authRepo = ref.read(authRepositoryProvider);
final user = await authRepo.login(email, password);

// Track loading state
ref.read(loginLoadingProvider.notifier).state = true;
```

---

### 2️⃣ **Flight Search Screen** (`flight_search_screen_clean.dart`)
Search flights with date/passenger selection.

**Features:**
- One Way / Round Trip toggle
- Date picker integration
- Passenger count selector
- Search history preparation
- Loading state

**Usage:**
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const FlightSearchScreenClean()),
);
```

**Key Code:**
```dart
// Trigger search with parameters
final searchParams = {
  'fromCity': 'NYC',
  'toCity': 'LAX',
  'departureDate': DateTime.now(),
  'passengers': 1,
};
ref.refresh(searchFlightsProvider(searchParams));
```

---

### 3️⃣ **Flight Selection Screen** (`flight_selection_screen_clean.dart`)
Display search results and select a flight.

**Features:**
- Display flight list
- Show pricing per person
- Seat availability
- Flight details (airline, duration, stops)
- Select flight action

**Usage:**
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => FlightSelectionScreenClean(
      fromCity: 'NYC',
      toCity: 'LAX',
      departureDate: DateTime.now(),
      passengers: 1,
    ),
  ),
);
```

**Key Code:**
```dart
// Watch search results
final flightsAsync = ref.watch(searchFlightsProvider(searchParams));

// Select a flight
ref.read(selectedFlightProvider.notifier).state = flight;

// Computed price
final totalPrice = ref.watch(bookingTotalProvider);
```

---

### 4️⃣ **Seat Selection Screen** (`seat_selection_screen_clean.dart`)
Select flight seats and travel class.

**Features:**
- Economy/Business class toggle
- Interactive seat grid
- Visual seat states (available, selected, booked)
- Seat count validation
- Price calculation
- Continue button

**Usage:**
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => SeatSelectionScreenClean(
      flight: selectedFlight,
      passengers: 1,
    ),
  ),
);
```

**Key Code:**
```dart
// Track selected seats
final selectedSeats = ref.watch(selectedSeatsProvider);
ref.read(selectedSeatsProvider.notifier).state = [...seats, newSeat];

// Track travel class
final selectedClass = ref.watch(selectedClassProvider);
ref.read(selectedClassProvider.notifier).state = 'Business';

// Calculate total
double total = pricePerSeat * selectedSeats.length;
```

---

## Data Flow Explanation

### Example: Booking a Flight

```
1. User on Login Screen
   ↓
   Enters email/password → loginScreenClean.dart
   ↓
2. Triggers Login
   ↓
   authRepositoryProvider → HiveAuthRepository.login()
   ↓
   Stores user in Hive box → userBoxProvider
   ↓
3. Navigate to Search Screen
   ↓
   flightSearchScreenClean.dart collects search params
   ↓
4. User Searches Flights
   ↓
   searchFlightsProvider(params) → flightRepositoryProvider
   ↓
   HiveFlightRepository.searchFlights(...)
   ↓
   Returns matching flights from Hive box
   ↓
5. Display Results
   ↓
   flightSelectionScreenClean.dart shows results
   ↓
6. User Selects Flight
   ↓
   selectedFlightProvider updated
   ↓
7. User Selects Seats
   ↓
   selectedSeatsProvider updated
   ↓
8. Create Booking
   ↓
   bookingRepositoryProvider.createBooking(...) called
   ↓
   Saves to HiveBooking box
   ↓
9. Process Payment
   ↓
   paymentRepositoryProvider.processPayment(...)
   ↓
   Saves to HivePayment box
   ↓
10. Show Confirmation
```

---

## Adding New Screens

### Step 1: Use ConsumerWidget
```dart
class MyNewScreen extends ConsumerWidget {
  const MyNewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access providers via ref
    final data = ref.watch(myProvider);
    
    return Scaffold(...);
  }
}
```

### Step 2: Watch Providers
```dart
// Watch loading state
final isLoading = ref.watch(searchLoadingProvider);

// Watch data
final flights = ref.watch(allFlightsProvider);

// Watch computed state
final total = ref.watch(bookingTotalProvider);
```

### Step 3: Update State
```dart
// Update simple state
ref.read(selectedFlightProvider.notifier).state = flight;

// Call repositories for side effects
final repo = ref.read(bookingRepositoryProvider);
await repo.createBooking(...);
```

---

## Testing Data Locally

### Save Mock Flights to Hive (in main.dart after Hive setup)
```dart
// Generate mock data
final mockFlights = [
  HiveFlight(
    id: '1',
    airline: 'Air India',
    flightNumber: 'AI101',
    fromCity: 'NYC',
    toCity: 'LAX',
    departureTime: DateTime.now(),
    arrivalTime: DateTime.now().add(Duration(hours: 5)),
    duration: '5h',
    priceEconomy: 150.0,
    priceBusiness: 300.0,
    availableSeatsEconomy: 50,
    availableSeatsBusiness: 20,
    aircraftType: 'Boeing 777',
    isReturn: false,
    stops: 'Non-stop',
  ),
];

// Save to Hive
final flightBox = Hive.box<HiveFlight>('flights');
await flightBox.addAll(mockFlights);
```

---

## Key Concepts

### 🏗️ **Clean Architecture**
- **Domain** - Pure business logic (no dependencies)
- **Data** - Repositories & database access (Hive)
- **Presentation** - UI & state management (Riverpod)

### 📊 **State Management (Riverpod)**
- **Provider** - Immutable dependencies
- **StateProvider** - Mutable simple state
- **FutureProvider** - Async data with loading/error
- **Family** - Parameterized providers

### 💾 **Data Persistence (Hive)**
- **Box** - Collection of data
- **Adapter** - Serialization for custom types
- **typeId** - Unique identifier for each model

---

## Common Tasks

### Get Current User
```dart
final user = ref.watch(currentUserProvider);
```

### Search Flights
```dart
final searchParams = {'fromCity': 'NYC', 'toCity': 'LAX', ...};
final flights = ref.watch(searchFlightsProvider(searchParams));
```

### Create Booking
```dart
final booking = await ref.read(bookingRepositoryProvider).createBooking(
  userId: userId,
  flightId: flightId,
  selectedSeats: seats,
  travelClass: 'Economy',
  passengers: passengers,
  totalPrice: total,
);
```

### Get User Bookings
```dart
final bookings = ref.watch(userBookingsProvider(userId));
```

### Process Payment
```dart
final payment = await ref.read(paymentRepositoryProvider).processPayment(
  bookingId: booking.bookingId,
  amount: booking.totalPrice,
  paymentMethod: 'card',
);
```

---

## Next Steps

### ✅ Immediate Actions
1. Run `flutter pub get` to install dependencies
2. Generate Hive adapters: `flutter pub run build_runner build`
3. Test the new screens by creating navigation to them
4. Add mock data to Hive for testing

### 🔄 Continue Development
1. Connect to real API (replace mock data in repositories)
2. Implement remaining screens (payment, confirmation, etc.)
3. Add error handling and retry logic
4. Implement offline-first sync
5. Add notifications

### 📝 Documentation
- Refer to `CLEAN_ARCHITECTURE_GUIDE.md` for detailed doc
- Check each repository interface for methods
- Review use cases for business logic patterns

---

## Important Notes

1. **Always use repositories** - Don't access Hive directly in screens
2. **Use entities in UI** - Not Hive models
3. **Providers for all state** - No setState
4. **Async handling** - Use `.when()` for FutureProviders
5. **Error handling** - Implement error states in UI

---

## Troubleshooting

### "Build Runner" Error
```bash
flutter pub run build_runner build
```

### Hive Type Error
Check `main.dart` - all adapters must be registered before opening boxes

### Provider Not Updating
Use `notifier.state =` instead of `state =`

### UI Not Rebuilding
Ensure using `ConsumerWidget` and `ref.watch()` not `ref.read()`

---

## Support Resources

- 📘 [Riverpod Documentation](https://riverpod.dev)
- 📗 [Hive Documentation](https://docs.hivedb.dev)
- 📙 [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

**Happy Coding! 🚀**
