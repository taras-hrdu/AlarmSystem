import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensory_alarm/features/auth/cubit/auth_cubit.dart';
import 'package:sensory_alarm/features/auth/cubit/user/user_cubit.dart';
import 'package:sensory_alarm/features/devices/view/devices_controller.dart';
import 'package:sensory_alarm/features/devices/view/profile_controller.dart';
import 'package:sensory_alarm/features/devices/widgets/add_device_popup.dart';

class HomeController extends StatefulWidget {
  const HomeController({super.key});

  static const String routeName = '/home';

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  int tabsIndex = 0;

  Future<void> loadData() async {
    context.read<UserCubit>().getUserData();
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  List tabs = [DevicesController(), ProfileController()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text(tabsIndex == 0 ? 'Devices' : 'Profile'),
          actions: tabsIndex == 1
              ? [
                  IconButton(
                      onPressed: () {
                        context.read<AuthCubit>().signOut();
                      },
                      icon: const Icon(Icons.logout_rounded))
                ]
              : [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddDevicePopup();
                        },
                      );
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
        ),
        drawer: Container(
          width: MediaQuery.of(context).size.width * 0.50,
          child: Drawer(
            child: Container(
              color: Colors.blue,
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('Devices'),
                    textColor: Colors.white,
                    trailing: Icon(
                      Icons.devices,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        tabsIndex = 0;
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Profile'),
                    textColor: Colors.white,
                    trailing: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        tabsIndex = 1;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        body: tabs[tabsIndex]);
  }
}
