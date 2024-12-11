import 'package:auto_route/auto_route.dart';
import 'package:chat/app_router.gr.dart';
import 'package:chat/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:chat/domain/bloc/auth_bloc/auth_event.dart';
import 'package:chat/domain/bloc/auth_bloc/auth_state.dart';
import 'package:chat/domain/repositories/auth_repository.dart';
import 'package:chat/locator.dart';
import 'package:chat/presentation/widgets/error_message_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();

  late AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(locator.get<AuthRepository>());
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('AuthPage.AppBar')),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: context.locale.languageCode,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'uk', child: Text('Українська')),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  context.setLocale(Locale(newValue));
                }
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(context.tr('AuthPage.LoginTitle'), style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: usernameController,
                      validator: (value) => value == null || value.isEmpty ? context.tr('AuthPage.UsernameValidator') : null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(labelText: context.tr('AuthPage.UsernamePlaceholder')),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _login,
                      child: Text(context.tr('AuthPage.LoginButton')),
                    ),
                  ],
                ),
              ),
            ),
            BlocConsumer<AuthBloc, AuthState>(
              bloc: _authBloc,
              listener: (context, state) {
                if (state is AuthAuthenticated) {
                  formKey.currentState!.reset();
                  context.router.push(ChatRoute(user: state.user));
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is AuthSubmitFailure) {
                  return Container(
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ErrorMessageWidget(error: state.exception),
                        ElevatedButton(
                          onPressed: _login,
                          child: Text(context.tr('AuthPage.RetryButton')),
                        ),
                      ],
                    ),
                  );
                }

                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _login() {
    if (formKey.currentState!.validate()) {
      _authBloc.add(AuthSubmitEvent(usernameController.text));
    }
  }
}
