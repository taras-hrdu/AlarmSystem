part of 'user_cubit.dart';

class UserState extends Equatable {
  final User? user;
  final bool isLoading;

  const UserState({this.user, this.isLoading = false});

  @override
  List<Object?> get props => [user, isLoading];

  UserState copyWith({User? user, bool? isLoading}) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
