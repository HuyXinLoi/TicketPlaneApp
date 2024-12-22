import 'package:flutter/material.dart';
import 'package:ticket_plane_app/units/api_service.dart';
import '../search/search_screen.dart';

// Import các class từ thư mục data
import 'data/discount.dart';
import 'data/flight.dart';
import 'data/popular_destination.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Dữ liệu
  List<Discount> discounts = [];
  List<Flight> flights = [];
  List<PopularDestination> popularDestinations = [];

  // Khởi tạo ApiService
  final apiService = ApiService('http://10.0.2.2:3000');

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Lấy danh sách discounts
      final discountsList = (await apiService.getDiscounts())
          .map((item) => Discount.fromJson(item))
          .toList();

      // Lấy danh sách flights
      final flightsList = (await apiService.getFlights())
          .map((item) => Flight.fromJson(item))
          .toList();

      // Lấy danh sách popular destinations
      final popularDestinationsList =
          (await apiService.getPopularDestinations())
              .map((item) => PopularDestination.fromJson(item))
              .toList();

      // Cập nhật state
      setState(() {
        discounts = discountsList;
        flights = flightsList.sublist(0, 3);
        popularDestinations = popularDestinationsList;
      });
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => const ProfileScreen()),
                            // );
                          },
                          child: const CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1287&q=80'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Xin chào 👋',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              // "${currentCustomer.firstName} ${currentCustomer.lastName}",
                              "username",
                              style: TextStyle(
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
                            'Khám phá',
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
                              itemCount: discounts.length,
                              itemBuilder: (context, index) {
                                return _buildDestinationBanner(
                                  discounts[index].description,
                                  'https://via.placeholder.com/250x150?text=Promo+${index + 1}', // Thay bằng ảnh thực tế
                                  '${discounts[index].discountPercentage}% OFF',
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Điểm đến phổ biến
                          const Text(
                            'Điểm đến phổ biến',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: 1.5,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            children: List.generate(
                              popularDestinations.length,
                              (index) => _buildDestinationCard(
                                popularDestinations[index].name,
                                popularDestinations[index].image,
                              ),
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
                              flights.length,
                              (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: _buildFlightItem(flights[index]),
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
      ),
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
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${flight.departureCity} (${flight.departureCity.substring(0, 3).toUpperCase()}) - ${flight.arrivalCity} (${flight.arrivalCity.substring(0, 3).toUpperCase()})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${flight.departureTime.day}/${flight.departureTime.month}/${flight.departureTime.year}',
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Image.network(
              //   'https://via.placeholder.com/50x50?text=${flight.airline.substring(0, 2).toUpperCase()}', // Thay bằng logo hãng
              //   width: 30,
              //   height: 30,
              // ),
              Text(flight.airline),
              const SizedBox(height: 4),
              Text('${flight.price.toStringAsFixed(0)} VND',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF1976D2))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationCard(String title, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            imageUrl,
            height: 60,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
