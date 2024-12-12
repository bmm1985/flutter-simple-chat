import 'package:chat/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String username);
}
