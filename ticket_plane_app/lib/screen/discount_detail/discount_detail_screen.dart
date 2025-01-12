import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ticket_plane_app/screen/discount_detail/bloc/discount_detail_bloc.dart';
import 'package:ticket_plane_app/screen/discount_detail/bloc/discount_detail_event.dart';
import 'package:ticket_plane_app/screen/discount_detail/bloc/discount_detail_state.dart';

class DiscountDetailScreen extends StatelessWidget {
  final String discountId; // Thêm tham số discountId

  const DiscountDetailScreen({
    Key? key,
    required this.discountId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DiscountDetailBloc()..add(LoadDiscountDetail(discountId)),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<DiscountDetailBloc, DiscountDetailState>(
            builder: (context, state) {
              return Text(state.discountDetail?.title ?? '');
            },
          ),
        ),
        body: BlocBuilder<DiscountDetailBloc, DiscountDetailState>(
          builder: (context, state) {
            if (state.status == DiscountDetailStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == DiscountDetailStatus.success) {
              final discountDetail = state.discountDetail!;
              final formattedThoiGianBatDau =
                  "${discountDetail.thoiGianBatDau.day}/${discountDetail.thoiGianBatDau.month}/${discountDetail.thoiGianBatDau.year}";
              final formattedThoiGianKetThuc =
                  "${discountDetail.thoiGianKetThuc.day}/${discountDetail.thoiGianKetThuc.month}/${discountDetail.thoiGianKetThuc.year}";
              final String content = """
                ${discountDetail.htmlContent}
                <p><b>Phạm vi áp dụng:</b> ${discountDetail.phamVi}</p>
                <p><b>Thời gian bắt đầu:</b> $formattedThoiGianBatDau</p>
                <p><b>Thời gian kết thúc:</b> $formattedThoiGianKetThuc</p>
                <p><b>Mã giảm giá:</b> ${discountDetail.code}</p>
              """;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Image.network(
                      discountDetail.imageUrl,
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
                            // textAlign: TextAlign.justify,
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
              );
            } else if (state.status == DiscountDetailStatus.failure) {
              return Center(child: Text(state.errorMessage ?? 'Error'));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
