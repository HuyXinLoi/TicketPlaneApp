import 'package:cloud_firestore/cloud_firestore.dart';

class Flight {
  final String flightId;
  final String diemDi;
  final String diemDen;
  final String image;
  final String arrivalCityImage;
  final String moTa;
  final int soGhe;
  final String soGheTrong;
  final String tenCB;
  final DateTime thoiGianDen;
  final DateTime thoiGianDi;

  Flight({
    required this.flightId,
    required this.diemDi,
    required this.diemDen,
    required this.image,
    required this.arrivalCityImage,
    required this.moTa,
    required this.soGhe,
    required this.soGheTrong,
    required this.tenCB,
    required this.thoiGianDen,
    required this.thoiGianDi,
  });

  // Factory constructor để tạo Flight object từ Firestore DocumentSnapshot
  factory Flight.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Flight(
      flightId: snapshot.id,
      diemDi: data!['DiemDi'],
      diemDen: data['DiemDen'],
      image: data['HinhAnhChuyenBay'],
      arrivalCityImage: data['HinhAnhDiemDen'],
      moTa: data['MoTa'],
      soGhe: int.parse(data['SoGhe']),
      soGheTrong: data['SoGheTrong'],
      tenCB: data['TenCB'],
      thoiGianDen: (data['ThoiGianDen'] as Timestamp).toDate(),
      thoiGianDi: (data['ThoiGianDi'] as Timestamp).toDate(),
    );
  }

  // Method để convert Flight object sang Map<String, dynamic> (ít dùng hơn)
  Map<String, dynamic> toMap() {
    return {
      'DiemDi': diemDi,
      'DiemDen': diemDen,
      'HinhAnhChuyenBay': image,
      'HinhAnhDiemDen': arrivalCityImage,
      'MoTa': moTa,
      'SoGhe': soGhe.toString(),
      'SoGheTrong': soGheTrong,
      'TenCB': tenCB,
      'ThoiGianDen': Timestamp.fromDate(thoiGianDen),
      'ThoiGianDi': Timestamp.fromDate(thoiGianDi),
    };
  }
}
