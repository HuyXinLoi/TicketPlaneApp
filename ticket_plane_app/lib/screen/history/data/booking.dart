import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String bookingId;
  final String paymentStatus;
  final int soGhe;
  final int soNguoi;
  final String ticketId;
  final String userId;

  Booking({
    required this.bookingId,
    required this.paymentStatus,
    required this.soGhe,
    required this.soNguoi,
    required this.ticketId,
    required this.userId,
  });

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Booking(
      bookingId: doc.id,
      paymentStatus: data['PaymentStatus'] ?? '',
      soGhe: data['SoGhe'] ?? 0,
      soNguoi: data['SoNguoi'] ?? 0,
      ticketId: data['TicketId'] ?? '',
      userId: data['UserId'] ?? '',
    );
  }
}
