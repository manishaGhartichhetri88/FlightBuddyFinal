# Flight Buddy - Clean Architecture Implementation

## Overview
This document explains the **Clean Architecture** setup implemented in Flight Buddy using **Riverpod** for state management and **Hive** for local data persistence.

## Architecture Layers

### 1. **Domain Layer** (Business Logic - Framework Independent)
Located in: `/core/models/` and `/core/usecases/`

#### Entities
- **Pure Dart classes** - No framework dependencies
- Represent core business objects
- Include `copyWith()` for immutability

Files:
- `entities.dart` - Contains: User, Flight, Booking, Passenger, Payment, Offer, Notification, SearchHistory, Seat

#### Use Cases
- **Business logic operations**
- Bridge between repositories and presentation
- Single responsibility principle

Files:
- `usecases.dart` - Auth, Flight, Booking, Payment, Seat operations

#### Repositories (Interfaces)
- **Abstract interfaces** - Define contracts
- No implementation details

Files:
- `core/repositories/repositories.dart` - All repository interfaces

---

### 2. **Data Layer** (Data Access & Storage)
Located in: `/core/repositories/` and `/core/models/`

#### Hive Models
- **@HiveType decorated classes** - For Hive database
- Mirrored structure to domain entities
- Include typeId for versioning

Files:
- `hive_models.dart` - Contains: HiveUser, HiveFlight, HiveBooking, etc.

#### Repository Implementations
- **Concrete implementations** - Use Hive for persistence
- Convert between Hive and Domain entities

Files:
- `implementations.dart` - All Hive-based repository implementations

#### Mappers
- **Entity conversion layer**
- Clean separation between Hive and Domain

Files:
- `mappers.dart` - Convert between Hive models and entities

---

### 3. **Presentation Layer** (UI & State Management)
Located in: `/features/` and `/core/providers/`

#### Riverpod Providers
- **State management** - All app state in one place
- **Reactive** - UI automatically rebuilds on state changes
- **Dependency injection** - Clean dependency management

Files:
- `core/providers/providers.dart` - All providers

Provider Types:
```
1. Box Providers - Access to Hive boxes
2. Repository Providers - Access to repositories
3. State Providers - StateProvider for mutable state
4. Future Providers - FutureProvider for async data
5. Computed Providers - Derived state
```

#### UI Screens - ConsumerWidget Pattern
- Use `ConsumerStatefulWidget` for stateful screens
- Use `ConsumerWidget` for stateless screens
- Access providers via `ref` parameter

---

## Key Files Structure

```
lib/
├── core/
│   ├── models/
│   │   ├── hive_models.dart      # @HiveType models
│   │   ├── entities.dart          # Domain entities
│   │   └── mappers.dart           # Entity <-> Hive conversion
│   ├── repositories/
│   │   ├── repositories.dart      # Interfaces
│   │   └── implementations.dart   # Hive implementations
│   ├── usecases/
│   │   └── usecases.dart          # Business logic
│   ├── providers/
│   │   └── providers.dart         # Riverpod state management
│   ├── constants/
│   ├── error/
│   ├── extensions/
│   ├── services/
│   └── utils/
├── features/
│   ├── auth/
│   │   └── presentation/
│   │       └── login_screen_clean.dart
│   ├── flight_search/
│   │   └── presentation/
│   │       └── flight_search_screen_clean.dart
│   ├── flights/
│   │   └── presentation/
│   │       ├── flight_selection_screen_clean.dart
│   │       └── seat_selection_screen_clean.dart
│   └── ... (other features)
└── main.dart
```

---

## Data Flow

```
UI Screen (ConsumerWidget)
    ↓
ref.watch/read Providers
    ↓
Use Cases (Business Logic)
    ↓
Repositories (Data Access)
    ↓
Hive Box (Local Storage)
```

---

## How to Use

### 1. **Creating a New Entity**

