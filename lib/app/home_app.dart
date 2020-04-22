import 'package:chatly/providers/auth_user_providers.dart';
import 'package:chatly/providers/profile_provider.dart';
import 'package:chatly/screens/main_screen.dart';
import 'package:chatly/service/database_service.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ProxyProvider<AuthUserProvider, DatabaseService>(
            create: (_) => DatabaseService(null),
            update: (_, authUserProvider, databaseService) =>
                DatabaseService(authUserProvider.authUser),
          ),
          ChangeNotifierProxyProvider<DatabaseService, ProfileProvider>(
              create: (_) => ProfileProvider(null),
              update: (_, databaseService, profileProvider) =>
                  ProfileProvider(databaseService))
        ],
        child:
            MaterialApp(debugShowCheckedModeBanner: false, home: MainScreen()));
  }
}
