import 'package:ticket_plane_app/screen/infomationsingup/data/firebase_service.dart';
import 'package:ticket_plane_app/screen/infomationsingup/data/user_information.dart';

class UserInfoRepository {
  final FirebaseService _firebaseService;

  UserInfoRepository({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService();

  Future<void> saveUserInfo(UserInfo userInfo, String userId) async {
    try {
      await _firebaseService.addUserInfo(userInfo, userId);
    } catch (e) {
      rethrow;
    }
  }
}
