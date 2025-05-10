import 'package:equatable/equatable.dart';
import 'package:ticket_plane_app/screen/booking/data/bookingg.dart';

enum BookingStatus { initial, loading, success, failure }

class BookingState extends Equatable {
  final BookingStatus status;
  final Booking? booking; // Current booking being created/managed
  final String? errorMessage;

  const BookingState({
    this.status = BookingStatus.initial,
    this.booking,
    this.errorMessage,
  });

  BookingState copyWith({
    BookingStatus? status,
    Booking? booking,
    String? errorMessage,
  }) {
    return BookingState(
      status: status ?? this.status,
      booking: booking ?? this.booking,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, booking, errorMessage];
}
