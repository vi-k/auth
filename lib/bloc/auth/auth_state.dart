part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLogin extends AuthState {
  const AuthLogin();
}

class AuthSuccess extends AuthState {
  const AuthSuccess(this.user);

  final AuthUser user;

  @override
  List<Object?> get props => [user];
}
