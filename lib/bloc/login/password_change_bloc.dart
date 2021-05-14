import 'package:auth/services/auth/auth_service.dart';

import 'login_bloc_base.dart';

class PasswordChangeBloc extends LoginBlocBase {
  PasswordChangeBloc(AuthService authService)
      : super(authService, const LoginState());

  @override
  bool get useEmail => false;

  @override
  bool get usePassword => true;

  @override
  Future<void> done(String email, String password) =>
      authService.changePassword(password);
}
