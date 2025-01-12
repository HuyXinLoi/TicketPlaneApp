import 'package:cloud_firestore/cloud_firestore.dart';

class Discount {
  final String id;
  final String moTa;
  final double phanTramGiam;
  final String tinhTrang;
  final bool enable;
  final String anh; // Thêm trường ảnh
  final String moTaChiTiet; // Thêm trường htmlContent
  final String phamVi;
  final DateTime thoiGianBatDau;
  final DateTime thoiGianKetThuc;

  Discount({
    required this.id,
    required this.moTa,
    required this.phanTramGiam,
    required this.tinhTrang,
    required this.enable,
    required this.anh, // Thêm vào constructor
    required this.moTaChiTiet, // Thêm vào constructor
    required this.phamVi,
    required this.thoiGianBatDau,
    required this.thoiGianKetThuc,
  });

  factory Discount.fromFirestore(Map<String, dynamic> data, String id) {
    return Discount(
      id: id,
      moTa: data['MoTa'] ?? '',
      phanTramGiam: (data['PhanTramGiam'] ?? 0.0).toDouble(),
      tinhTrang: data['TinhTrang'] ?? '',
      enable: data['enable'] ?? false,
      anh: data['Anh'] ?? '', // Thêm trường ảnh
      moTaChiTiet: data['MoTaGiamGia'] ?? '', // Lấy từ Firestore
      phamVi: data['PhamVi'] ?? '',
      thoiGianBatDau: (data['ThoiGianBatDau'] as Timestamp)
          .toDate(), // Convert Timestamp to DateTime
      thoiGianKetThuc: (data['ThoiGianKetThuc'] as Timestamp)
          .toDate(), // Convert Timestamp to DateTime
    );
  }
}
