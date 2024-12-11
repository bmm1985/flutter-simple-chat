import 'package:chat/models/user.dart';

abstract class AuthRepository {
  Future<User> login(String username);
}
