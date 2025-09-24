import 'dart:async';
import 'package:flutter/material.dart';
import '../routes.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}
//essa parte é onde começa a animação gu
class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  bool _showSplash = true;
  Timer? _timer;
  late final AnimationController _spin;

  @override
  void initState() {
    super.initState();
    //aqui controla a velocidade que se mexe e por quanto tempo ta girando, ou seja, ele demora 1 sec pra dar uma volta e ele da volta por 2 sec  
    _spin = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..repeat();

    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _showSplash = false);
      _spin.stop();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 240,
                    child: RotationTransition(
                      turns: _spin,
                      child: Image.asset(
                        'assets/GiraGirou-removebg-preview.png',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.info, size: 96),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Sobre o App',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Carregando informações...',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.home),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          const double pad = 20;
          const double gap = 16;
          final double twoColWidth = (constraints.maxWidth - pad * 2 - gap) / 2;
          final double cardWidth =
              (twoColWidth >= 260) ? twoColWidth : (constraints.maxWidth - pad * 2);

          return ListView(
            padding: const EdgeInsets.all(pad),
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/upf.png',
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Desenvolvedores',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Wrap(
                spacing: gap,
                runSpacing: gap,
                alignment: WrapAlignment.center,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: const _DeveloperCard(
                      imagePath: 'assets/Kevin Guvrone.png',
                      name: 'Gustavo Grando',
                      matricula: '177641',
                      curso: 'Análise e desenvolvimento de sistemas',
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: const _DeveloperCard(
                      imagePath: 'assets/Luis Olleman.png',
                      name: 'Luis Otavio',
                      matricula: '174923',
                      curso: 'Análise e desenvolvimento de sistemas',
                    ),
                  ),
                ],
              ),

            ],
          );
        },
      ),
    );
  }
}

class _DeveloperCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String matricula;
  final String curso;

  const _DeveloperCard({
    required this.imagePath,
    required this.name,
    required this.matricula,
    required this.curso,
  });

  void _openImageDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (_) {
        return Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 24,
              right: 24,
              child: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.15),
                ),
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Fechar',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double imageHeight = 220;

    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Foto (não corta). Tap abre fullscreen com zoom.
            GestureDetector(
              onTap: () => _openImageDialog(context),
              child: Container(
                height: imageHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: Center(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Matrícula: $matricula',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              'Curso: $curso',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
