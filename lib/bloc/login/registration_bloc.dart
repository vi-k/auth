import 'package:auth/services/auth/auth_service.dart';
import 'package:auth/utils/email_value.dart';
import 'package:auth/utils/password_value.dart';

import 'login_bloc_base.dart';

class RegistrationBloc extends LoginBlocBase {
  RegistrationBloc(AuthService authService, String email)
      : super(
          authService,
          LoginState(
            email: email.isEmpty
                ? EmailValue(email)
                : EmailValue(email).validate(EmailValueValidator.validator),
          ),
        );

  @override
  bool get useEmail => true;

  @override
  bool get usePassword => true;

  @override
  String? Function(String value) get passwordValidator =>
      PasswordValueValidator.validator;

  @override
  Future<void> done(String email, String password) =>
      authService.createUserWithEmailAndPassword(email, password);
}
