// lib/screens/ejercicios_screen.dart
import 'package:flutter/material.dart';
import 'perfil_screen.dart';
import 'home_screen.dart';
import '../widgets/custom_bottom_nav.dart';


class EjerciciosScreen extends StatefulWidget {
  @override
  _EjerciciosScreenState createState() => _EjerciciosScreenState();
}

 /*

class EjerciciosScreen extends StatefulWidget {
  // 1. Definición de la propiedad de entrada (input)
  final int levelId;

  // 2. Constructor que requiere la propiedad
  const EjerciciosScreen({
    Key? key,
    required this.levelId, // ¡Esto soluciona el error!
  }) : super(key: key);

  @override
  _EjerciciosScreenState createState() => _EjerciciosScreenState();
}


  */

class _EjerciciosScreenState extends State<EjerciciosScreen> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF5F7),
      appBar: AppBar(
        backgroundColor: Color(0xFFFF69B4),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(Icons.fitness_center, color: Colors.white, size: 28),
            SizedBox(width: 10),
            Text(
              'Ejercicios Fáciles',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white, size: 28),
            onPressed: () {
              _showSimpleDialog('🔍 Buscador', 'Aquí podrás buscar ejercicios');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            // MENSAJE MOTIVACIONAL
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFD54F), Color(0xFFFFB74D)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text('🌟', style: TextStyle(fontSize: 40)),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¡Bien hecho, PATRICIO!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown.shade800,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Vas a ser la estrella más fuerte 💪',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.brown.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // CATEGORÍAS DE EJERCICIOS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Elige tu Ejercicio',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            SizedBox(height: 20),

            // CARDS DE CATEGORÍAS - MUY GRANDES
            _buildBigCategoryCard(
              '🏃 Cardio Súper Suave',
              '5 minutos • Muy fácil',
              Color(0xFF4DD0E1),
              'https://drive.google.com/file/d/1ZVoQfApYpqOyZnHUDShf6p2WcTerxoCs/view?usp=sharing',
            ),

            _buildBigCategoryCard(
              '🧘 Estiramientos',
              '3 minutos • Para holgazanes',
              Color(0xFF66BB6A),
              'https://drive.google.com/file/d/1ZVoQfApYpqOyZnHUDShf6p2WcTerxoCs/view?usp=sharing',
            ),

            _buildBigCategoryCard(
              '💪 Fuerza Básica',
              '7 minutos • Sin pesas',
              Color(0xFFFF7043),
              'https://drive.google.com/file/d/1ZVoQfApYpqOyZnHUDShf6p2WcTerxoCs/view?usp=sharing',
            ),
/*
            _buildBigCategoryCard(
              '🌟 Bajo tu Roca',
              '5 minutos • En casa',
              Color(0xFFFFD54F),
              'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=500',
            ),

 */

            SizedBox(height: 100),
          ],
        ),
      ),

      /* bottomNavigationBar: _buildBottomNav(),

       */
      bottomNavigationBar: CustomBottomNav(currentIndex: 1),  // 1 = Ejercicios
    );
  }

  Widget _buildBigCategoryCard(String title, String subtitle, Color color, String imageUrl) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            _showSimpleDialog('🎉 ¡Genial!', 'Vamos a hacer: $title');
          },
          child: Row(
            children: [
              // IMAGEN
              ClipRRect(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                child: Container(
                  width: 140,
                  height: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: color.withOpacity(0.3),
                            child: Icon(Icons.fitness_center, size: 50, color: Colors.white),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              Colors.transparent,
                              color.withOpacity(0.1),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // TEXTO
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '¡ EMPEZAR !',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* Widget _buildBottomNav() {
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
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
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
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

   */

  void _showSimpleDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, textAlign: TextAlign.center),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF69B4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text('¡OK!', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}