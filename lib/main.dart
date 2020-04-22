import 'package:chatly/app/auth_app.dart';
import 'package:chatly/app/home_app.dart';
import 'package:chatly/providers/auth_user_providers.dart';
import 'package:chatly/service/auth_service.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(
            create: (_) => AuthService(),
          ),
          ChangeNotifierProxyProvider<AuthService, AuthUserProvider>(
              create: (_) => AuthUserProvider(null),
              update: (_, authService, authUserProvider) =>
                  AuthUserProvider(authService))
        ],
        child: Consumer<AuthUserProvider>(
          builder: (ctx, authUserProvider, c) {
            return authUserProvider.isAuthenticated ? HomeApp() : AuthApp();
          },
        ));
  }
}
