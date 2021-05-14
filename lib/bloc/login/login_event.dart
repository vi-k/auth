part of 'login_bloc_base.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginDataChanged extends LoginEvent {
  const LoginDataChanged({
    this.email,
    this.password,
    this.code,
  });

  final String? email;
  final String? password;
  final String? code;

  @override
  List<Object?> get props => [email, password, code];
}

class LoginDataFailed extends LoginEvent {
  const LoginDataFailed({
    this.email,
    this.password,
    this.code,
    this.common,
  });

  final String? email;
  final String? password;
  final String? code;
  final String? common;

  @override
  List<Object?> get props => [email, password, code, common];
}

class LoginFinished extends LoginEvent {
  const LoginFinished();
}
