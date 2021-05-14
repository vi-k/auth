import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_exception.dart';
import 'auth_exception_code.dart';
import 'auth_service.dart';
import 'auth_user.dart';

class FirebaseAuthService extends AuthService {
  static const _exceptions = <String, AuthExceptionCode>{
    'user-not-found': AuthExceptionCode.userNotFound,
    'wrong-password': AuthExceptionCode.wrongPassword,
    'email-already-in-use': AuthExceptionCode.emailAlreadyInUse,
    'invalid-email': AuthExceptionCode.invalidEmail,
    'weak-password': AuthExceptionCode.weakPassword,
    'requires-recent-login': AuthExceptionCode.requiresRecentLogin,
  };

  late final StreamSubscription _subscription;

  final _streamController = StreamController<AuthUserBase>();

  @override
  Future<void> init() async {
    await Firebase.initializeApp();

    _subscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      print(user);
      _streamController.add(_user(user));
    });
  }

  @override
  void close() {
    _streamController.close();
    _subscription.cancel();
  }

  @override
  Stream<AuthUserBase> get stream => _streamController.stream;

  @override
  Future<AuthUserBase> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _user(userCredential.user);
    } on FirebaseAuthException catch (e) {
      throw _exception(e);
    }
  }

  @override
  Future<AuthUserBase> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _user(userCredential.user);
    } on FirebaseAuthException catch (e) {
      throw _exception(e);
    }
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> deleteUser() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw _exception(e);
    }
  }

  @override
  Future<void> changePassword(String newPassword) async {
    try {
      await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _exception(e);
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _exception(e);
    }
  }

  @override
  Future<AuthUserBase> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return const AuthNoUser();

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return _user(userCredential.user);
    } on FirebaseAuthException catch (e) {
      throw _exception(e);
    }
  }

  @override
  Future<AuthUserBase> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final accessToken = result.accessToken!;
        final facebookAuthCredential =
            FacebookAuthProvider.credential(accessToken.token);
        final userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        return _user(userCredential.user);
      }

      return _user(null);
    } on FirebaseAuthException catch (e) {
      throw _exception(e);
    }
  }

  AuthUserBase _user(User? user) => user == null
      ? const AuthNoUser()
      : AuthUser(
          displayName: user.displayName ?? user.providerData.first.displayName,
          email: user.email ?? user.providerData.first.email,
          emailVerified: user.emailVerified,
          photoURL: user.photoURL ?? user.providerData.first.photoURL,
          providerId: user.providerData.first.providerId,
        );

  AuthException _exception(FirebaseAuthException e) {
    final code = _exceptions[e.code] ?? AuthExceptionCode.unknown;

    return AuthException(
      code,
      code == AuthExceptionCode.unknown
          ? '[${e.code}] ${e.message}'
          : e.message,
    );
  }
}
