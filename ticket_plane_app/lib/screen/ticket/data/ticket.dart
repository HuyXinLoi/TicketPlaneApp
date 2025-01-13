import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  final String ticketId;
  final String flightId;
  final String price;

  Ticket({
    required this.ticketId,
    required this.flightId,
    required this.price,
  });

  factory Ticket.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Ticket(
      ticketId: data['TicketId'] ?? '',
      flightId: data['FlightId'] ?? '',
      price: data['Gia'] ?? '',
    );
  }
}
