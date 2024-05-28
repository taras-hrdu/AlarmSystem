import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensory_alarm/features/devices/cubit/device_cubit.dart';

class AddDevicePopup extends StatefulWidget {
  @override
  _AddDevicePopupState createState() => _AddDevicePopupState();
}

class _AddDevicePopupState extends State<AddDevicePopup> {
  BluetoothConnection? connection;
  bool get isConnected {
    return connection != null && connection!.isConnected;
  }

  TextEditingController ssidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Connection'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isConnected)
              TextField(
                controller: ssidController,
                decoration: InputDecoration(labelText: 'Wi-Fi SSID'),
              ),
            if (isConnected)
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Wi-Fi Password'),
              ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: isConnected ? _sendData : _connectBluetooth,
              child: Text(isConnected ? 'Send Data' : 'Connect Bluetooth'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _connectBluetooth() async {
    BluetoothDevice selectedDevice = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SelectBluetoothDevicePage()),
    );

    if (selectedDevice != null) {
      BluetoothConnection newConnection =
          await BluetoothConnection.toAddress(selectedDevice.address);
      setState(() {
        connection = newConnection;
      });
    }
  }

  void _sendData() {
    String ssid = ssidController.text;
    String password = passwordController.text;
    String data = '$ssid,$password\n';

    if (connection != null) {
      connection!.output.add(Uint8List.fromList(data.codeUnits));
      connection!.output.allSent.then((_) {
        print('Data sent: $data');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SetDeviceInfoPage()),
        );
      }).catchError((error) {
        print('Error sending data: $error');
      });
    }
  }

  @override
  void dispose() {
    if (isConnected) {
      connection?.dispose();
    }
    super.dispose();
  }
}

class SelectBluetoothDevicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Bluetooth Device'),
      ),
      body: FutureBuilder<List<BluetoothDevice>>(
        future: FlutterBluetoothSerial.instance.getBondedDevices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else {
            List<BluetoothDevice>? devices = snapshot.data;
            return ListView.builder(
              itemCount: devices?.length ?? 0,
              itemBuilder: (context, index) {
                BluetoothDevice? device = devices?[index];
                return ListTile(
                  title: Text(device?.name ?? ''),
                  subtitle: Text(device?.address ?? ''),
                  onTap: () {
                    if (device != null) {
                      Navigator.of(context).pop(device);
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class SetDeviceInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set device info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Device Name'),
              onChanged: (String value) =>
                  context.read<DeviceCubit>().changeName(value),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                context.read<DeviceCubit>().addDevice();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
