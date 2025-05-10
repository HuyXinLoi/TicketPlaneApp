import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticket_plane_app/screen/discount_detail/bloc/discount_detail_event.dart';
import 'package:ticket_plane_app/screen/discount_detail/bloc/discount_detail_state.dart';
import 'package:ticket_plane_app/screen/discount_detail/data/discount_detail.dart';

class DiscountDetailBloc
    extends Bloc<DiscountDetailEvent, DiscountDetailState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DiscountDetailBloc() : super(const DiscountDetailState()) {
    on<LoadDiscountDetail>(_onLoadDiscountDetail);
  }

  Future<void> _onLoadDiscountDetail(
      LoadDiscountDetail event, Emitter<DiscountDetailState> emit) async {
    emit(state.copyWith(status: DiscountDetailStatus.loading));
    try {
      DocumentSnapshot discountDoc =
          await _firestore.collection('discount').doc(event.discountId).get();

      if (discountDoc.exists) {
        DiscountDetail discountDetail = DiscountDetail.fromFirestore(
            discountDoc.data() as Map<String, dynamic>);
        emit(state.copyWith(
          status: DiscountDetailStatus.success,
          discountDetail: discountDetail,
        ));
      } else {
        emit(state.copyWith(
          status: DiscountDetailStatus.failure,
          errorMessage: 'Discount not found.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: DiscountDetailStatus.failure,
        errorMessage: 'Error loading discount: ${e.toString()}',
      ));
    }
  }
}
