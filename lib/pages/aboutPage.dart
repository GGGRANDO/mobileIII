import 'dart:async';
import 'package:flutter/material.dart';
import '../routes.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      // Tela de splash
      return Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.info, size: 96),
              SizedBox(height: 16),
              Text(
                'Sobre o App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Carregando informações...', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    }
    final entries = const [
      ('Gustavo Grando', '177641', 'Análise e desenvolvimento de sistemas'),
      ('Luis Otavio', '174923', 'Análise e desenvolvimento de sistemas'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Desenvolvedores',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...entries.map(
            (e) => Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.person, size: 32),
                title: Text(
                  e.$1,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Matrícula: ${e.$2}\nCurso: ${e.$3}'),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Aplicativo de gerenciamento de clientes',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
