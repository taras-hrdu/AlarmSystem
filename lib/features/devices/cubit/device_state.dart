part of 'device_cubit.dart';

class DeviceState extends Equatable {
  const DeviceState(
      {this.devices = const [],
      this.messages = const [],
      this.status = Status.initial,
      this.name = ''});

  final List<Device> devices;
  final List<DeviceEvent> messages;
  final Status status;
  final String name;

  @override
  List<Object?> get props => [devices, messages, status, name];

  DeviceState copyWith({
    List<Device>? devices,
    List<DeviceEvent>? messages,
    Status? status,
    String? name,
  }) {
    return DeviceState(
      devices: devices ?? this.devices,
      messages: messages ?? this.messages,
      status: status ?? this.status,
      name: name ?? this.name,
    );
  }
}

enum Status {
  initial,
  loading,
  success,
  error,
}
