import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_plane_app/screen/booking/bloc/booking_bloc.dart';
import 'package:ticket_plane_app/screen/booking/bloc/booking_event.dart';
import 'package:ticket_plane_app/screen/booking/bloc/booking_state.dart';
import 'package:ticket_plane_app/screen/booking/payment_screen.dart';
import 'package:ticket_plane_app/screen/ticket/data/flight.dart';
import 'package:ticket_plane_app/screen/ticket/data/ticket.dart';

class BookingScreen extends StatefulWidget {
  final Ticket ticket;

  const BookingScreen({Key? key, required this.ticket, required Flight flight})
      : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt vé', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state.status == BookingStatus.success) {
            // Navigate to a success screen or show a success dialog
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đặt vé thành công!')),
            );
            // Optionally, you can navigate back or to another screen
            // Navigator.of(context).pop();
          } else if (state.status == BookingStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          if (state.status == BookingStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                        ticket: widget.ticket,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text('Thanh toán',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            );
          }
        },
      ),
    );
  }
}
