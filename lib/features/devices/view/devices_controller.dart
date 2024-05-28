import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sensory_alarm/features/devices/cubit/device_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensory_alarm/features/devices/view/device_details_controller.dart';

class DevicesController extends StatefulWidget {
  const DevicesController({super.key});

  static const String routeName = '/devices';

  @override
  State<DevicesController> createState() => _DevicesControllerState();
}

class _DevicesControllerState extends State<DevicesController> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance
        .subscribeToTopic(FirebaseAuth.instance.currentUser!.uid);
    print('test_message');

    context.read<DeviceCubit>().initDevicesStream();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceCubit, DeviceState>(builder: (context, state) {
      if (state.devices.isEmpty) {
        return Center(child: Text('No devices added yet'));
      } else {
        return ListView.builder(
            itemCount: state.devices.length,
            itemBuilder: (context, index) {
              final device = state.devices[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DeviceDetailsController(device: device),
                    ),
                  );
                },
                child: Card(
                  child: ListTile(
                    title: Text('${index + 1} ${device.name}'),
                  ),
                ),
              );
            });
      }
    });
  }
}
