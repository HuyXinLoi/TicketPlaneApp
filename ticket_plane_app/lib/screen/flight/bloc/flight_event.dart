part of 'flight_bloc.dart';

abstract class FlightEvent extends Equatable {
  const FlightEvent();

  @override
  List<Object> get props => [];
}

class LoadFlight extends FlightEvent {
  final String flightId;

  const LoadFlight(this.flightId);

  @override
  List<Object> get props => [flightId];
}
