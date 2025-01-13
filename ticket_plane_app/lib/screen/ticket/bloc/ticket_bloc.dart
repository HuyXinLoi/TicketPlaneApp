import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticket_plane_app/screen/ticket/bloc/ticket_event.dart';
import 'package:ticket_plane_app/screen/ticket/bloc/ticket_state.dart';
import 'package:ticket_plane_app/screen/ticket/data/ticket.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  TicketBloc() : super(const TicketState()) {
    on<LoadTickets>(_onLoadTickets);
  }

  Future<void> _onLoadTickets(
      LoadTickets event, Emitter<TicketState> emit) async {
    emit(state.copyWith(status: TicketStatus.loading));
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('ticket')
          .where('FlightId', isEqualTo: event.flightId)
          .get();

      final tickets =
          querySnapshot.docs.map((doc) => Ticket.fromFirestore(doc)).toList();

      emit(state.copyWith(status: TicketStatus.success, tickets: tickets));
    } catch (e) {
      emit(state.copyWith(
        status: TicketStatus.failure,
        errorMessage: 'Failed to load tickets: ${e.toString()}',
      ));
    }
  }
}
