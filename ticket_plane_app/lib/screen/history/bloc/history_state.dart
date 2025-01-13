import 'package:equatable/equatable.dart';
import 'package:ticket_plane_app/screen/history/data/booking.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<Booking> bookings;

  const HistoryLoaded({required this.bookings});

  @override
  List<Object> get props => [bookings];
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError({required this.message});

  @override
  List<Object> get props => [message];
}
