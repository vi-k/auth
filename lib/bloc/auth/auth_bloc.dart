import 'dart:async';

import 'package:auth/services/auth/auth_service.dart';
import 'package:auth/services/auth/auth_user.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.authService) : super(const AuthInitial());

  final AuthService authService;
  late final StreamSubscription _authSubscription;

  @override
  Future<void> close() {
    _authSubscription.cancel();

    return super.close();
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthStarted) await _init();
  }

  Future<void> _init() async {
    _authSubscription = authService.stream.listen((user) {
      if (user is AuthUser) {
        emit(AuthSuccess(user));
      } else {
        emit(const AuthLogin());
      }
    });
  }
}
