import 'package:equatable/equatable.dart';

abstract class DestinationEvent extends Equatable {
  const DestinationEvent();

  @override
  List<Object> get props => [];
}

class LoadDestinations extends DestinationEvent {}
