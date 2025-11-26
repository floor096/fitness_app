import 'package:flutter/material.dart';

class InsigniaGradient extends StatelessWidget {
  final String emoji;
  final String valor;
  final String label;
  final List<Color> gradient;
  final bool desbloqueado;

  const InsigniaGradient({
    super.key,
    required this.emoji,
    required this.valor,
    required this.label,
    required this.gradient,
    required this.desbloqueado,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: desbloqueado
            ? LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        color: desbloqueado ? null : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
        border: Border(
          bottom: BorderSide(
            color: desbloqueado ? gradient[1] : Colors.grey.shade400,
            width: 5,
          ),
          right: BorderSide(
            color: desbloqueado ? gradient[1] : Colors.grey.shade400,
            width: 5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: TextStyle(
                fontSize: 45,
                color: desbloqueado ? null : Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              valor,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: desbloqueado ? Colors.white : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 22,
                color: desbloqueado
                    ? Colors.white.withOpacity(0.9)
                    : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
