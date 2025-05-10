import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_plane_app/screen/history/bloc/history_event.dart';
import 'package:ticket_plane_app/screen/history/bloc/history_state.dart';
import 'package:ticket_plane_app/screen/history/data/booking.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {
    on<LoadHistory>(_onLoadHistory);
  }

  Future<void> _onLoadHistory(
      LoadHistory event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) {
        emit(const HistoryError(message: 'User ID not found.'));
        return;
      }

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('booking')
          .where('UserId', isEqualTo: userId)
          .get();

      List<Booking> bookings =
          querySnapshot.docs.map((doc) => Booking.fromFirestore(doc)).toList();

      emit(HistoryLoaded(bookings: bookings));
    } catch (e) {
      emit(HistoryError(message: e.toString()));
    }
  }
}
