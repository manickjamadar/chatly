import 'package:chatly/providers/auth_user_providers.dart';
import 'package:chatly/providers/profile_provider.dart';
import 'package:chatly/screens/auth_screen.dart';
import 'package:chatly/screens/edit_profile_screen.dart';
import 'package:chatly/screens/main_screen.dart';
import 'package:chatly/screens/select_profile_screen.dart';
import 'package:chatly/service/auth_service.dart';
import 'package:chatly/service/database_service.dart';
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
                  AuthUserProvider(authService)),
          ProxyProvider<AuthUserProvider, DatabaseService>(
            lazy: false,
            create: (_) => DatabaseService(null),
            update: (_, authUserProvider, databaseService) =>
                DatabaseService(authUserProvider?.authUser),
          ),
          ChangeNotifierProxyProvider<DatabaseService, ProfileProvider>(
              lazy: false,
              create: (_) => ProfileProvider(null),
              update: (_, databaseService, __) =>
                  ProfileProvider(databaseService)),
        ],
        child: Consumer<AuthUserProvider>(
          builder: (ctx, authUserProvider, c) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: authUserProvider.isAuthenticated
                  ? MainScreen()
                  : AuthScreen(),
              routes: {
                EditProfileScreen.routeName: (_) => EditProfileScreen(),
                SelectProfileScreen.routeName: (_) => SelectProfileScreen()
              },
            );
          },
        ));
  }
}
