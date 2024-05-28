import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensory_alarm/app/model/user.dart';
import 'package:sensory_alarm/app/repositories/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({required this.repository}) : super(const UserState());

  final UserRepository repository;

  Future<void> getUserData() async {
    emit(state.copyWith(isLoading: true));

    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      User? user = await repository.getUserData(userId);

      emit(state.copyWith(user: user));
    }

    emit(state.copyWith(
      isLoading: false,
    ));
  }
}
