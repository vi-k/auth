import 'dart:async';

import 'package:auth/services/auth/auth_service.dart';
import 'package:auth/utils/password_value.dart';

import 'login_bloc_base.dart';

class LoginBloc extends LoginBlocBase {
  LoginBloc(AuthService authService, [LoginState? state])
      : super(authService, state ?? const LoginState());

  @override
  bool get useEmail => true;

  @override
  bool get usePassword => true;

  @override
  String? Function(String value) get passwordValidator =>
      PasswordValueValidator.loginValidator;

  @override
  Future<void> done(String email, String password) =>
      authService.signInWithEmailAndPassword(email, password);
}
