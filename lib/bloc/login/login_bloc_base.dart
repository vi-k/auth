import 'dart:async';

import 'package:auth/services/auth/auth_exception.dart';
import 'package:auth/services/auth/auth_exception_code.dart';
import 'package:auth/services/auth/auth_exception_ru.dart';
import 'package:auth/services/auth/auth_service.dart';
import 'package:auth/utils/email_value.dart';
import 'package:auth/utils/form_value.dart';
import 'package:auth/utils/form_values.dart';
import 'package:auth/utils/password_value.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

abstract class LoginBlocBase extends Bloc<LoginEvent, LoginState> {
  LoginBlocBase(this.authService, [LoginState? signInState])
      : super(signInState ?? const LoginState());

  final AuthService authService;

  bool get useEmail;
  bool get usePassword;

  String? Function(String value) get emailValidator =>
      EmailValueValidator.validator;

  String? Function(String value) get passwordValidator =>
      PasswordValueValidator.validator;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginDataChanged) {
      yield _change(event);
    } else if (event is LoginDataFailed) {
      yield _fail(event);
    } else if (event is LoginFinished) {
      yield* _finish();
    }
  }

  LoginState _change(LoginDataChanged event) {
    var email = state.email;
    if (useEmail && event.email != null) {
      email = email.setValue(event.email!).validate(emailValidator);
    }

    var password = state.password;
    if (usePassword && event.password != null) {
      password = password.setValue(event.password!).validate(passwordValidator);
    }

    return state.copyWith(
      email: email,
      password: password,
    );
  }

  LoginState _fail(LoginDataFailed event) {
    final email = useEmail
        ? event.email != null
            ? state.email.toInvalid(event.email!)
            : state.email.toValid()
        : state.email;

    final password = usePassword
        ? event.password != null
            ? state.password.toInvalid(event.password!)
            : state.password.toValid()
        : state.password;

    return state.copyWith(
      email: email,
      password: password,
      error: event.common,
      errorReset: event.common == null,
    );
  }

  Stream<LoginState> _finish() async* {
    final email =
        useEmail ? state.email.validate(emailValidator) : state.email.toValid();

    final password = usePassword
        ? state.password.validate(passwordValidator)
        : state.password.toValid();

    final newState = state.copyWith(
      email: email,
      password: password,
    );

    if (newState.isValid) {
      yield LoginInProgress(newState);

      try {
        await done(email.value, password.value);
        yield LoginDone(newState);
      } on AuthException catch (e) {
        if (useEmail && e.code.isEmailError) {
          add(LoginDataFailed(email: e.description));
        } else if (usePassword && e.code.isPasswordError) {
          add(LoginDataFailed(password: e.description));
        } else {
          add(LoginDataFailed(common: e.description));
        }
      }
    } else {
      yield newState;
    }
  }

  Future<void> done(String email, String password);
}
