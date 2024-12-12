// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:chat/domain/entities/user.dart' as _i5;
import 'package:chat/presentation/pages/auth_page.dart' as _i1;
import 'package:chat/presentation/pages/chat_page.dart' as _i2;
import 'package:flutter/material.dart' as _i4;

/// generated route for
/// [_i1.AuthPage]
class AuthRoute extends _i3.PageRouteInfo<void> {
  const AuthRoute({List<_i3.PageRouteInfo>? children})
      : super(
          AuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i1.AuthPage();
    },
  );
}

/// generated route for
/// [_i2.ChatPage]
class ChatRoute extends _i3.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    _i4.Key? key,
    required _i5.User user,
    List<_i3.PageRouteInfo>? children,
  }) : super(
          ChatRoute.name,
          args: ChatRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'ChatRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatRouteArgs>();
      return _i2.ChatPage(
        key: args.key,
        user: args.user,
      );
    },
  );
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    required this.user,
  });

  final _i4.Key? key;

  final _i5.User user;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, user: $user}';
  }
}
