import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensory_alarm/app/utils/fonts.dart';
import 'package:sensory_alarm/features/auth/cubit/auth_cubit.dart';
import 'package:sensory_alarm/features/auth/view/login_controller.dart';

class RegisterController extends StatelessWidget {
  const RegisterController({super.key});

  static const String routeName = '/register';

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.orange,
              title: const Text('Sensory alarm')),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Welcome to the app', style: AppFonts.header),
                  const SizedBox(height: 20),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: CupertinoTextField(
                      placeholder: 'E-Mail',
                      autocorrect: false,
                      enableSuggestions: false,
                      padding: const EdgeInsets.all(10),
                      onChanged: (String value) =>
                          context.read<AuthCubit>().changeEmail(value),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: CupertinoTextField(
                      placeholder: 'Password',
                      padding: const EdgeInsets.all(10),
                      obscureText: true,
                      onChanged: (String value) =>
                          context.read<AuthCubit>().changePassword(value),
                    ),
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
                    return CupertinoButton.filled(
                        child: state.requestStatus == RequestStatus.loading
                            ? const CupertinoActivityIndicator()
                            : const Text('Sign up'),
                        onPressed: () {
                          context.read<AuthCubit>().signUp();
                        });
                  }),
                  const SizedBox(height: 15),
                  CupertinoButton(
                      child: const Text('Already have an account? Sign in'),
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(LoginController.routeName))
                ],
              ),
            ),
          )),
    );
  }
}
