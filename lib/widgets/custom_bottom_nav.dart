import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/progreso_screen.dart';
import '../screens/perfil_screen.dart';

const Color primaryColor = Color(0xFFFF69B4);

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  // funcion de navegación
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
    // y Duration.zero para una transición instantánea (sin animaciones que confundan a Patricio)
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
            color: primaryColor,
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
          selectedItemColor: primaryColor, // Rosa
          unselectedItemColor: Colors.grey,
          selectedFontSize: 20,
          unselectedFontSize: 20,
          iconSize: 40, // Iconos más grandes
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

