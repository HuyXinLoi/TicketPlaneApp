import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_plane_app/screen/destination/destination_screen.dart';
import 'package:ticket_plane_app/screen/flight/flight_screen.dart';
import 'package:ticket_plane_app/screen/home/bloc/home_bloc.dart';
import 'package:ticket_plane_app/screen/home/bloc/home_event.dart';
import 'package:ticket_plane_app/screen/home/bloc/home_state.dart';
import 'package:ticket_plane_app/screen/discount_detail/discount_detail_screen.dart';
import '../search/search_screen.dart';

// Import các class từ thư mục data
import 'data/discount.dart';
import 'data/flight.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userId;
  String? userName;
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadHomeData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.status == HomeStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.errorMessage}'),
                ),
              );
          }
          if (state.status == HomeStatus.loading) {
            Center(child: CircularProgressIndicator());
          }
        },
        child: Scaffold(
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        Map<String, String> arrivalCityImageMap = {};
        for (var flight in state.flights) {
          if (!arrivalCityImageMap.containsKey(flight.diemDen)) {
            arrivalCityImageMap[flight.diemDen] = flight.arrivalCityImage;
          }
        }
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0D47A1),
                Color(0xFF1976D2),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: state.userImageUrl != null
                                  ? NetworkImage('${state.userImageUrl!}')
                                  : const AssetImage(
                                          'images/default_avatar.png')
                                      as ImageProvider,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Xin chào 👋',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                state.userName ?? userId ?? "username",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),

                // Welcome Text
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Bạn muốn\nđi đâu?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Search Box
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const SearchScreen()),
                      // );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search),
                          SizedBox(width: 10),
                          Text(
                            'Tìm kiếm chuyến bay',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Body Content
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),

                            // Banner Khuyến mãi (Khám phá)
                            const Text(
                              'Khuyến mãi',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // SizedBox(
                            //   height: 100,
                            //   child: ListView.builder(
                            //     scrollDirection: Axis.horizontal,
                            //     itemCount: state.discounts.length,
                            //     itemBuilder: (context, index) {
                            //       return _buildDestinationBanner(
                            //         state.discounts[index].moTa,
                            //         state.discounts[index]
                            //             .anh, // Thay đổi URL hình ảnh
                            //         '${(state.discounts[index].phanTramGiam * 100).toStringAsFixed(0)}%',
                            //       );
                            //     },
                            //   ),
                            // ),
                            SizedBox(
                              height: 120, // Điều chỉnh height cho phù hợp
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.discounts.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DiscountDetailScreen(
                                            discountId:
                                                state.discounts[index].id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: _buildDestinationBanner(
                                      state.discounts[index].moTa,
                                      state.discounts[index].anh,
                                      '${(state.discounts[index].phanTramGiam * 100).toStringAsFixed(0)}%',
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Điểm đến
                            const Text(
                              'Điểm đến',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.arrivalCities.length,
                                itemBuilder: (context, index) {
                                  // Lấy hình ảnh từ arrivalCityImageMap, nếu không có thì dùng ảnh default
                                  final imageUrl = arrivalCityImageMap[
                                          state.arrivalCities[index]] ??
                                      'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1287&q=80';
                                  return _buildDestinationCard(
                                    state.arrivalCities[index],
                                    imageUrl,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Các chuyến bay (Gợi ý chuyến bay)
                            const Text(
                              'Gợi ý chuyến bay',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: List.generate(
                                state.flights.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: _buildFlightItem(state.flights[index]),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDestinationBanner(
      String destination, String imageUrl, String promo) {
    return Container(
        width: 250,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent])),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  promo,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildFlightItem(Flight flight) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FlightScreen(flightId: flight.flightId),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Hình ảnh chuyến bay
              Image.network(
                flight.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error); // Placeholder khi lỗi
                },
              ),
              const SizedBox(
                  width: 10), // Khoảng cách giữa hình ảnh và thông tin
              Expanded(
                // Sử dụng Expanded để tránh tràn
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${flight.diemDi} - ${flight.diemDen} ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis, // Xử lý tràn chữ
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${flight.thoiGianDi.day}/${flight.thoiGianDi.month}/${flight.thoiGianDi.year}',
                    ),
                  ],
                ),
              ),
              const SizedBox(
                  width: 10), // Khoảng cách giữa thông tin và hãng bay
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(flight.tenCB),
                  const SizedBox(height: 4),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildDestinationCard(String title, String imageUrl) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DestinationScreen(
                destination: title,
                flights: context.read<HomeBloc>().state.flights,
              ),
            ),
          );
        },
        child: Container(
          width: 200,
          height: 150,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
