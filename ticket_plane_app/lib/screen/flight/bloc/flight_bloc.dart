import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticket_plane_app/screen/flight/data/flight.dart';

part 'flight_event.dart';
part 'flight_state.dart';

class FlightBloc extends Bloc<FlightEvent, FlightState> {
  FlightBloc() : super(const FlightState()) {
    on<LoadFlight>(_onLoadFlight);
  }

  void _onLoadFlight(LoadFlight event, Emitter<FlightState> emit) async {
    emit(state.copyWith(status: FlightStatus.loading));
    try {
      DocumentSnapshot flightDoc = await FirebaseFirestore.instance
          .collection('flight')
          .doc(event.flightId)
          .get();

      if (flightDoc.exists) {
        Flight flight = Flight.fromFirestore(
            flightDoc as DocumentSnapshot<Map<String, dynamic>>);
        emit(state.copyWith(status: FlightStatus.success, flight: flight));
      } else {
        emit(state.copyWith(
            status: FlightStatus.failure,
            errorMessage: 'Chuyến bay không tồn tại.'));
      }
    } catch (e) {
      emit(state.copyWith(
          status: FlightStatus.failure,
          errorMessage: 'Lỗi khi tải thông tin chuyến bay: ${e.toString()}'));
    }
  }
}
