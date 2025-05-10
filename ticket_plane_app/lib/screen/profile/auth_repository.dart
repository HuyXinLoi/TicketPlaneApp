import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthRepository();

  Future<void> signOut() async {
    try {
      // Đăng xuất khỏi Firebase
      await _firebaseAuth.signOut();
    } catch (e) {
      print("Error during sign out: $e");
      // Có thể bạn muốn rethrow lỗi để cấp trên xử lý
      throw e;
    }
  }
}