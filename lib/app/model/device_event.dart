import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DeviceEvent extends Equatable {
  final String message;
  final String audioUrl;

  const DeviceEvent({required this.message, required this.audioUrl});

  @override
  List<Object?> get props => [message, audioUrl];

  DeviceEvent copyWith({
    String? message,
    String? audioUrl,
  }) {
    return DeviceEvent(
        message: message ?? this.message, audioUrl: audioUrl ?? this.audioUrl);
  }

  factory DeviceEvent.fromSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    return DeviceEvent(
      message: json['message'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
    );
  }
}
