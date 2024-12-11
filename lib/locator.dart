import 'package:chat/data/repositories/auth_repository_impl.dart';
import 'package:chat/data/repositories/chat_repository_impl.dart';
import 'package:chat/domain/repositories/auth_repository.dart';
import 'package:chat/domain/repositories/chat_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

GetIt locator = GetIt.instance;

setupLocator() {
  // http client
  locator.registerLazySingleton<http.Client>(() => http.Client());

  // repositories
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(client: locator.get<http.Client>()));
  locator.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl());
}
