// import 'package:flutter/material.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   // // Dữ liệu mẫu từ JSON
//   // final List<dynamic> jsonData = [
//   //   // ... (dữ liệu JSON của bạn ở đây)
//   // ];

//   // Danh sách các thành phố (điểm đi, điểm đến)
//   List<String> get cities {
//     Set<String> citySet = {};
//     searchData['flights'].forEach((flight) {
//       citySet.add(flight['departure_city']);
//       citySet.add(flight['arrival_city']);
//     });
//     return citySet.toList();
//   }

//   // Các biến lưu giá trị đã chọn
//   String? _selectedDepartureCity;
//   String? _selectedArrivalCity;
//   DateTime _selectedDate = DateTime.now();
//   int _adults = 1;
//   int _children = 0;
//   String _selectedClass = 'Phổ thông';

//   // Hàm hiển thị DatePicker
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   // Hàm tìm kiếm chuyến bay (cần implement logic search thực tế)
//   void _searchFlights() {
//     // TODO: Implement search logic based on selected values
//     print('Searching flights...');
//     print('From: $_selectedDepartureCity');
//     print('To: $_selectedArrivalCity');
//     print('Date: $_selectedDate');
//     print('Adults: $_adults, Children: $_children');
//     print('Class: $_selectedClass');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF0D47A1),
//               Color(0xFF1976D2),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: const Icon(Icons.arrow_back, color: Colors.white),
//                     ),
//                     const Text(
//                       'Tìm kiếm',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(width: 48),
//                   ],
//                 ),
//               ),

//               // Book Your Flight
//               const Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text(
//                   'Book Your\nFlight',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 36,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),

//               // Flight Booking Form
//               Expanded(
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Column(
//                         children: [
//                           const SizedBox(height: 20),

//                           // From and To
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text('From'),
//                                     DropdownButtonFormField<String>(
//                                       value: _selectedDepartureCity,
//                                       decoration: const InputDecoration(
//                                         hintText: 'Chọn điểm đi',
//                                       ),
//                                       items: cities
//                                           .map<DropdownMenuItem<String>>(
//                                               (String value) {
//                                         return DropdownMenuItem<String>(
//                                           value: value,
//                                           child: Text(value),
//                                         );
//                                       }).toList(),
//                                       onChanged: (String? newValue) {
//                                         setState(() {
//                                           _selectedDepartureCity = newValue;
//                                         });
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               IconButton(
//                                 onPressed: () {
//                                   // Đổi chỗ điểm đi và điểm đến
//                                   setState(() {
//                                     String? temp = _selectedDepartureCity;
//                                     _selectedDepartureCity =
//                                         _selectedArrivalCity;
//                                     _selectedArrivalCity = temp;
//                                   });
//                                 },
//                                 icon: const Icon(Icons.swap_horiz),
//                               ),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text('To'),
//                                     DropdownButtonFormField<String>(
//                                       value: _selectedArrivalCity,
//                                       decoration: const InputDecoration(
//                                         hintText: 'Chọn điểm đến',
//                                       ),
//                                       items: cities
//                                           .map<DropdownMenuItem<String>>(
//                                               (String value) {
//                                         return DropdownMenuItem<String>(
//                                           value: value,
//                                           child: Text(value),
//                                         );
//                                       }).toList(),
//                                       onChanged: (String? newValue) {
//                                         setState(() {
//                                           _selectedArrivalCity = newValue;
//                                         });
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20),

//                           // Date
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text('Date'),
//                               TextFormField(
//                                 decoration: InputDecoration(
//                                   hintText:
//                                       '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
//                                   suffixIcon: const Icon(Icons.calendar_today),
//                                 ),
//                                 onTap: () => _selectDate(context),
//                                 readOnly: true,
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20),

//                           // Travelers
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text('Hành khách'),
//                               Row(
//                                 children: [
//                                   _buildTravelerCounter('Người lớn', _adults,
//                                       (newValue) {
//                                     setState(() {
//                                       _adults = newValue;
//                                     });
//                                   }),
//                                   const SizedBox(width: 20),
//                                   _buildTravelerCounter('Trẻ em', _children,
//                                       (newValue) {
//                                     setState(() {
//                                       _children = newValue;
//                                     });
//                                   }),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20),

//                           // Class
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text('Class'),
//                               DropdownButtonFormField<String>(
//                                 value: _selectedClass,
//                                 decoration: const InputDecoration(
//                                   hintText: 'Chọn hạng ghế',
//                                 ),
//                                 items: <String>[
//                                   'Phổ thông',
//                                   'Thương gia'
//                                 ].map<DropdownMenuItem<String>>((String value) {
//                                   return DropdownMenuItem<String>(
//                                     value: value,
//                                     child: Text(value),
//                                   );
//                                 }).toList(),
//                                 onChanged: (String? newValue) {
//                                   setState(() {
//                                     _selectedClass = newValue!;
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20),

//                           // Search Flights Button
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF1976D2),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 40, vertical: 15),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                             ),
//                             onPressed: _searchFlights,
//                             child: const Text(
//                               'Search Flights',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTravelerCounter(
//       String label, int value, ValueChanged<int> onChanged) {
//     return Row(
//       children: [
//         Text('$label: '),
//         IconButton(
//           onPressed: () {
//             if (value > 0) {
//               onChanged(value - 1);
//             }
//           },
//           icon: const Icon(Icons.remove),
//         ),
//         Text('$value'),
//         IconButton(
//           onPressed: () {
//             onChanged(value + 1);
//           },
//           icon: const Icon(Icons.add),
//         ),
//       ],
//     );
//   }
// }
