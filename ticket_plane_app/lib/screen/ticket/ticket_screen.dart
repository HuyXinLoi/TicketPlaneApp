import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ticket_plane_app/screen/booking/bloc/booking_bloc.dart';
import 'package:ticket_plane_app/screen/booking/booking_screen.dart';
import 'package:ticket_plane_app/screen/ticket/bloc/ticket_bloc.dart';
import 'package:ticket_plane_app/screen/ticket/bloc/ticket_event.dart';
import 'package:ticket_plane_app/screen/ticket/bloc/ticket_state.dart';
import 'package:ticket_plane_app/screen/ticket/data/flight.dart';
import 'package:ticket_plane_app/screen/ticket/data/ticket.dart';

class TicketScreen extends StatefulWidget {
  final String flightId;

  const TicketScreen({Key? key, required this.flightId}) : super(key: key);

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TicketBloc>().add(LoadTickets(flightId: widget.flightId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Vé chuyến bay', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1565C0), // Primary Blue
      ),
      backgroundColor: Colors.grey[200], // Light gray background
      body: BlocBuilder<TicketBloc, TicketState>(
        builder: (context, state) {
          if (state.status == TicketStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == TicketStatus.success) {
            if (state.tickets.isEmpty) {
              return const Center(
                child: Text('Không có vé cho chuyến bay này.',
                    style: TextStyle(color: Colors.black54)),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.tickets.length,
              itemBuilder: (context, index) {
                final ticket = state.tickets[index];
                return TicketCard(ticket: ticket);
              },
            );
          } else if (state.status == TicketStatus.failure) {
            return Center(child: Text(state.errorMessage!));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class TicketCard extends StatefulWidget {
  final Ticket ticket;

  const TicketCard({Key? key, required this.ticket}) : super(key: key);

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  Flight? _flight;
  @override
  void initState() {
    _fetchFlightData();
    super.initState();
  }

  Future<void> _fetchFlightData() async {
    try {
      final flightDoc = await FirebaseFirestore.instance
          .collection('flight')
          .doc(widget.ticket.flightId)
          .get();

      if (flightDoc.exists) {
        setState(() {
          _flight = Flight.fromFirestore(
              flightDoc.data() as Map<String, dynamic>, flightDoc.id);
        });
      } else {
        // Handle case where flight document doesn't exist
        print("Flight document not found for ID: ${widget.ticket.flightId}");
      }
    } catch (e) {
      print("Error fetching flight data: $e");
      // Handle error appropriately (e.g., show an error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_flight != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider<BookingBloc>(
                create: (context) => BookingBloc(),
                child: BookingScreen(ticket: widget.ticket, flight: _flight!),
              ),
            ),
          );
        }
      },
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _flight == null
              ? const Center(
                  child:
                      CircularProgressIndicator()) // Show loading indicator while fetching
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_flight!.diemDi} → ${_flight!.diemDen}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                          ),
                        ),
                        Text(
                          _flight!.tenCB, // Airline name
                          style: const TextStyle(
                            color: Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(Icons.flight_takeoff,
                            color: Color(0xFF757575)),
                        const SizedBox(width: 4.0),
                        Text(
                          'Khởi hành: ${DateFormat('HH:mm - dd/MM/yyyy').format(_flight!.thoiGianDi)}',
                          style: const TextStyle(color: Color(0xFF757575)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Mã vé',
                              style: TextStyle(
                                color: Color(0xFF757575),
                              ),
                            ),
                            Text(
                              widget.ticket.ticketId,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212121),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Giá',
                              style: TextStyle(
                                color: Color(0xFF757575),
                              ),
                            ),
                            Text(
                              '${NumberFormat("#,###").format(int.parse(widget.ticket.price))} VND',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF44336),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
