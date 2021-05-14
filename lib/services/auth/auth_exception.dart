import 'auth_exception_code.dart';

class AuthException implements Exception {
  AuthException(this.code, this.message);

  final AuthExceptionCode code;
  final String? message;

  @override
  String toString() =>
      'AuthException(${code.name}${message == null ? '' : ', message: $message'})';
}
