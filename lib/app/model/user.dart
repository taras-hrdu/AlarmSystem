import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.userId,
    required this.email,
  });

  final String userId;
  final String email;

  @override
  List<Object?> get props => [userId, email];

  User copyWith({
    String? userId,
    String? email,
  }) {
    return User(
      userId: userId ?? this.userId,
      email: email ?? this.email,
    );
  }

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    return User(
      userId: snapshot.id,
      email: json['email'],
    );
  }
}
