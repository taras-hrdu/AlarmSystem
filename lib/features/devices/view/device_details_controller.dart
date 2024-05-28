import 'package:flutter/material.dart';
import 'package:sensory_alarm/app/model/device.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensory_alarm/features/devices/cubit/device_cubit.dart';
import 'package:sensory_alarm/features/devices/widgets/audio_player_widget.dart';

class DeviceDetailsController extends StatefulWidget {
  final Device device;

  const DeviceDetailsController({Key? key, required this.device})
      : super(key: key);

  @override
  State<DeviceDetailsController> createState() =>
      _DeviceDetailsControllerState();
}

class _DeviceDetailsControllerState extends State<DeviceDetailsController> {
  @override
  void initState() {
    super.initState();

    context.read<DeviceCubit>().initMessageStream(widget.device.deviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange, title: Text(widget.device.name)),
      body: BlocBuilder<DeviceCubit, DeviceState>(builder: (context, state) {
        if (state.messages.isEmpty) {
          return Center(
            child: Text('No device info yet'),
          );
        } else {
          return ListView.builder(
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final message = state.messages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  // title: Text('${index + 1} ${message.message}'),
                  child: AudioPlayerWidget(audioUrl: message.audioUrl),
                );
              });
        }
      }),
    );
  }
}
