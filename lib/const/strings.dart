class Strings {
  static const changePassword = 'Сменить пароль';
  static const code = 'Код';
  static const email = 'E-mail';
  static const deleteUser = 'Удалить аккаунт';
  static const facebookIn = 'Facebook';
  static const googleIn = 'Google';
  static const invalidValues = 'Проверьте значения';
  static const login = 'Авторизация';
  static const password = 'Пароль';
  static const passwordChange = 'Смена пароля';
  static const passwordReset = 'Забыл пароль';
  static const register = 'Зарегистрироваться';
  static const registration = 'Регистрация';
  static const resetPassword = 'Сбросить пароль';
  static const sendEmailForPasswordReset =
      'Отправить письмо для восстановления';
  static const signIn = 'Войти';
  static const signOut = 'Выйти';

  static const authEmailErrors = <String, String>{
    'empty': 'Введите адрес',
    'invalid': 'Некорректный адрес',
  };

  static const authPasswordErrors = <String, String>{
    'empty': 'Введите пароль',
    'small': 'Должно быть не менее 6 символов',
    'invalid': 'Пароль должен состоять из строчных и заглавных букв, и цифр',
  };

  static const authCodeErrors = <String, String>{
    'empty': 'Введите код',
  };
}
