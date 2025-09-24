import 'package:flutter/material.dart';
import 'package:login/pages/clientFormPage.dart';
import 'package:login/pages/clientListPage.dart';
import 'package:login/pages/userFormPage.dart';
import 'package:login/services/client.dart';
import 'package:provider/provider.dart';
import 'package:login/pages/aboutPage.dart';
import 'package:login/pages/mapsPage.dart';
import 'package:login/pages/settingsPage.dart';
import 'package:login/pages/loginPage.dart';
import 'package:login/pages/homePage.dart';
import '../services/user.dart';
import '../pages/userListPage.dart';
import 'routes.dart';
import 'services/themeProvider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Named Routes Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: themeProvider.appBarColor ?? Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (_) => const LoginPage(),
        AppRoutes.home: (_) => const HomePage(),
        AppRoutes.settings: (_) => const SettingsPage(),
        // AppRoutes.maps: (_) => const MapsPage(),
        AppRoutes.about: (_) => const AboutPage(),
        AppRoutes.users: (_) => UserListPage(service: UserService()),
        AppRoutes.userNew: (_) => UserFormPage(service: UserService()),
        AppRoutes.clients: (_) => ClientListPage(service: ClientService()),
        AppRoutes.clientsNew: (_) => ClientFormPage(service: ClientService()),
      },
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }
}
