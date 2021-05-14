import 'package:auth/bloc/login/login_bloc.dart';
import 'package:auth/bloc/login/login_bloc_base.dart';
import 'package:auth/const/strings.dart';
import 'package:auth/const/values.dart';
import 'package:auth/services/auth/auth_service.dart';
import 'package:auth/ui/widgets/standart_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'password_reset.dart';
import 'registration.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(context.read<AuthService>()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(Strings.login),
          ),
          body: const Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(Values.commonSpacing),
                child: _LoginForm(),
              ),
            ),
          ),
        ),
      );
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) => Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(Values.commonSpacing),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(Values.commonSpacing / 2),
                ),
                border: Border.all(color: Theme.of(context).primaryColor),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildEmailField(context, state),
                  const StandartDivider(),
                  _buildPasswordField(context, state),
                  if (state.error != null) ...[
                    const StandartDivider(),
                    _buildError(context, state),
                  ],
                  const StandartDivider(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _buildResetPasswordButton(context, state),
                  ),
                  _buildFinishButton(context, state),
                  _buildRegistrationButton(context, state),
                  Row(
                    children: [
                      Expanded(child: _buildGoogleInButton(context)),
                      const SizedBox(width: Values.commonSpacing),
                      Expanded(child: _buildFacebookInButton(context)),
                    ],
                  ),
                ],
              ),
            ),
            if (state is LoginInProgress) _buildProgressIndicator(),
          ],
        ),
      );

  Widget _buildEmailField(BuildContext context, LoginState state) =>
      TextFormField(
        initialValue: state.email.value,
        keyboardType: TextInputType.emailAddress,
        autofocus: true,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: Strings.email,
          errorText:
              Strings.authEmailErrors[state.email.error] ?? state.email.error,
          errorMaxLines: 3,
        ),
        onChanged: (value) => context.read<LoginBloc>().add(
              LoginDataChanged(email: value),
            ),
      );

  Widget _buildPasswordField(BuildContext context, LoginState state) =>
      TextFormField(
        initialValue: state.password.value,
        obscureText: true,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: Strings.password,
          errorText: Strings.authPasswordErrors[state.password.error] ??
              state.password.error,
          errorMaxLines: 3,
        ),
        onChanged: (value) => context.read<LoginBloc>().add(
              LoginDataChanged(password: value),
            ),
        onEditingComplete: () =>
            context.read<LoginBloc>().add(const LoginFinished()),
      );

  Widget _buildError(BuildContext context, LoginState state) => Text(
        state.error.toString(),
        style: TextStyle(
          color: Theme.of(context).errorColor,
        ),
      );

  Widget _buildFinishButton(BuildContext context, LoginState state) =>
      ElevatedButton(
        onPressed: () => context.read<LoginBloc>().add(const LoginFinished()),
        child: const Text(Strings.signIn),
      );

  Widget _buildRegistrationButton(BuildContext context, LoginState state) =>
      SignInButton(
        Buttons.Email,
        text: Strings.register,
        onPressed: () => _register(context, state.email.value),
      );

  Widget _buildResetPasswordButton(BuildContext context, LoginState state) =>
      TextButton(
        onPressed: () => _passwordReset(context, state.email.value),
        child: const Text(Strings.passwordReset),
      );

  Widget _buildGoogleInButton(BuildContext context) => SignInButton(
        Buttons.GoogleDark,
        text: Strings.googleIn,
        onPressed: () => context.read<AuthService>().signInWithGoogle(),
      );

  Widget _buildFacebookInButton(BuildContext context) => SignInButton(
        Buttons.FacebookNew,
        text: Strings.facebookIn,
        onPressed: () => context.read<AuthService>().signInWithFacebook(),
      );

  Widget _buildProgressIndicator() => Positioned.fill(
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: const BorderRadius.all(
              Radius.circular(Values.commonSpacing / 2),
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );

  void _register(BuildContext context, String email) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationPage(email),
      ),
    );
  }

  void _passwordReset(BuildContext context, String email) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => PasswordResetPage(email),
      ),
    );
  }
}
