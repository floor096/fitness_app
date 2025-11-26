import 'dart:async';
import 'package:flutter/material.dart';

class MotivationalSwitcher extends StatefulWidget {
  const MotivationalSwitcher({super.key});

  @override
  State<MotivationalSwitcher> createState() => _MotivationalSwitcherState();
}

class _MotivationalSwitcherState extends State<MotivationalSwitcher> {
  // Lista interna de frases
  final List<Map<String, String>> frases = [
    {
      'texto': '¡Muy bien Patricio eres el mejor!',
      'emoji': '🌟',
    },
    {
      'texto': 'Bob Esponja estaría orgulloso de ti',
      'emoji': '🧽',
    },
    {
      'texto': 'Un ejercicio más y luego puedes descansar',
      'emoji': '💪',
    },
    {
      'texto': '¡Vas a ser la estrella más fuerte de Fondo de Bikini!',
      'emoji': '⭐',
    },
    {
      'texto': 'No pain, no... ¡helado!',
      'emoji': '🍦',
    },
  ];

  int _fraseActual = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Cambiar frase automáticamente cada 5 segundos
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() {
        _fraseActual = (_fraseActual + 1) % frases.length;
      });
    });
  }

  @override
  void dispose() {
    // Evita memory leaks
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },

      child: Container(
        key: ValueKey<int>(_fraseActual),
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD93D), Color(0xFFFFB74D)],
          ),
          borderRadius: BorderRadius.circular(25),
          border: const Border(
            bottom: BorderSide(color: Color(0xFFFF9800), width: 5),
            right: BorderSide(color: Color(0xFFFF9800), width: 5),
          ),
        ),
        child: Row(
          children: [
            Text(
              frases[_fraseActual]['emoji']!,
              style: const TextStyle(fontSize: 50),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                frases[_fraseActual]['texto']!,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.brown.shade800,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
