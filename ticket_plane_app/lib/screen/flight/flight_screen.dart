import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_plane_app/screen/flight/bloc/flight_bloc.dart';
import 'package:ticket_plane_app/screen/flight/data/flight.dart';
import 'package:ticket_plane_app/screen/ticket/ticket_screen.dart';

class FlightScreen extends StatefulWidget {
  final String flightId;

  const FlightScreen({Key? key, required this.flightId}) : super(key: key);

  @override
  State<FlightScreen> createState() => _FlightScreenState();
}

class _FlightScreenState extends State<FlightScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FlightBloc>().add(LoadFlight(widget.flightId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<FlightBloc, FlightState>(
          builder: (context, state) {
            if (state.status == FlightStatus.success) {
              return Text(
                  'Chuyến bay ${state.flight!.diemDi} đến ${state.flight!.diemDen}');
            }
            return const Text('Chi tiết chuyến bay');
          },
        ),
      ),
      body: BlocBuilder<FlightBloc, FlightState>(
        builder: (context, state) {
          if (state.status == FlightStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == FlightStatus.success) {
            final Flight flight = state.flight!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hình ảnh chuyến bay
                  Image.network(
                    flight.image,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  // Hình ảnh điểm đến
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      flight.arrivalCityImage,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Mô tả
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      flight.moTa,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                  // Nút đặt vé
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Chuyển đến màn hình đặt vé (ve_screen)
                        // Cần truyền thông tin chuyến bay sang màn hình đặt vé
                        // Navigator.push(
                        //     // context,
                        //     // MaterialPageRoute(
                        //     //   builder: (context) => VeScreen(
                        //     //     flight: flight,
                        //     //   ),
                        //     // ),
                        //     );
                      },
                      child: const Text('Đặt vé ngay'),
                    ),
                  ),
                ],
              ),
            );
          } else if (state.status == FlightStatus.failure) {
            return Center(child: Text(state.errorMessage!));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