```dart
// 1. Create Hive Model
@HiveType(typeId: 9)
class HiveMyModel extends HiveObject {
  @HiveField(0)
  String id;
  // Add more fields...
}

// 2. Create Domain Entity
class MyModel extends Equatable {
  final String id;
  // Add more fields...
}

// 3. Add to Mappers
static MyModel hiveToEntity(HiveMyModel hive) {
  return MyModel(id: hive.id);
}

// 4. Create Repository Interface
abstract class MyModelRepository {
  Future<MyModel?> getById(String id);
  // Add more methods...
}

// 5. Implement Repository
class HiveMyModelRepository implements MyModelRepository {
  // Implementation using Hive
}
```

### 2. **Creating a New Screen with Riverpod**

```dart
class MyScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  @override
  Widget build(BuildContext context) {
    // Watch providers
    final data = ref.watch(myDataProvider);
    
    return Scaffold(
      body: data.when(
        data: (items) => ListView(children: items),
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
      ),
    );
  }
}
```

### 3. **Using State Providers for User Input**

```dart
// Search flights
final searchParams = {
  'fromCity': 'NYC',
  'toCity': 'LAX',
  'departureDate': DateTime.now(),
};

// Trigger search
final flights = ref.watch(searchFlightsProvider(searchParams));

// Update UI state
ref.read(selectedFlightProvider.notifier).state = flight;
```

### 4. **Handling Mutations**

```dart
// Creating a booking
final booking = await ref.read(bookingRepositoryProvider).createBooking(
  userId: userId,
  flightId: flightId,
  selectedSeats: seats,
  travelClass: 'Economy',
  passengers: passengers,
  totalPrice: price,
);
```

---

## Hive Boxes Reference

```dart
// Open in main.dart
await Hive.openBox<HiveUser>('users');
await Hive.openBox<HiveFlight>('flights');
await Hive.openBox<HiveBooking>('bookings');
await Hive.openBox<HivePassenger>('passengers');
await Hive.openBox<HivePayment>('payments');
await Hive.openBox<HiveOffer>('offers');
await Hive.openBox<HiveNotification>('notifications');
await Hive.openBox<HiveSearchHistory>('search_history');
await Hive.openBox<HiveSeat>('seats');
```

---

## Riverpod Providers Reference

### Authentication
```dart
final currentUserProvider          // Get logged-in user
final isLoggedInProvider           // Check if authenticated
```

### Flights
```dart
final allFlightsProvider           // Get all cached flights
final searchFlightsProvider        // Search flights (family)
final selectedFlightProvider       // Track selected flight
```

### Bookings
```dart
final userBookingsProvider         // Get user's bookings (family)
final bookingDetailsProvider       // Track current booking
final selectedSeatsProvider        // Track selected seats
```

### Payments
```dart
final paymentMethodProvider        // Track payment method
final totalPriceProvider           // Track total price
```

### Notifications
```dart
final userNotificationsProvider    // Get notifications (family)
final unreadNotificationsProvider  // Get unread count (family)
```

---

## State Management Best Practices

### ✅ DO
- Use `ConsumerWidget` / `ConsumerStatefulWidget`
- Use `.when()` for handling async
- Update state via `notifier.state =`
- Use Providers for all shared state
- Keep business logic in Use Cases

### ❌ DON'T
- Don't pass context down multiple levels
- Don't use setState in ConsumerState
- Don't mix Hive and domain entities
- Don't create repositories in UI
- Don't handle Hive directly in screens

---

## Example: Complete Booking Flow

### 1. **Search Screen** (Collect Input)
```dart
final searchParams = {
  'fromCity': fromCity,
  'toCity': toCity,
  'departureDate': date,
  'passengers': passengers,
};
ref.refresh(searchFlightsProvider(searchParams));
```

### 2. **Results Screen** (Display & Select)
```dart
final flights = ref.watch(searchFlightsProvider(searchParams));
ref.read(selectedFlightProvider.notifier).state = flight;
```

