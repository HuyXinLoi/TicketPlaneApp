import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticket_plane_app/screen/profile/passenger.dart';

class PassengerRepository {
  final FirebaseFirestore _db =
      FirebaseFirestore.instance; // Initialize FirebaseFirestore

  Future<Passenger> getUserById(String userId) async {
    try {
       print("PassengerRepository - Fetching data from collection: users"); 
      DocumentSnapshot userDoc =
          await _db.collection('passengers').doc(userId).get();
      if (userDoc.exists) {
        return Passenger.fromJson(userDoc.data() as Map<String, dynamic>);
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      print("Failed to get user: $e");
      throw e;
    }
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
  try {
    print("PassengerRepository - Fetching data for userId: $userId");
    DocumentSnapshot userDoc =
        await _db.collection('users').doc(userId).get(); 
    print("PassengerRepository - DocumentSnapshot: ${userDoc.data()}"); // Print the data

    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>?;
      print("PassengerRepository - Returning data: $data");
      return data;
    } else {
      print("PassengerRepository - User data not found for userId: $userId");
      return null;
    }
  } catch (e) {
    print("PassengerRepository - Failed to get user data: $e");
    throw e;
  }
}

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      // Update the user document in Firestore
      await _db.collection('passengers').doc(userId).update(data);

      // If updating email, update it in Firebase Authentication
      if (data.containsKey('email')) {
        User? firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser != null && firebaseUser.uid == userId) {
          await firebaseUser.updateEmail(data['email']);
        }
      }
    } catch (e) {
      print("Failed to update user: $e");
      throw e;
    }
  }
}
