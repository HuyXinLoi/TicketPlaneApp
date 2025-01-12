import 'package:cloud_firestore/cloud_firestore.dart';

class Flight {
  final String flightId;
  final String diemDi;
  final String diemDen;
  final Timestamp thoiGianDi;
  final Timestamp thoiGianDen;
  final String tenChuyenBay;
  final String hinhAnhChuyenBay;
  final String hinhAnhDiemDen;
  final String soGhe;
  final String soGheTrong;

  Flight(
      {required this.flightId,
      required this.diemDi,
      required this.diemDen,
      required this.thoiGianDi,
      required this.thoiGianDen,
      required this.tenChuyenBay,
      required this.hinhAnhChuyenBay,
      required this.hinhAnhDiemDen,
      required this.soGhe,
      required this.soGheTrong});

  factory Flight.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Flight(
        flightId: doc.id,
        diemDi: data['DiemDi'] ?? '',
        diemDen: data['DiemDen'] ?? '',
        thoiGianDi: data['ThoiGianDi'] ?? Timestamp.now(),
        thoiGianDen: data['ThoiGianDen'] ?? Timestamp.now(),
        tenChuyenBay: data['TenCB'] ?? '',
        hinhAnhChuyenBay: data['HinhAnhChuyenBay'] ?? '',
        hinhAnhDiemDen: data['HinhAnhDiemDen'] ?? '',
        soGhe: data['SoGhe'] ?? '',
        soGheTrong: data['SoGheTrong'] ?? '');
  }
}
