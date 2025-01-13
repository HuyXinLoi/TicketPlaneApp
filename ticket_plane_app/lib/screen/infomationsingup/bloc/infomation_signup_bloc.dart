import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_plane_app/screen/infomationsingup/data/user_info_repository.dart';
import 'package:ticket_plane_app/screen/infomationsingup/data/user_information.dart';

part 'infomation_signup_event.dart';
part 'infomation_signup_state.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  final UserInfoRepository _userInfoRepository;
  final String userId;

  UserInfoBloc(
      {required UserInfoRepository userInfoRepository, required this.userId})
      : _userInfoRepository = userInfoRepository,
        super(UserInfoState()) {
    on<UserInfoNameChanged>(_onNameChanged);
    on<UserInfoPhoneNumberChanged>(_onPhoneNumberChanged);
    on<UserInfoAddressChanged>(_onAddressChanged);
    on<UserInfoGenderChanged>(_onGenderChanged);
    on<UserInfoPassportChanged>(_onPassportChanged);
    on<UserInfoDateOfBirthChanged>(_onDateOfBirthChanged);
    on<UserInfoSubmitted>(_onSubmitted);
  }
  void _onNameChanged(UserInfoNameChanged event, Emitter<UserInfoState> emit) {
    emit(state.copyWith(name: event.name, status: UserInfoStatus.initial));
  }

  void _onPhoneNumberChanged(
      UserInfoPhoneNumberChanged event, Emitter<UserInfoState> emit) {
    emit(state.copyWith(
        phoneNumber: event.phoneNumber, status: UserInfoStatus.initial));
  }

  void _onAddressChanged(
      UserInfoAddressChanged event, Emitter<UserInfoState> emit) {
    emit(
        state.copyWith(address: event.address, status: UserInfoStatus.initial));
  }

  void _onGenderChanged(
      UserInfoGenderChanged event, Emitter<UserInfoState> emit) {
    emit(state.copyWith(gender: event.gender, status: UserInfoStatus.initial));
  }

  void _onPassportChanged(
      UserInfoPassportChanged event, Emitter<UserInfoState> emit) {
    emit(state.copyWith(
        passport: event.passport, status: UserInfoStatus.initial));
  }

  void _onDateOfBirthChanged(
      UserInfoDateOfBirthChanged event, Emitter<UserInfoState> emit) {
    emit(state.copyWith(
        dateOfBirth: event.dateOfBirth, status: UserInfoStatus.initial));
  }

  void _onSubmitted(
      UserInfoSubmitted event, Emitter<UserInfoState> emit) async {
    emit(state.copyWith(status: UserInfoStatus.loading));

    if (state.name.isEmpty) {
      emit(state.copyWith(
          status: UserInfoStatus.failure,
          errorMessage: 'Bạn không có tên sao ?'));
      return;
    }

    if (state.phoneNumber.isEmpty) {
      emit(state.copyWith(
          status: UserInfoStatus.failure,
          errorMessage: 'Bạn không có số điện thoại à ?'));
      return;
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(state.phoneNumber) ||
        state.phoneNumber.length < 9) {
      emit(state.copyWith(
          status: UserInfoStatus.failure,
          errorMessage: 'Vui lòng nhập đúng định dạng số điện thoại!'));
      return;
    }

    if (state.address.isEmpty) {
      emit(state.copyWith(
          status: UserInfoStatus.failure,
          errorMessage: 'Bạn vô gia cư hả à ?'));
      return;
    }

    if (state.gender.isEmpty) {
      emit(state.copyWith(
          status: UserInfoStatus.failure,
          errorMessage: 'Vui Lòng Nhập Giới Tính!'));
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final email = prefs.getString('email');
      final userInfo = UserInfo(
          name: state.name,
          phoneNumber: state.phoneNumber,
          address: state.address,
          gender: state.gender,
          passport: state.passport,
          dateOfBirth: state.dateOfBirth,
          urlImage: '',
          userId: userId!,
          email: email);
      await _userInfoRepository.saveUserInfo(userInfo, userId);
      emit(state.copyWith(status: UserInfoStatus.success));
      await Future.delayed(Duration(seconds: 3));
    } catch (e) {
      emit(state.copyWith(
        status: UserInfoStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
