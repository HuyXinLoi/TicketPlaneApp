part of 'destination_bloc.dart';

sealed class DestinationState extends Equatable {
  const DestinationState();
  
  @override
  List<Object> get props => [];
}

final class DestinationInitial extends DestinationState {}
