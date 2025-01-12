import 'package:equatable/equatable.dart';
import 'package:ticket_plane_app/screen/search/data/flight.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum SearchStatus { initial, loading, success, error }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<Flight> flights;
  final String? errorMessage;
  final List<String> locations;
  final DateTime? thoiGianDi;

  const SearchState({
    this.status = SearchStatus.initial,
    this.flights = const [],
    this.errorMessage,
    this.locations = const [],
    this.thoiGianDi,
  });

  SearchState copyWith({
    SearchStatus? status,
    List<Flight>? flights,
    String? errorMessage,
    List<String>? locations,
    DateTime? thoiGianDi,
  }) {
    return SearchState(
      status: status ?? this.status,
      flights: flights ?? this.flights,
      errorMessage: errorMessage ?? this.errorMessage,
      locations: locations ?? this.locations,
      thoiGianDi: thoiGianDi ?? this.thoiGianDi,
    );
  }

  @override
  List<Object?> get props =>
      [status, flights, errorMessage, locations, thoiGianDi];
}
