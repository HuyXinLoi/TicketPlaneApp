import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ticket_plane_app/screen/history/bloc/history_bloc.dart';
import 'package:ticket_plane_app/screen/history/bloc/history_event.dart';
import 'package:ticket_plane_app/screen/history/bloc/history_state.dart';
import 'package:ticket_plane_app/screen/history/data/booking.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(LoadHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lịch sử đặt vé của bạn',
          style: TextStyle(color: Colors.white), // Màu chữ trắng
        ),
        backgroundColor: const Color(0xFF19509e), // Màu nền xanh dương đậm
        // Loại bỏ icon search
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistoryLoaded) {
            return ListView.builder(
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                Booking booking = state.bookings[index];
                return _buildBookingItem(booking);
              },
            );
          } else if (state is HistoryError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Something went wrong.'));
          }
        },
      ),
    );
  }

  Widget _buildBookingItem(Booking booking) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section: Booking ID and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: booking.paymentStatus == 'Đã thanh toán'
                        ? Colors.green[100]
                        : Colors.red[100],
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    booking.paymentStatus,
                    style: TextStyle(
                      color: booking.paymentStatus == 'Đã thanh toán'
                          ? Colors.green[800]
                          : Colors.red[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Middle section: Flight details (placeholder for now)
            // You might need to adjust this based on how you fetch flight data
            Row(
              children: [
                Icon(Icons.flight, color: Colors.blue[300]),
                const SizedBox(width: 8.0),
                // Assuming you can get flight origin and destination from somewhere
                // Replace these with actual data when you have it
                // Text(
                //   '${booking.flight.origin} → ${booking.flight.destination}',
                //   style: TextStyle(fontSize: 16.0),
                // ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Bottom section: Ticket and passenger details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ticket ID', style: TextStyle(color: Colors.grey)),
                    Text(
                      booking.ticketId,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Text('Số ghế', style: TextStyle(color: Colors.grey)),
                    Text(
                      '${booking.soGhe}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Số người', style: TextStyle(color: Colors.grey)),
                    Text(
                      '${booking.soNguoi}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    // Add more details here if necessary
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
