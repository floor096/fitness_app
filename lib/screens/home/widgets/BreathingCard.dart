import 'package:flutter/material.dart';

class BreathingCard extends StatelessWidget {
  final Animation<double> breathAnimation;

  const BreathingCard({
    super.key,
    required this.breathAnimation
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: breathAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: breathAnimation.value,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF69B4), Color(0xFFE91E63)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border(
                bottom: BorderSide(color: Color(0xFFC2185B), width: 6),
                right: BorderSide(color: Color(0xFFC2185B), width: 6),
              ),
            ),
            child: Column(
              children: [
                // AQUÍ IRÁ: patricio_home_feliz.png
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '⭐',
                      style: TextStyle(fontSize: 80),
                    ),
                    // TODO: Reemplazar con Image.asset('assets/patricio_home_feliz.png')
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Hola soy Patricio',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  '¿Listo para ejercitar hoy?',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.95),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );

  }
}