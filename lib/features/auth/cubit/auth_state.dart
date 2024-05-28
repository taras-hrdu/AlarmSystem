part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final String email;
  final String password;
  final AuthStatus status;
  final RequestStatus requestStatus;
  final String? errorMessage;

  const AuthState(
      {this.email = '',
      this.password = '',
      this.status = AuthStatus.initial,
      this.requestStatus = RequestStatus.initial,
      this.errorMessage});

  @override
  List<Object?> get props =>
      [email, password, status, errorMessage, requestStatus];

  AuthState copyWith(
      {String? email,
      String? password,
      AuthStatus? status,
      RequestStatus? requestStatus,
      String? errorMessage}) {
    return AuthState(
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
        requestStatus: requestStatus ?? this.requestStatus,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}

enum AuthStatus { initial, authenticated, unauthenticated, unverified }

enum RequestStatus { initial, loading, success, error }
