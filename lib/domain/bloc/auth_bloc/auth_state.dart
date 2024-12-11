import 'package:chat/models/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  AuthAuthenticated(this.user);
}

class AuthSubmitFailure extends AuthState {
  final Object? exception;

  AuthSubmitFailure(this.exception);
}
