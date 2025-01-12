import 'package:cloud_firestore/cloud_firestore.dart';

class Flight {
  final String diemDen;
  final String diemDi;
  final String flightId;
  final String soGhe;
  final String soGheTrong;
  final String tenCB;
  final DateTime thoiGianDen;
  final DateTime thoiGianDi;
  final String id;
  final String image; // Hình ảnh chuyến bay
  final String arrivalCityImage; // Hình ảnh điểm đến

  Flight(
      {required this.diemDen,
      required this.diemDi,
      required this.flightId,
      required this.soGhe,
      required this.soGheTrong,
      required this.tenCB,
      required this.thoiGianDen,
      required this.thoiGianDi,
      required this.id,
      required this.image,
      required this.arrivalCityImage});

  factory Flight.fromFirestore(Map<String, dynamic> data, String id) {
    return Flight(
        diemDen: data['DiemDen'] ?? '',
        diemDi: data['DiemDi'] ?? '',
        flightId: data['FlightId'] ?? '',
        soGhe: data['SoGhe'] ?? '',
        soGheTrong: data['SoGheTrong'] ?? '',
        tenCB: data['TenCB'] ?? '',
        thoiGianDen: (data['ThoiGianDen'] as Timestamp).toDate(),
        thoiGianDi: (data['ThoiGianDi'] as Timestamp).toDate(),
        id: id,
        image: data['HinhAnhChuyenBay'] ?? '',
        arrivalCityImage: data['HinhAnhDiemDen'] ?? '');
  }
}
