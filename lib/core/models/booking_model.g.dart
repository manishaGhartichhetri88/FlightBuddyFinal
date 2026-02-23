// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingAdapter extends TypeAdapter<Booking> {
  @override
  final int typeId = 2;

  @override
  Booking read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Booking(
      bookingId: fields[0] as String,
      flight: fields[1] as Flight,
      selectedSeats: (fields[2] as List).cast<String>(),
      totalPrice: fields[3] as double,
      bookingDate: fields[4] as DateTime,
      passengerName: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Booking obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.bookingId)
      ..writeByte(1)
      ..write(obj.flight)
      ..writeByte(2)
      ..write(obj.selectedSeats)
      ..writeByte(3)
      ..write(obj.totalPrice)
      ..writeByte(4)
      ..write(obj.bookingDate)
      ..writeByte(5)
      ..write(obj.passengerName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
