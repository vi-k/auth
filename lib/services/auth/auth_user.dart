import 'package:equatable/equatable.dart';

abstract class AuthUserBase extends Equatable {
  const AuthUserBase();

  @override
  List<Object?> get props => [];
}

/// Нет авторизованного пользователя.
class AuthNoUser extends AuthUserBase {
  const AuthNoUser();

  @override
  String toString() => 'AuthNoUser';
}

/// Авторизованный пользователь.
class AuthUser extends AuthUserBase {
  const AuthUser({
    required this.displayName,
    required this.email,
    required this.emailVerified,
    required this.photoURL,
    required this.providerId,
  });

  final String? displayName;
  final String? email;
  final bool emailVerified;
  final String? photoURL;
  final String providerId;

  @override
  List<Object?> get props => [
        displayName,
        email,
        emailVerified,
        photoURL,
        providerId,
      ];

  @override
  String toString() => 'AuthUser('
      'displayName: $displayName, '
      'email: $email, '
      'emailVerified: $emailVerified, '
      'photoURL: $photoURL, '
      'providerId: $providerId)';
}
