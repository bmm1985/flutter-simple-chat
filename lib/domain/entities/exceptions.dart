class ServerException implements Exception {}

class AuthException implements Exception {}

class ChatException implements Exception {
  final String message;

  ChatException(this.message);

  @override
  String toString() => message;
}
