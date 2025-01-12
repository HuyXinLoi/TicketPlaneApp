import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchFlights extends SearchEvent {
  final String diemDi;
  final String diemDen;
  final DateTime ngayDi;

  const SearchFlights(
      {required this.diemDi, required this.diemDen, required this.ngayDi});

  @override
  List<Object> get props => [diemDi, diemDen, ngayDi];
}

class LoadLocations extends SearchEvent {}
