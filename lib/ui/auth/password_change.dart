import 'package:auth/bloc/login/login_bloc_base.dart';
import 'package:auth/bloc/login/password_change_bloc.dart';
import 'package:auth/const/strings.dart';
import 'package:auth/const/values.dart';
import 'package:auth/services/auth/auth_service.dart';
import 'package:auth/ui/widgets/standart_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordChangePage extends StatelessWidget {
  const PasswordChangePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider<PasswordChangeBloc>(
        create: (context) => PasswordChangeBloc(context.read<AuthService>()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(Strings.passwordChange),
          ),
          body: const Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(Values.commonSpacing),
                child: _GetPasswordForm(),
              ),
            ),
          ),
        ),
      );
}

class _GetPasswordForm extends StatelessWidget {
  const _GetPasswordForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<PasswordChangeBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginDone) {
            Navigator.pop<void>(context);
          }
        },
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
        onChanged: (value) => context.read<PasswordChangeBloc>().add(
              LoginDataChanged(password: value),
            ),
        onEditingComplete: () =>
            context.read<PasswordChangeBloc>().add(const LoginFinished()),
      );

  Widget _buildError(BuildContext context, LoginState state) => Text(
        state.error.toString(),
        style: TextStyle(
          color: Theme.of(context).errorColor,
        ),
      );

  Widget _buildFinishButton(BuildContext context) => ElevatedButton(
        onPressed: () =>
            context.read<PasswordChangeBloc>().add(const LoginFinished()),
        child: const Text(Strings.changePassword),
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
