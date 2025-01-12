import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticket_plane_app/screen/profile/passenger.dart';

class PassengerRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Passenger?> getUserById(String userId) async {
    if (userId.isEmpty) {
      print("Error: userId is empty.");
      return null;
    }
    try {
      print("Fetching user with ID: $userId");
      DocumentSnapshot doc = await _firestore
          .collection('passengers')
          .doc(userId)
          .get();

      if (doc.exists) {
        print("User found: ${doc.data()}");
        return Passenger.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        print("User not found.");
        return null;
      }
    } catch (e) {
      print("Error getting user: $e");
      return null;
    }
  }

  // Hàm mới để lấy thông tin đầy đủ từ bảng users
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    if (userId.isEmpty) {
      print("Error: userId is empty.");
      return null;
    }
    try {
      print("Fetching user data with ID: $userId");
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        print("User data found: ${doc.data()}");
        return doc.data() as Map<String, dynamic>;
      } else {
        print("User data not found.");
        return null;
      }
    } catch (e) {
      print("Error getting user data: $e");
      return null;
    }
  }
}