import 'package:equatable/equatable.dart';
import 'package:ticket_plane_app/screen/discount_detail/data/discount_detail.dart';

enum DiscountDetailStatus { initial, loading, success, failure }

class DiscountDetailState extends Equatable {
  final DiscountDetailStatus status;
  final DiscountDetail? discountDetail;
  final String? errorMessage;

  const DiscountDetailState({
    this.status = DiscountDetailStatus.initial,
    this.discountDetail,
    this.errorMessage,
  });

  DiscountDetailState copyWith({
    DiscountDetailStatus? status,
    DiscountDetail? discountDetail,
    String? errorMessage,
  }) {
    return DiscountDetailState(
      status: status ?? this.status,
      discountDetail: discountDetail ?? this.discountDetail,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, discountDetail, errorMessage];
}
