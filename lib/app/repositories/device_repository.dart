import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sensory_alarm/app/model/device.dart';
import 'package:sensory_alarm/app/model/device_event.dart';
import 'package:uuid/uuid.dart';

class DeviceRepository {
  Future addDevice({required String userId, required String deviceName}) async {
    try {
      final uuid = Uuid();
      final deviceId = uuid.v4();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('devices')
          .doc(deviceId)
          .set({
        'name': deviceName,
      });
    } catch (_) {
      rethrow;
    }
  }

  Stream<List<Device>> getDevicesStream(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('devices')
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Device> devices = [];

      for (final QueryDocumentSnapshot doc in snapshot.docs) {
        devices.add(Device.fromSnapshot(doc));
      }

      return devices;
    });
  }

  Stream<List<DeviceEvent>> getMessagesStream(String userId, String deviceId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('devices')
        .doc(deviceId)
        .collection('events')
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<DeviceEvent> messages = [];

      for (final QueryDocumentSnapshot doc in snapshot.docs) {
        messages.add(DeviceEvent.fromSnapshot(doc));
      }

      return messages;
    });
  }
}
