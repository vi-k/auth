import 'package:auth/services/auth/auth_service.dart';
import 'package:auth/services/auth/firebase_auth_service.dart';
import 'package:auth/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'bloc/auth/auth_bloc.dart';
import 'ui/auth/login.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late Future<void> _inited;

  final authService = FirebaseAuthService();

  @override
  void initState() {
    super.initState();

    _inited = Future.wait([authService.init()]);
  }

  @override
  void dispose() {
    authService.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
        future: _inited,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            // Тут нужен splash screen.
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return MultiProvider(
            providers: [
              Provider<AuthService>(
                create: (context) => authService,
              ),
            ],
            builder: (context, child) => MultiBlocProvider(
              providers: [
                BlocProvider<AuthBloc>(
                  create: (context) => AuthBloc(context.read<AuthService>())
                    ..add(const AuthStarted()),
                ),
              ],
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) => MaterialApp(
                  key: ValueKey(state is AuthSuccess),
                  title: 'Auth',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  home: state is AuthSuccess
                      ? HomePage()
                      : state is AuthLogin
                          ? LoginPage()
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                ),
              ),
            ),
          );
        },
      );
}
