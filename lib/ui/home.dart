import 'package:auth/bloc/auth/auth_bloc.dart';
import 'package:auth/const/strings.dart';
import 'package:auth/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/password_change.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              state as AuthSuccess;
              final user = state.user;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Name: ${user.displayName}'),
                  Text('E-mail: ${user.email}'),
                  Text('E-mail verified: ${user.emailVerified}'),
                  Text('Provider: ${user.providerId}'),
                  if (user.photoURL != null) Image.network(user.photoURL!),
                  _buildSignOutButton(context),
                  _buildDeleteButton(context),
                  _buildChangePasswordButton(context),
                ],
              );
            },
          ),
        ),
      );

  Widget _buildSignOutButton(BuildContext context) => ElevatedButton(
        onPressed: () {
          context.read<AuthService>().signOut();
        },
        child: const Text(Strings.signOut),
      );

  Widget _buildDeleteButton(BuildContext context) => ElevatedButton(
        onPressed: () {
          context.read<AuthService>().deleteUser();
        },
        child: const Text(Strings.deleteUser),
      );

  Widget _buildChangePasswordButton(BuildContext context) => ElevatedButton(
        onPressed: () => _passwordChange(context),
        child: const Text(Strings.passwordChange),
      );

  void _passwordChange(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => const PasswordChangePage(),
      ),
    );
  }
}
