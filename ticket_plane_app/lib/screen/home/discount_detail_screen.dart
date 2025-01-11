import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DiscountDetailScreen extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String htmlContent;
  final String phamVi;
  final DateTime thoiGianBatDau;
  final DateTime thoiGianKetThuc;

  const DiscountDetailScreen({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.htmlContent,
    required this.phamVi,
    required this.thoiGianBatDau,
    required this.thoiGianKetThuc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedThoiGianBatDau =
        "${thoiGianBatDau.day}/${thoiGianBatDau.month}/${thoiGianBatDau.year}";
    final formattedThoiGianKetThuc =
        "${thoiGianKetThuc.day}/${thoiGianKetThuc.month}/${thoiGianKetThuc.year}";
    final String content = """
      $htmlContent
      <p><b>Phạm vi áp dụng:</b> $phamVi</p>
      <p><b>Thời gian bắt đầu:</b> $formattedThoiGianBatDau</p>
      <p><b>Thời gian kết thúc:</b> $formattedThoiGianKetThuc</p>
    """;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              imageUrl,
              height: 250,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Html(
                data: content,
                style: {
                  "html": Style(
                    fontSize: FontSize.large,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                    textAlign: TextAlign.justify,
                  ),
                  "h1": Style(
                    fontSize: FontSize.xxLarge,
                  ),
                  "p": Style(
                    fontSize: FontSize.medium,
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
