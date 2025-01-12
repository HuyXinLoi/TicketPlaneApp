import 'package:cloud_firestore/cloud_firestore.dart';

class DiscountDetail {
  final String title;
  final String imageUrl;
  final String htmlContent;
  final String phamVi;
  final DateTime thoiGianBatDau;
  final DateTime thoiGianKetThuc;
  final String code;

  DiscountDetail({
    required this.title,
    required this.imageUrl,
    required this.htmlContent,
    required this.phamVi,
    required this.thoiGianBatDau,
    required this.thoiGianKetThuc,
    required this.code,
  });

  // Factory constructor to create a DiscountDetail object from Firestore data
  factory DiscountDetail.fromFirestore(Map<String, dynamic> data) {
    return DiscountDetail(
      title: data['MoTa'] ?? '',
      imageUrl: data['Anh'] ?? '',
      htmlContent: data['MoTaGiamGia'] ?? '',
      phamVi: data['PhamVi'] ?? '',
      thoiGianBatDau: (data['ThoiGianBatDau'] as Timestamp).toDate(),
      thoiGianKetThuc: (data['ThoiGianKetThuc'] as Timestamp).toDate(),
      code: data['Code'] ?? '',
    );
  }
}
