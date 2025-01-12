import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticket_plane_app/screen/destination/bloc/destination_event.dart';
import 'package:ticket_plane_app/screen/destination/bloc/destination_state.dart';
import 'package:ticket_plane_app/screen/destination/data/destination.dart';

class DestinationBloc extends Bloc<DestinationEvent, DestinationState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DestinationBloc() : super(const DestinationState()) {
    on<LoadDestinations>(_onLoadDestinations);
  }

  Future<void> _onLoadDestinations(
      LoadDestinations event, Emitter<DestinationState> emit) async {
    emit(state.copyWith(status: DestinationStatus.loading));
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('flight').get();
      List<Destination> destinations = [];
      Map<String, String> uniqueDestinations =
          {}; // Map để theo dõi các điểm đến duy nhất

      for (var doc in querySnapshot.docs) {
        String diemDen = doc.get('DiemDen');
        String hinhAnhDiemDen = doc.get('HinhAnhDiemDen');

        // Kiểm tra xem đã thêm điểm đến này chưa
        if (!uniqueDestinations.containsKey(diemDen)) {
          uniqueDestinations[diemDen] =
              hinhAnhDiemDen; // Lưu hình ảnh cho điểm đến duy nhất
          destinations
              .add(Destination(name: diemDen, imageUrl: hinhAnhDiemDen));
        }
      }
      emit(state.copyWith(
          status: DestinationStatus.success, destinations: destinations));
    } catch (e) {
      emit(state.copyWith(
          status: DestinationStatus.failure,
          errorMessage: "Lỗi khi tải điểm đến: ${e.toString()}"));
    }
  }
}
