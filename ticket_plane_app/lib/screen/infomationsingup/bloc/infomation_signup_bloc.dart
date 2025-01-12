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
    emit(state.copyWith(name: event.name));
  }

  void _onPhoneNumberChanged(
      UserInfoPhoneNumberChanged event, Emitter<UserInfoState> emit) {
    emit(state.copyWith(phoneNumber: event.phoneNumber));
  }

  void _onAddressChanged(
      UserInfoAddressChanged event, Emitter<UserInfoState> emit) {
    emit(state.copyWith(address: event.address));
  }

  void _onGenderChanged(
      UserInfoGenderChanged event, Emitter<UserInfoState> emit) {
    emit(state.copyWith(gender: event.gender));
  }

  void _onPassportChanged(
      UserInfoPassportChanged event, Emitter<UserInfoState> emit) {
    emit(state.copyWith(passport: event.passport));
  }

  void _onDateOfBirthChanged(
      UserInfoDateOfBirthChanged event, Emitter<UserInfoState> emit) {
    emit(state.copyWith(dateOfBirth: event.dateOfBirth));
  }

  void _onSubmitted(
      UserInfoSubmitted event, Emitter<UserInfoState> emit) async {
    emit(state.copyWith(status: UserInfoStatus.loading));

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
    } catch (e) {
      emit(state.copyWith(
        status: UserInfoStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
