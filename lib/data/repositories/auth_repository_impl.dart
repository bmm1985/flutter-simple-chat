import 'dart:convert';

import 'package:chat/data/models/user_model.dart';
import 'package:chat/domain/repositories/auth_repository.dart';
import 'package:chat/domain/entities/exceptions.dart';
import 'package:chat/domain/entities/user.dart';
import 'package:http/http.dart' as http;

class AuthRepositoryImpl extends AuthRepository {
  final http.Client client;

  AuthRepositoryImpl({required this.client});

  @override
  Future<User> login(String username) async {
    final response = await client
        .post(
          Uri.parse('https://for-work.pp.ua/test_chat.php'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'username': username}),
        )
        .timeout(const Duration(seconds: 5));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return UserModel(username: username, token: data['token']);
      } else {
        throw AuthException();
      }
    } else {
      throw ServerException();
    }
  }
}
