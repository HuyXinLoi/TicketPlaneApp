import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticket_plane_app/screen/infomationsingup/data/user_information.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUserInfo(UserInfo userInfo, String userId) async {
    try {
      await _firestore
          .collection('passengers')
          .doc(userId)
          .set(userInfo.toMap());
    } catch (e) {
      rethrow;
    }
  }
}
