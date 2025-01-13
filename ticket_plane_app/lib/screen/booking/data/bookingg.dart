import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  final String bookingId;
  final String ticketId;
  final String userId;
  final String paymentStatus;
  final int numberOfSeats;
  final int numberOfPassengers;

  const Booking({
    required this.bookingId,
    required this.ticketId,
    required this.userId,
    this.paymentStatus = 'Chưa thanh toán',
    required this.numberOfSeats,
    required this.numberOfPassengers,
  });

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Booking(
      bookingId: data['BookingId'] ?? '',
      ticketId: data['TicketId'] ?? '',
      userId: data['UserId'] ?? '',
      paymentStatus: data['PaymentStatus'] ?? '',
      numberOfSeats: data['SoGhe'] ?? 0,
      numberOfPassengers: data['SoNguoi'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'BookingId': bookingId,
      'TicketId': ticketId,
      'UserId': userId,
      'PaymentStatus': paymentStatus,
      'SoGhe': numberOfSeats,
      'SoNguoi': numberOfPassengers,
    };
  }

  Booking copyWith({
    String? bookingId,
    String? ticketId,
    String? userId,
    String? paymentStatus,
    int? numberOfSeats,
    int? numberOfPassengers,
  }) {
    return Booking(
      bookingId: bookingId ?? this.bookingId,
      ticketId: ticketId ?? this.ticketId,
      userId: userId ?? this.userId,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      numberOfSeats: numberOfSeats ?? this.numberOfSeats,
      numberOfPassengers: numberOfPassengers ?? this.numberOfPassengers,
    );
  }

  @override
  List<Object?> get props => [
        bookingId,
        ticketId,
        userId,
        paymentStatus,
        numberOfSeats,
        numberOfPassengers
      ];
}
