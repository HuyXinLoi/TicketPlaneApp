// import 'package:flutter/material.dart';
// // import 'package:qr_flutter/qr_flutter.dart';

// class TicketScreen extends StatelessWidget {
//   const TicketScreen({super.key});

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
//                         Navigator.pop(
//                             context); // Go back to the previous screen
//                       },
//                       icon: const Icon(
//                         Icons.arrow_back,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                     const Text(
//                       'Vé máy bay',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(
//                         width: 48), // Placeholder to center the title
//                   ],
//                 ),
//               ),

//               // Ticket Card
//               Expanded(
//                 child: Center(
//                   child: Container(
//                     margin: const EdgeInsets.all(20.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: SingleChildScrollView(
//                       // Make content scrollable if needed
//                       child: Column(
//                         children: [
//                           // Airline and Flight Details
//                           Padding(
//                             padding: const EdgeInsets.all(20.0),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Image.network(
//                                       'https://via.placeholder.com/80x40?text=VN+Logo', // Replace with actual airline logo
//                                       width: 80,
//                                     ),
//                                     const Text(
//                                       'VN247', // Flight number
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 20),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: const [
//                                     Text('Hà Nội (HAN)',
//                                         style: TextStyle(fontSize: 16)),
//                                     Icon(Icons.flight_takeoff),
//                                     Text('Hồ Chí Minh (SGN)',
//                                         style: TextStyle(fontSize: 16)),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 5),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: const [
//                                     Text('15/12/2023',
//                                         style: TextStyle(color: Colors.grey)),
//                                     Text('1h 50m',
//                                         style: TextStyle(color: Colors.grey)),
//                                     Text('16/12/2023',
//                                         style: TextStyle(color: Colors.grey)),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 5),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: const [
//                                     Text('8:00 AM',
//                                         style: TextStyle(color: Colors.grey)),
//                                     Text('9:50 AM',
//                                         style: TextStyle(color: Colors.grey)),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),

//                           // Dotted Separator
//                           const Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 20.0),
//                             child: Divider(
//                               color: Colors.grey,
//                             ),
//                           ),
//                           // const SizedBox(height: 1),

//                           // Passenger Details
//                           Padding(
//                             padding: const EdgeInsets.all(20.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'Hành khách',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 10),
//                                 const Text('Shaidul Islam'),
//                                 const SizedBox(height: 20),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: const [
//                                     Text('Ghế',
//                                         style: TextStyle(color: Colors.grey)),
//                                     Text('Loại vé',
//                                         style: TextStyle(color: Colors.grey)),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 5),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: const [
//                                     Text('24A',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold)),
//                                     Text('Phổ thông',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold)),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),

//                           // QR Code
//                           // Center(
//                           //   child: Padding(
//                           //     padding: const EdgeInsets.all(20.0),
//                           //     child: QrImageView(
//                           //       data:
//                           //           'YOUR_BOOKING_DATA', // Replace with actual booking data
//                           //       version: QrVersions.auto,
//                           //       size: 200.0,
//                           //     ),
//                           //   ),
//                           // ),
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
// }
