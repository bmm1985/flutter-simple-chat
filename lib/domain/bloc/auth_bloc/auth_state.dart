import 'package:chat/domain/entities/user.dart';

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