### 3. **Seats Screen** (Select Seats)
```dart
ref.read(selectedSeatsProvider.notifier).state = [...seats, newSeat];
```

### 4. **Booking Screen** (Create Booking)
```dart
final booking = await ref.read(bookingRepositoryProvider).createBooking(
  userId: userId,
  flightId: flight.id,
  selectedSeats: seats,
  travelClass: 'Economy',
  passengers: passengers,
  totalPrice: total,
);
```

### 5. **Payment Screen** (Process Payment)
```dart
final payment = await ref.read(paymentRepositoryProvider).processPayment(
  bookingId: booking.bookingId,
  amount: booking.totalPrice,
  paymentMethod: 'card',
);
```

---

## Adding New Features

### Step 1: Add Entities
- Create domain entity in `entities.dart`
- Create Hive model in `hive_models.dart`

### Step 2: Add Mappers
- Add bidirectional conversion in `mappers.dart`

### Step 3: Create Repositories
- Define interface in `repositories.dart`
- Implement in `implementations.dart`

### Step 4: Create Use Cases
- Add business logic in `usecases.dart`

### Step 5: Create Providers
- Add state providers in `providers.dart`
- Provider for repository
- Providers for specific features

### Step 6: Create UI
- Create `ConsumerWidget` screens
- Use `ref.watch()` for state access
- Handle loading/error states

---

## Common Patterns

### Async Data with Error Handling
```dart
final data = ref.watch(futureProvider);
return data.when(
  data: (value) => Text(value),
  loading: () => const CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```

### Reactive Computed State
```dart
final bookingTotalProvider = StateProvider<double>((ref) {
  final seats = ref.watch(selectedSeatsProvider);
  final flight = ref.watch(selectedFlightProvider);
  return (flight?.priceEconomy ?? 0) * seats.length;
});
```

### Family Providers (with Parameters)
```dart
final userBookingsProvider = 
  FutureProvider.family<List<Booking>, String>((ref, userId) async {
    return ref.read(bookingRepositoryProvider).getUserBookings(userId);
  });
```

---

## Testing

### Testing Repositories
```dart
test('should get user bookings', () async {
  final repo = HiveBookingRepository(mockBox);
  final bookings = await repo.getUserBookings('user123');
  expect(bookings, isNotEmpty);
});
```

### Testing Providers
```dart
test('should watch bookings provider', () async {
  final container = ProviderContainer();
  final bookings = await container.read(userBookingsProvider('user123').future);
  expect(bookings, isNotEmpty);
});
```

---

## Migration from Old Structure

1. **Move data access to repositories**
2. **Extract business logic to use cases**
3. **Replace setState with Riverpod**
4. **Update screens to use ConsumerWidget**
5. **Use Hive for caching**

---

## Performance Tips

1. **Use `.select()` to watch specific fields**
```dart
final userName = ref.watch(
  currentUserProvider.select((user) => user?.fullName ?? '')
);
```

2. **Cache async results with `.future`**
3. **Use `ref.refresh()` only when needed**
4. **Keep Hive boxes open** (not re-opening)

---

## Troubleshooting

### "HiveTypeId already exists"
- Check typeId are unique in `hive_models.dart`
- Don't forget to increment for new models

### "Box not initialized"
- Ensure `Hive.openBox()` called in `main.dart`
- Call before ProviderScope

### Provider not updating
- Ensure using `notifier.state =` not `.state`
- Use `.refresh()` for FutureProviders

---

## Next Steps

1. **Implement remaining screens** with this pattern
2. **Add API layer** - wrap API calls in UseCases
3. **Add offline-first sync** - Combine Hive with API
4. **Implement caching strategy**
5. **Add error recovery**

---

For questions or issues, refer to:
- [Riverpod Docs](https://riverpod.dev)
- [Hive Docs](https://docs.hivedb.dev)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
