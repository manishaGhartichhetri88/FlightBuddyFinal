// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveUserAdapter extends TypeAdapter<HiveUser> {
  @override
  final int typeId = 0;

  @override
  HiveUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveUser(
      id: fields[0] as String,
      email: fields[1] as String,
      fullName: fields[2] as String?,
      phone: fields[3] as String?,
      profileImage: fields[4] as String?,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HiveUser obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.profileImage)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveFlightAdapter extends TypeAdapter<HiveFlight> {
  @override
  final int typeId = 1;

  @override
  HiveFlight read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveFlight(
      id: fields[0] as String,
      airline: fields[1] as String,
      flightNumber: fields[2] as String,
      fromCity: fields[3] as String,
      toCity: fields[4] as String,
      departureTime: fields[5] as DateTime,
      arrivalTime: fields[6] as DateTime,
      duration: fields[7] as String,
      priceEconomy: fields[8] as double,
      priceBusiness: fields[9] as double,
      availableSeatsEconomy: fields[10] as int,
      availableSeatsBusiness: fields[11] as int,
      aircraftType: fields[12] as String,
      isReturn: fields[13] as bool,
      returnDate: fields[14] as DateTime?,
      stops: fields[15] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveFlight obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.airline)
      ..writeByte(2)
      ..write(obj.flightNumber)
      ..writeByte(3)
      ..write(obj.fromCity)
      ..writeByte(4)
      ..write(obj.toCity)
      ..writeByte(5)
      ..write(obj.departureTime)
      ..writeByte(6)
      ..write(obj.arrivalTime)
      ..writeByte(7)
      ..write(obj.duration)
      ..writeByte(8)
      ..write(obj.priceEconomy)
      ..writeByte(9)
      ..write(obj.priceBusiness)
      ..writeByte(10)
      ..write(obj.availableSeatsEconomy)
      ..writeByte(11)
      ..write(obj.availableSeatsBusiness)
      ..writeByte(12)
      ..write(obj.aircraftType)
      ..writeByte(13)
      ..write(obj.isReturn)
      ..writeByte(14)
      ..write(obj.returnDate)
      ..writeByte(15)
      ..write(obj.stops);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveFlightAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveSeatAdapter extends TypeAdapter<HiveSeat> {
  @override
  final int typeId = 2;

  @override
  HiveSeat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveSeat(
      seatNumber: fields[0] as String,
      seatClass: fields[1] as String,
      isAvailable: fields[2] as bool,
      isSelected: fields[3] as bool,
      passengerId: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveSeat obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.seatNumber)
      ..writeByte(1)
      ..write(obj.seatClass)
      ..writeByte(2)
      ..write(obj.isAvailable)
      ..writeByte(3)
      ..write(obj.isSelected)
      ..writeByte(4)
      ..write(obj.passengerId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveSeatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveBookingAdapter extends TypeAdapter<HiveBooking> {
  @override
  final int typeId = 3;

  @override
  HiveBooking read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveBooking(
      bookingId: fields[0] as String,
      userId: fields[1] as String,
      flightId: fields[2] as String,
      selectedSeats: (fields[3] as List).cast<String>(),
      travelClass: fields[4] as String,
      passengers: (fields[5] as List).cast<HivePassenger>(),
      totalPrice: fields[6] as double,
      status: fields[7] as String,
      bookingDate: fields[8] as DateTime,
      paymentDate: fields[9] as DateTime?,
      paymentMethod: fields[10] as String?,
      isReturn: fields[11] as bool,
      returnFlightId: fields[12] as String?,
      returnSeats: (fields[13] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveBooking obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.bookingId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.flightId)
      ..writeByte(3)
      ..write(obj.selectedSeats)
      ..writeByte(4)
      ..write(obj.travelClass)
      ..writeByte(5)
      ..write(obj.passengers)
      ..writeByte(6)
      ..write(obj.totalPrice)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.bookingDate)
      ..writeByte(9)
      ..write(obj.paymentDate)
      ..writeByte(10)
      ..write(obj.paymentMethod)
      ..writeByte(11)
      ..write(obj.isReturn)
      ..writeByte(12)
      ..write(obj.returnFlightId)
      ..writeByte(13)
      ..write(obj.returnSeats);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveBookingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HivePassengerAdapter extends TypeAdapter<HivePassenger> {
  @override
  final int typeId = 4;

  @override
  HivePassenger read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HivePassenger(
      id: fields[0] as String,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      email: fields[3] as String,
      phone: fields[4] as String,
      passportNumber: fields[5] as String,
      dateOfBirth: fields[6] as DateTime,
      nationality: fields[7] as String,
      isAdult: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HivePassenger obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.passportNumber)
      ..writeByte(6)
      ..write(obj.dateOfBirth)
      ..writeByte(7)
      ..write(obj.nationality)
      ..writeByte(8)
      ..write(obj.isAdult);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HivePassengerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveSearchHistoryAdapter extends TypeAdapter<HiveSearchHistory> {
  @override
  final int typeId = 5;

  @override
  HiveSearchHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveSearchHistory(
      fromCity: fields[0] as String,
      toCity: fields[1] as String,
      departureDate: fields[2] as DateTime,
      returnDate: fields[3] as DateTime?,
      passengers: fields[4] as int,
      searchedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HiveSearchHistory obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.fromCity)
      ..writeByte(1)
      ..write(obj.toCity)
      ..writeByte(2)
      ..write(obj.departureDate)
      ..writeByte(3)
      ..write(obj.returnDate)
      ..writeByte(4)
      ..write(obj.passengers)
      ..writeByte(5)
      ..write(obj.searchedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveSearchHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HivePaymentAdapter extends TypeAdapter<HivePayment> {
  @override
  final int typeId = 6;

  @override
  HivePayment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HivePayment(
      paymentId: fields[0] as String,
      bookingId: fields[1] as String,
      amount: fields[2] as double,
      paymentMethod: fields[3] as String,
      status: fields[4] as String,
      createdAt: fields[5] as DateTime,
      completedAt: fields[6] as DateTime?,
      transactionId: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HivePayment obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.paymentId)
      ..writeByte(1)
      ..write(obj.bookingId)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.paymentMethod)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.completedAt)
      ..writeByte(7)
      ..write(obj.transactionId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HivePaymentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveOfferAdapter extends TypeAdapter<HiveOffer> {
  @override
  final int typeId = 7;

  @override
  HiveOffer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveOffer(
      offerId: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      discountPercentage: fields[3] as double,
      validFrom: fields[4] as DateTime,
      validUntil: fields[5] as DateTime,
      couponCode: fields[6] as String?,
      isActive: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HiveOffer obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.offerId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.discountPercentage)
      ..writeByte(4)
      ..write(obj.validFrom)
      ..writeByte(5)
      ..write(obj.validUntil)
      ..writeByte(6)
      ..write(obj.couponCode)
      ..writeByte(7)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveOfferAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveNotificationAdapter extends TypeAdapter<HiveNotification> {
  @override
  final int typeId = 8;

  @override
  HiveNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveNotification(
      id: fields[0] as String,
      userId: fields[1] as String,
      title: fields[2] as String,
      message: fields[3] as String,
      type: fields[4] as String,
      isRead: fields[5] as bool,
      createdAt: fields[6] as DateTime,
      relatedId: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveNotification obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.message)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.isRead)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.relatedId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
