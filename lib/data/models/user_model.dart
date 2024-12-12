import 'package:chat/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.username,
    required super.token,
  });
}
