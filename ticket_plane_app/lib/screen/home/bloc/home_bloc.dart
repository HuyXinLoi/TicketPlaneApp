import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_plane_app/screen/home/bloc/home_event.dart';
import 'package:ticket_plane_app/screen/home/bloc/home_state.dart';
import 'package:ticket_plane_app/screen/home/data/discount.dart';
import 'package:ticket_plane_app/screen/home/data/flight.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  HomeBloc() : super(const HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
      LoadHomeData event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      QuerySnapshot flightsSnapshot =
          await _firestore.collection('flight').get();
      List<Flight> flights = flightsSnapshot.docs
          .map((doc) =>
              Flight.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      // Lấy danh sách điểm đến duy nhất
      List<String> arrivalCities =
          flights.map((flight) => flight.diemDen).toSet().toList();

      // Lấy dữ liệu discounts
      QuerySnapshot discountsSnapshot = await _firestore
          .collection('discount')
          .where('enable', isEqualTo: true)
          .get();
      List<Discount> discounts = discountsSnapshot.docs
          .map((doc) => Discount.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('email');
      emit(state.copyWith(
        status: HomeStatus.success,
        flights: flights,
        username: username,
        discounts: discounts,
        arrivalCities: arrivalCities, // Thêm danh sách điểm đến vào state
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
