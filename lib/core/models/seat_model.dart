// Seat Model
class Seat {
  final String seatNumber;
  final String row;
  final int column;
  bool isSelected;
  bool isBooked;
  final String seatClass; // 'economy' or 'business'

  Seat({
    required this.seatNumber,
    required this.row,
    required this.column,
    this.isSelected = false,
    this.isBooked = false,
    required this.seatClass,
  });

  String get seatId => '$row$column';
}

// Generate seat map for flights
List<Seat> generateSeatMap(String seatClass) {
  List<Seat> seats = [];
  
  if (seatClass == 'economy') {
    // 6 columns per row (A-F), 30 rows - Economy
    for (int row = 1; row <= 30; row++) {
      for (int col = 0; col < 6; col++) {
        String colLetter = String.fromCharCode(65 + col); // A, B, C...
        seats.add(
          Seat(
            seatNumber: '$row$colLetter',
            row: row.toString(),
            column: col,
            isBooked: false,
            seatClass: 'economy',
          ),
        );
      }
    }
  } else {
    // 4 columns per row (A-D), 15 rows - Business
    for (int row = 1; row <= 15; row++) {
      for (int col = 0; col < 4; col++) {
        String colLetter = String.fromCharCode(65 + col);
        seats.add(
          Seat(
            seatNumber: '$row$colLetter',
            row: row.toString(),
            column: col,
            isBooked: row <= 5 ? true : false, // First 5 rows are booked
            seatClass: 'business',
          ),
        );
      }
    }
  }
  
  return seats;
}

// Booking Model
class Booking {
  final String bookingId;
  final String flightId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final List<String> selectedSeats;
  final String seatClass;
  final int passengerCount;
  final double totalPrice;
  final DateTime bookingDate;
  final String paymentStatus; // 'pending', 'completed', 'failed'
  final String bookingStatus; // 'confirmed', 'pending', 'cancelled'

  Booking({
    required this.bookingId,
    required this.flightId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.selectedSeats,
    required this.seatClass,
    required this.passengerCount,
    required this.totalPrice,
    required this.bookingDate,
    required this.paymentStatus,
    required this.bookingStatus,
  });

  String get formattedPrice {
    return 'Rs. ${totalPrice.toStringAsFixed(0)}';
  }

  String get formattedDate {
    return '${bookingDate.day}/${bookingDate.month}/${bookingDate.year}';
  }
}

// Payment Model
class Payment {
  final String paymentId;
  final String bookingId;
  final double amount;
  final String paymentMethod; // 'card', 'wallet', 'bank_transfer'
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cvv;
  final DateTime paymentDate;
  final String status; // 'pending', 'success', 'failed'

  Payment({
    required this.paymentId,
    required this.bookingId,
    required this.amount,
    required this.paymentMethod,
    this.cardNumber = '',
    this.cardHolder = '',
    this.expiryDate = '',
    this.cvv = '',
    required this.paymentDate,
    this.status = 'pending',
  });
}
