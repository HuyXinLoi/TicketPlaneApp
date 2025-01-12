import 'package:equatable/equatable.dart';

abstract class DiscountDetailEvent extends Equatable {
  const DiscountDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadDiscountDetail extends DiscountDetailEvent {
  final String discountId;

  const LoadDiscountDetail(this.discountId);

  @override
  List<Object> get props => [discountId];
}
