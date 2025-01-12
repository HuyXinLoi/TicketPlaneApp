part of 'flight_bloc.dart';

sealed class FlightState extends Equatable {
  const FlightState();
  
  @override
  List<Object> get props => [];
}

final class FlightInitial extends FlightState {}
