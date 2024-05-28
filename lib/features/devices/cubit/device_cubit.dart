import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sensory_alarm/app/model/device.dart';
import 'package:sensory_alarm/app/model/device_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensory_alarm/app/repositories/device_repository.dart';

part 'device_state.dart';

class DeviceCubit extends Cubit<DeviceState> {
  DeviceCubit({required this.repository}) : super(const DeviceState());

  final DeviceRepository repository;
  StreamSubscription? subscription;

  void initDevicesStream() {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      subscription?.cancel();

      subscription =
          repository.getDevicesStream(userId).listen((List<Device> devices) {
        emit(state.copyWith(
          devices: devices,
        ));
      });
    }
  }

  void initMessageStream(String deviceId) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      subscription?.cancel();

      subscription = repository
          .getMessagesStream(userId, deviceId)
          .listen((List<DeviceEvent> messages) {
        emit(state.copyWith(
          messages: messages,
        ));
      });
    }
  }

  void changeName(String value) {
    emit(state.copyWith(name: value));
  }

  Future<void> addDevice() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        await repository.addDevice(userId: userId, deviceName: state.name);
      }
    } catch (_) {
      rethrow;
    }
  }
}
