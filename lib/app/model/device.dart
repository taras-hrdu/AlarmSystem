import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Device extends Equatable {
  const Device({
    required this.deviceId,
    required this.name,
  });

  final String deviceId;
  final String name;

  @override
  List<Object?> get props => [deviceId, name];

  Device copyWith({
    String? deviceId,
    String? name,
  }) {
    return Device(
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
    );
  }

  factory Device.fromSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    return Device(
      deviceId: snapshot.id,
      name: json['name'],
    );
  }
}
