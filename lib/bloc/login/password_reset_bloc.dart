import 'package:auth/services/auth/auth_service.dart';
import 'package:auth/utils/email_value.dart';

import 'login_bloc_base.dart';

class PasswordResetBloc extends LoginBlocBase {
  PasswordResetBloc(AuthService authService, String email)
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
  bool get usePassword => false;

  @override
  Future<void> done(String email, String password) =>
      authService.sendPasswordResetEmail(email);
}
