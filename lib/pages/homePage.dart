import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/themeProvider.dart';
import '../routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Início'),
            backgroundColor: themeProvider.appBarColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.people),
                    label: const Text('Usuários'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeProvider.appBarColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.users);
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.business),
                    label: const Text('Clientes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeProvider.appBarColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.clients);
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Sobre'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeProvider.appBarColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.about);
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.settings),
                    label: const Text('Configurações'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeProvider.appBarColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.settings);
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.map),
                    label: const Text('Mapa'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeProvider.appBarColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.maps);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
