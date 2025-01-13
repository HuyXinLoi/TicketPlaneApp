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
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      String? userName;
      String? userImageUrl;
      if (userId != null) {
        try {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('passengers')
              .doc(userId)
              .get();

          if (userDoc.exists) {
            userName = userDoc.get('name');
            await prefs.setString('username', userName!);
            userImageUrl = userDoc.get('urlImage');
          } else {
            print('User document not found.');
          }
        } catch (e) {
          print('Error fetching user data: $e');
        }
      }

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

      final username = prefs.getString('email');
      emit(state.copyWith(
          status: HomeStatus.success,
          flights: flights,
          username: username,
          discounts: discounts,
          arrivalCities: arrivalCities,
          userName: userName,
          userImageUrl: userImageUrl));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
