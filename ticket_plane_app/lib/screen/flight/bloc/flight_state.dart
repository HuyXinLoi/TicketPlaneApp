part of 'flight_bloc.dart';

enum FlightStatus { initial, loading, success, failure }

class FlightState extends Equatable {
  final FlightStatus status;
  final Flight? flight;
  final String? errorMessage;

  const FlightState({
    this.status = FlightStatus.initial,
    this.flight,
    this.errorMessage,
  });

  FlightState copyWith({
    FlightStatus? status,
    Flight? flight,
    String? errorMessage,
  }) {
    return FlightState(
      status: status ?? this.status,
      flight: flight ?? this.flight,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, flight, errorMessage];
}
