import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_plane_app/screen/booking/bloc/booking_event.dart';
import 'package:ticket_plane_app/screen/booking/bloc/booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(const BookingState()) {
    on<CreateBooking>(_onCreateBooking);
  }

  Future<void> _onCreateBooking(
      CreateBooking event, Emitter<BookingState> emit) async {
    emit(state.copyWith(status: BookingStatus.loading));
    try {
      // Get the current user's ID
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      if (userId == null) {
        throw Exception("User not logged in.");
      }
      // Add the current user's ID to the booking
      final bookingWithUser = event.booking.copyWith(userId: userId);

      // Add booking to Firestore
      final docRef = await FirebaseFirestore.instance
          .collection('booking')
          .add(bookingWithUser.toFirestore());

      // Update the booking with the generated ID
      final updatedBooking = bookingWithUser.copyWith(
        bookingId: docRef.id,
        paymentStatus: 'Đã thanh toán',
      );
      await docRef.update(updatedBooking.toFirestore());

      emit(state.copyWith(
          status: BookingStatus.success, booking: updatedBooking));
    } catch (e) {
      emit(state.copyWith(
        status: BookingStatus.failure,
        errorMessage: 'Failed to create booking: ${e.toString()}',
      ));
    }
  }
}
