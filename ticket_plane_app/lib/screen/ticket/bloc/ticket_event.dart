import 'package:equatable/equatable.dart';

abstract class TicketEvent extends Equatable {
  const TicketEvent();

  @override
  List<Object> get props => [];
}

class LoadTickets extends TicketEvent {
  final String flightId;

  const LoadTickets({required this.flightId});

  @override
  List<Object> get props => [flightId];
}
