import 'package:auth/bloc/login/login_bloc_base.dart';
import 'package:auth/bloc/login/registration_bloc.dart';
import 'package:auth/const/strings.dart';
import 'package:auth/const/values.dart';
import 'package:auth/services/auth/auth_service.dart';
import 'package:auth/ui/widgets/standart_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage(this.email, {Key? key}) : super(key: key);

  final String email;

  @override
  Widget build(BuildContext context) => BlocProvider<RegistrationBloc>(
        create: (context) => RegistrationBloc(
          context.read<AuthService>(),
          email,
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(Strings.registration),
          ),
          body: const Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(Values.commonSpacing),
                child: _RegistrationForm(),
              ),
            ),
          ),
        ),
      );
}

class _RegistrationForm extends StatelessWidget {
  const _RegistrationForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<RegistrationBloc, LoginState>(
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
                  _buildFinishButton(context),
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
        onChanged: (value) => context.read<RegistrationBloc>().add(
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
        onChanged: (value) => context.read<RegistrationBloc>().add(
              LoginDataChanged(password: value),
            ),
        onEditingComplete: () =>
            context.read<RegistrationBloc>().add(const LoginFinished()),
      );

  Widget _buildError(BuildContext context, LoginState state) => Text(
        state.error.toString(),
        style: TextStyle(
          color: Theme.of(context).errorColor,
        ),
      );

  Widget _buildFinishButton(BuildContext context) => ElevatedButton(
        onPressed: () =>
            context.read<RegistrationBloc>().add(const LoginFinished()),
        child: const Text(Strings.register),
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
}
