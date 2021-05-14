import 'package:auth/utils/enum.dart';

enum AuthExceptionCode {
  unknown,
  userNotFound,
  wrongPassword,
  emailAlreadyInUse,
  invalidEmail,
  weakPassword,
  requiresRecentLogin,
}

extension AuthExceptionCodeExt on AuthExceptionCode {
  static const _emailErrors = <AuthExceptionCode>{
    AuthExceptionCode.userNotFound,
    AuthExceptionCode.emailAlreadyInUse,
    AuthExceptionCode.invalidEmail,
  };

  static const _passwordErrors = <AuthExceptionCode>{
    AuthExceptionCode.wrongPassword,
    AuthExceptionCode.weakPassword,
  };

  static const _codeErrors = <AuthExceptionCode>{
    AuthExceptionCode.wrongPassword,
    AuthExceptionCode.weakPassword,
  };

  String get name => enumName(this);
  bool get isEmailError => _emailErrors.contains(this);
  bool get isPasswordError => _passwordErrors.contains(this);
  bool get isCodeError => _codeErrors.contains(this);
}
