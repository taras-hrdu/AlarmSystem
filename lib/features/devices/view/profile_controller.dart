import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensory_alarm/features/auth/cubit/user/user_cubit.dart';

class ProfileController extends StatefulWidget {
  const ProfileController({super.key});

  static const String routeName = '/profile';

  @override
  State<ProfileController> createState() => _ProfileControllerState();
}

class _ProfileControllerState extends State<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      return Container(
          child: Column(
        children: [
          Text(state.user!.userId),
          Text(state.user!.email),
        ],
      ));
    });
  }
}
