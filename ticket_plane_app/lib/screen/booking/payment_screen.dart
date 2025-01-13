import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ticket_plane_app/screen/booking/bloc/booking_bloc.dart';
import 'package:ticket_plane_app/screen/booking/bloc/booking_event.dart';
import 'package:ticket_plane_app/screen/booking/bloc/booking_state.dart';
import 'package:ticket_plane_app/screen/booking/data/bookingg.dart';
import 'package:ticket_plane_app/screen/home/home_screen.dart';
import 'package:ticket_plane_app/screen/ticket/data/ticket.dart';

class PaymentScreen extends StatefulWidget {
  final Ticket ticket;

  const PaymentScreen({Key? key, required this.ticket}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _numberOfSeats = 1;
  int _numberOfPassengers = 1;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    final ticketPrice = int.parse(widget.ticket.price);
    final totalPrice = ticketPrice * _numberOfPassengers;

    return Scaffold(
      // BlocListener is now inside Scaffold
      appBar: AppBar(
        title: const Text('Thanh toán', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: BlocListener<BookingBloc, BookingState>(
        // Correctly placed BlocListener
        listener: (context, state) {
          if (state.status == BookingStatus.success) {
            // Show Flushbar
            Flushbar(
              message: "Thanh toán thành công!",
              duration: const Duration(seconds: 3),
              flushbarPosition: FlushbarPosition.TOP,
              backgroundColor: Colors.green,
              icon: const Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
            ).show(context).then((_) {
              // Navigate to Home screen after Flushbar disappears
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false,
              );
            });
          } else if (state.status == BookingStatus.failure) {
            Flushbar(
              message: "Thanh toán thất bại: ${state.errorMessage}",
              duration: const Duration(seconds: 4),
              flushbarPosition: FlushbarPosition.TOP,
              backgroundColor: Colors.red,
              icon: const Icon(
                Icons.error,
                color: Colors.white,
              ),
            ).show(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Thông tin vé:',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('Mã vé: ${widget.ticket.ticketId}'),
              Text('Giá vé: ${widget.ticket.price}'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Số ghế:'),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (_numberOfSeats > 1) {
                              _numberOfSeats--;
                            }
                          });
                        },
                      ),
                      Text('$_numberOfSeats'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _numberOfSeats++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Số người:'),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (_numberOfPassengers > 1) {
                              _numberOfPassengers--;
                            }
                          });
                        },
                      ),
                      Text('$_numberOfPassengers'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _numberOfPassengers++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Tổng tiền: ${NumberFormat("#,###").format(totalPrice)} VND',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Create a new booking instance
                    final newBooking = Booking(
                      bookingId: '',
                      ticketId: widget.ticket.ticketId,
                      userId: userId,
                      paymentStatus: 'Đã thanh toán',
                      numberOfSeats: _numberOfSeats,
                      numberOfPassengers: _numberOfPassengers,
                    );

                    // Dispatch the CreateBooking event
                    context
                        .read<BookingBloc>()
                        .add(CreateBooking(booking: newBooking));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  child: const Text('Xác nhận thanh toán',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
