/*

// lib/widgets/custom_bottom_nav.dart
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/ejercicios_screen.dart';
import '../screens/perfil_screen.dart';
import '../screens/alarmas_screen.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  void _onNavTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget screen;
    switch (index) {
      case 0:
        screen = HomeScreen();
        break;
      case 1:
        screen = EjerciciosScreen();
        break;
      case 2:
        screen = AlarmasScreen();
        break;
      case 4:
        screen = PerfilScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, anim1, anim2) => screen,
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onNavTap(context, index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFFFF69B4),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 13,
        unselectedFontSize: 12,
        iconSize: 28,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Ejercicios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Alarmas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Mi Progreso',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

 */

import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/progreso_screen.dart';
import '../screens/perfil_screen.dart';

// Colores de la paleta de Patricio
const Color primaryColor = Color(0xFFFF69B4); // Rosa Fuerte (Pink)

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  // Función de navegación mejorada
  void _onNavTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget screen;
    switch (index) {
      case 0:
        screen = HomeScreen();
        break;
      case 1:
        screen = ProgresoScreen();
        break;
      case 2:
        screen = PerfilScreen();
        break;
      default:
        return;
    }

    // Usamos pushReplacement para evitar acumular pantallas en la pila,
    // y Duration.zero para una transición instantánea (sin animaciones que confundan a Patricio).
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, anim1, anim2) => screen,
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _onNavTap(context, index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: primaryColor, // Rosa Fuerte
          unselectedItemColor: Colors.grey.shade400,
          selectedFontSize: 13,
          unselectedFontSize: 12,
          iconSize: 30, // Iconos más grandes
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.star), // Icono principal de Patricio
              label: 'Mi Misión',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events), // Icono para trofeos/progreso
              label: 'Recompensas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Yo',
            ),
          ],
        ),
      ),
    );
  }
}

