import 'auth_exception.dart';
import 'auth_exception_code.dart';

extension AuthExceptionExt on AuthException {
  static const _messages = <AuthExceptionCode, String>{
    AuthExceptionCode.userNotFound: 'Такой адрес не зарегистрирован',
    AuthExceptionCode.wrongPassword: 'Неверный пароль',
    AuthExceptionCode.emailAlreadyInUse: 'Такой адрес уже зарегистрирован',
    AuthExceptionCode.invalidEmail: 'Некорректный адрес',
    AuthExceptionCode.weakPassword: 'Слабый пароль',
    AuthExceptionCode.requiresRecentLogin: 'Для завершения операции необходимо '
        'повторно авторизоваться',
  };

  String get description => _messages[code] ?? message ?? code.name;
}
