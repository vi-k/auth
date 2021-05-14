part of 'login_bloc_base.dart';

class LoginState extends Equatable with FormValues {
  const LoginState({
    this.email = const EmailValue(''),
    this.password = const PasswordValue(''),
    this.error,
  });

  LoginState.from(LoginState state)
      : email = state.email,
        password = state.password,
        error = state.error;

  final EmailValue email;
  final PasswordValue password;
  final String? error;

  @override
  List<FormValue> get values => [email, password];

  @override
  List<Object?> get props => [values, error];

  LoginState copyWith({
    EmailValue? email,
    PasswordValue? password,
    String? error,
    bool errorReset = false,
  }) {
    assert(error == null || !errorReset);

    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      error: errorReset ? null : error ?? this.error,
    );
  }
}

/// Завершение.
class LoginInProgress extends LoginState {
  LoginInProgress(LoginState state) : super.from(state);
}

/// Завершено.
class LoginDone extends LoginState {
  LoginDone(LoginState state) : super.from(state);
}
