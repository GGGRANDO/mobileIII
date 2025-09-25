import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/themeProvider.dart';
import 'services/user.dart';
import 'services/auth.dart';
import 'services/client.dart';
import 'routes.dart';
import 'pages/loginPage.dart';
import 'pages/homePage.dart';
import 'pages/settingsPage.dart';
import 'pages/aboutPage.dart';
import 'pages/mapsPage.dart';
import 'pages/userListPage.dart';
import 'pages/userFormPage.dart';
import 'pages/clientListPage.dart';
import 'pages/clientFormPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userService = UserService();
  await userService.init();
  AuthLocal.init(userService);

  final clientService = ClientService();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(userService: userService, clientService: clientService),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserService userService;
  final ClientService clientService;

  const MyApp({
    super.key,
    required this.userService,
    required this.clientService,
  });

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
        AppRoutes.about: (_) => const AboutPage(),
        AppRoutes.maps: (_) => const MapsPage(),
        AppRoutes.users: (_) => UserListPage(service: userService),
        AppRoutes.userNew: (_) => UserFormPage(service: userService),
        AppRoutes.clients: (_) => ClientListPage(service: clientService),
        AppRoutes.clientsNew: (_) => ClientFormPage(service: clientService),
      },
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }
}
