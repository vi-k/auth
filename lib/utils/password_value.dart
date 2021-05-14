import 'form_value.dart';

typedef PasswordValue = FormValue<String, String>;

final RegExp _re1 = RegExp('[a-z]');
final RegExp _re2 = RegExp('[A-Z]');
final RegExp _re3 = RegExp('[0-9]');

class PasswordValueValidator {
  static String? emptyValidator(String value) => null;

  static String? validator(String value) => value.isEmpty
      ? 'empty'
      : value.length < 6
          ? 'small'
          : !_re1.hasMatch(value) ||
                  !_re2.hasMatch(value) ||
                  !_re3.hasMatch(value)
              ? 'invalid'
              : null;

  static String? loginValidator(String value) => value.isEmpty ? 'empty' : null;
}
