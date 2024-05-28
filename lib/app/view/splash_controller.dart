import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensory_alarm/app/utils/fonts.dart';
import 'package:sensory_alarm/features/auth/cubit/auth_cubit.dart';

class SplashController extends StatefulWidget {
  const SplashController({super.key});

  static const String routeName = '/';

  @override
  State<SplashController> createState() => _SplashControllerState();
}

class _SplashControllerState extends State<SplashController> {
  @override
  void initState() {
    super.initState();

    context.read<AuthCubit>().init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.amberAccent,
      body: Center(child: Text('Sensory alarm', style: AppFonts.header)),
    );
  }
}
