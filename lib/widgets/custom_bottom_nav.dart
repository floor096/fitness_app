import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/recompensas_screen.dart';
import '../screens/perfil_screen.dart';

const Color primaryColor = Color(0xFFFF69B4);

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  // Función de navegación CORREGIDA
  void _onNavTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget screen;
    switch (index) {
      case 0:
        screen = HomeScreen();
        break;
      case 1:
        screen = RecompensasScreen();
        break;
      case 2:
        screen = PerfilScreen();
        break;
      default:
        return;
    }

    // SOLUCIÓN: Usamos PageRouteBuilder pero desactivamos Hero
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, anim1, anim2) => HeroMode(
          enabled: false,  // ← ESTO SOLUCIONA EL ERROR
          child: screen,
        ),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
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
            color: primaryColor.withOpacity(0.3),
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
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 20,
          unselectedFontSize: 20,
          iconSize: 40,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Menú',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events),
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