import 'package:equatable/equatable.dart';
import 'package:ticket_plane_app/screen/destination/data/destination.dart';

enum DestinationStatus { initial, loading, success, failure }

class DestinationState extends Equatable {
  final DestinationStatus status;
  final List<Destination> destinations;
  final String? errorMessage;

  const DestinationState({
    this.status = DestinationStatus.initial,
    this.destinations = const [],
    this.errorMessage,
  });

  DestinationState copyWith({
    DestinationStatus? status,
    List<Destination>? destinations,
    String? errorMessage,
  }) {
    return DestinationState(
      status: status ?? this.status,
      destinations: destinations ?? this.destinations,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, destinations, errorMessage];
}
