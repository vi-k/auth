import 'package:auth/utils/form_value.dart';

typedef EmailValue = FormValue<String, String>;

final RegExp _re = RegExp(r'.+@.+\..+');

class EmailValueValidator {
  static String? emptyValidator(String value) => null;

  static String? validator(String value) => value.isEmpty
      ? 'empty'
      : !_re.hasMatch(value)
          ? 'invalid'
          : null;
}
