import 'dart:async';
import 'package:flutter/material.dart';

class SplashWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Duration duration;
  final String nextRoute;

  const SplashWidget({
    Key? key,
    required this.title,
    this.subtitle = 'Carregando...',
    this.icon = Icons.account_circle,
    this.duration = const Duration(seconds: 2),
    required this.nextRoute,
  }) : super(key: key);

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.duration, () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, widget.nextRoute);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 96),
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.subtitle, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
