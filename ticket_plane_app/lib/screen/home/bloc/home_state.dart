import 'package:equatable/equatable.dart';
import 'package:ticket_plane_app/screen/home/data/discount.dart';
import 'package:ticket_plane_app/screen/home/data/flight.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Flight> flights;
  final String? errorMessage;
  final String? username;
  final List<Discount> discounts;
  final List<String> arrivalCities; // Thêm danh sách điểm đến

  const HomeState({
    this.status = HomeStatus.initial,
    this.flights = const [],
    this.errorMessage,
    this.username,
    this.discounts = const [],
    this.arrivalCities = const [], // Khởi tạo danh sách rỗng
  });

  HomeState copyWith({
    HomeStatus? status,
    List<Flight>? flights,
    String? errorMessage,
    String? username,
    List<Discount>? discounts,
    List<String>? arrivalCities, // Thêm vào copyWith
  }) {
    return HomeState(
      status: status ?? this.status,
      flights: flights ?? this.flights,
      errorMessage: errorMessage ?? this.errorMessage,
      username: username ?? this.username,
      discounts: discounts ?? this.discounts,
      arrivalCities: arrivalCities ?? this.arrivalCities, // Thêm vào copyWith
    );
  }

  @override
  List<Object?> get props =>
      [status, flights, errorMessage, username, discounts, arrivalCities];
}
