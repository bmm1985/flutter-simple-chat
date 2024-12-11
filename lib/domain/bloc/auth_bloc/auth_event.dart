abstract class AuthEvent {}

class AuthSubmitEvent extends AuthEvent {
  final String username;

  AuthSubmitEvent(this.username);
}
