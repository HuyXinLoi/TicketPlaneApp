import 'package:equatable/equatable.dart';
import 'package:ticket_plane_app/screen/booking/data/bookingg.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class CreateBooking extends BookingEvent {
  final Booking booking;

  const CreateBooking({required this.booking});

  @override
  List<Object> get props => [booking];
}
// You might need other events like LoadBooking, UpdatePaymentStatus, etc.
