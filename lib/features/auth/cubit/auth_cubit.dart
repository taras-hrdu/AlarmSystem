import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensory_alarm/features/auth/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.repository) : super(const AuthState());

  final AuthRepository repository;

  void changeEmail(String value) {
    emit(state.copyWith(email: value));
  }

  void changePassword(String value) {
    emit(state.copyWith(password: value));
  }

  Future<void> init() async {
    emit(state.copyWith(status: AuthStatus.initial));

    await Future.delayed(Duration(seconds: 2));

    if (FirebaseAuth.instance.currentUser != null) {
      emit(state.copyWith(status: AuthStatus.authenticated));
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> signUp() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    try {
      await repository.signUp(email: state.email, password: state.password);

      emit(state.copyWith(
          status: AuthStatus.authenticated,
          requestStatus: RequestStatus.success));
    } catch (e) {
      if (e is FirebaseAuthException) {
        emit(state.copyWith(errorMessage: e.message));
      } else {
        emit(state.copyWith(errorMessage: 'Unknown error'));
      }
      emit(
          state.copyWith(requestStatus: RequestStatus.error, errorMessage: ''));
    }
  }

  Future<void> signIn() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    try {
      await repository.signIn(email: state.email, password: state.password);

      emit(state.copyWith(
          status: AuthStatus.authenticated,
          requestStatus: RequestStatus.success));
    } catch (e) {
      emit(
          state.copyWith(requestStatus: RequestStatus.error, errorMessage: ''));
    }
  }

  Future<void> signOut() async {
    await repository.signOut();

    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }
}
