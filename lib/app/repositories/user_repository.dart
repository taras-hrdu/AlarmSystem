import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sensory_alarm/app/model/user.dart';

class UserRepository {
  Future<User?> getUserData(String userId) async {
    final DocumentSnapshot document =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (document.exists) {
      return User.fromSnapshot(document);
    }

    return null;
  }
}
