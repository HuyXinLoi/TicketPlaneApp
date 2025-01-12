import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticket_plane_app/screen/search/bloc/search_event.dart';
import 'package:ticket_plane_app/screen/search/bloc/search_state.dart';
import 'package:ticket_plane_app/screen/search/data/flight.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SearchBloc() : super(const SearchState()) {
    on<SearchFlights>(_onSearchFlights);
    on<LoadLocations>(_onLoadLocations);
  }

  Future<void> _onSearchFlights(
      SearchFlights event, Emitter<SearchState> emit) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('flight')
          .where('DiemDi', isEqualTo: event.diemDi)
          .where('DiemDen', isEqualTo: event.diemDen)
          .get();

      List<Flight> flights = querySnapshot.docs
          .map((doc) => Flight.fromFirestore(doc))
          .where((flight) =>
              flight.thoiGianDi.toDate().day == event.ngayDi.day &&
              flight.thoiGianDi.toDate().month == event.ngayDi.month &&
              flight.thoiGianDi.toDate().year == event.ngayDi.year)
          .toList();

      if (flights.isEmpty) {
        emit(state.copyWith(
            status: SearchStatus.error,
            errorMessage: "Không tìm thấy chuyến bay phù hợp."));
      } else {
        emit(state.copyWith(
            status: SearchStatus.success,
            flights: flights,
            thoiGianDi: flights.first.thoiGianDi
                .toDate())); // Cập nhật giá trị thoiGianDi
      }
    } catch (e) {
      emit(state.copyWith(
          status: SearchStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadLocations(
      LoadLocations event, Emitter<SearchState> emit) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('flight').get();
      List<Flight> allFlights =
          querySnapshot.docs.map((doc) => Flight.fromFirestore(doc)).toList();
      List<String> locations = [];
      for (var doc in querySnapshot.docs) {
        String diemDi = doc.get('DiemDi');
        String diemDen = doc.get('DiemDen');
        if (!locations.contains(diemDi)) {
          locations.add(diemDi);
        }
        if (!locations.contains(diemDen)) {
          locations.add(diemDen);
        }
      }
      emit(state.copyWith(
        status: SearchStatus.success,
        locations: locations,
        flights: allFlights,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: SearchStatus.error,
          errorMessage: "Lỗi khi tải địa điểm: ${e.toString()}"));
    }
  }
}
