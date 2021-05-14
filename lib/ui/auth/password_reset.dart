import 'package:auth/bloc/login/login_bloc_base.dart';
import 'package:auth/bloc/login/password_reset_bloc.dart';
import 'package:auth/const/strings.dart';
import 'package:auth/const/values.dart';
import 'package:auth/services/auth/auth_service.dart';
import 'package:auth/ui/widgets/standart_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage(this.email, {Key? key}) : super(key: key);

  final String email;

  @override
  Widget build(BuildContext context) => BlocProvider<PasswordResetBloc>(
        create: (context) => PasswordResetBloc(
          context.read<AuthService>(),
          email,
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(Strings.passwordReset),
          ),
          body: const Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(Values.commonSpacing),
                child: _GetEmailForm(),
              ),
            ),
          ),
        ),
      );
}

class _GetEmailForm extends StatelessWidget {
  const _GetEmailForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<PasswordResetBloc, LoginState>(
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
                  _buildEmailField(context, state),
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
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: Strings.email,
          errorText:
              Strings.authEmailErrors[state.email.error] ?? state.email.error,
          errorMaxLines: 3,
        ),
        onChanged: (value) => context.read<PasswordResetBloc>().add(
              LoginDataChanged(email: value),
            ),
        onEditingComplete: () =>
            context.read<PasswordResetBloc>().add(const LoginFinished()),
      );

  Widget _buildError(BuildContext context, LoginState state) => Text(
        state.error.toString(),
        style: TextStyle(
          color: Theme.of(context).errorColor,
        ),
      );

  Widget _buildFinishButton(BuildContext context) => ElevatedButton(
        onPressed: () =>
            context.read<PasswordResetBloc>().add(const LoginFinished()),
        child: const Text(Strings.sendEmailForPasswordReset),
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
