import 'auth_user.dart';

abstract class AuthService {
  Future<void> init();

  void close();

  Stream<AuthUserBase> get stream;

  Future<AuthUserBase> signInWithEmailAndPassword(
    String email,
    String password,
  );

  Future<AuthUserBase> createUserWithEmailAndPassword(
    String email,
    String password,
  );

  Future<void> signOut();
  Future<void> deleteUser();
  Future<void> changePassword(String newPassword);
  Future<void> sendPasswordResetEmail(String email);

  Future<AuthUserBase> signInWithGoogle();
  Future<AuthUserBase> signInWithFacebook();
}
