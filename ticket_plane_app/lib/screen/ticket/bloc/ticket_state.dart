import 'package:equatable/equatable.dart';
import 'package:ticket_plane_app/screen/ticket/data/ticket.dart';

enum TicketStatus { initial, loading, success, failure }

class TicketState extends Equatable {
  final TicketStatus status;
  final List<Ticket> tickets;
  final String? errorMessage;

  const TicketState({
    this.status = TicketStatus.initial,
    this.tickets = const [],
    this.errorMessage,
  });

  TicketState copyWith({
    TicketStatus? status,
    List<Ticket>? tickets,
    String? errorMessage,
  }) {
    return TicketState(
      status: status ?? this.status,
      tickets: tickets ?? this.tickets,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, tickets, errorMessage];
}
