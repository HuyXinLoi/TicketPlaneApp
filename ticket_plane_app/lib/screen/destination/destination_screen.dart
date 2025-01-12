import 'package:flutter/material.dart';
import 'package:ticket_plane_app/screen/home/data/flight.dart';

class DestinationScreen extends StatelessWidget {
  final String destination;
  final List<Flight> flights;

  const DestinationScreen(
      {Key? key, required this.destination, required this.flights})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách chuyến bay theo điểm đến
    final filteredFlights =
        flights.where((flight) => flight.diemDen == destination).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(destination),
        backgroundColor: const Color(0xFF19509e),
      ),
      body: ListView.builder(
        itemCount: filteredFlights.length,
        itemBuilder: (context, index) {
          final flight = filteredFlights[index];
          return Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(
                  flight.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${flight.diemDi} - ${flight.diemDen} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${flight.thoiGianDi.day}/${flight.thoiGianDi.month}/${flight.thoiGianDi.year}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(flight.tenCB),
                    const SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
