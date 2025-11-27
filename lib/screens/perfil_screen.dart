import 'package:flutter/material.dart';
import 'ejercicios/ejercicios_screen.dart';
import 'home/home_screen.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/galeria_fotos_progreso.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  int _selectedIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF5F7),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER CON IMAGEN DE FONDO
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Imagen de fondo (portada)
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF69B4), Color(0xFFFFB6D9)],
                    ),
                  ),
                ),

                // Botón de configuración
                Positioned(
                  top: 40,
                  right: 15,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    /*child: IconButton(
                      icon: Icon(Icons.settings, color: Color(0xFFFF69B4)),
                      onPressed: () {
                        _showSimpleDialog(' Configuración', 'Aquí irán los ajustes');
                      },
                    ),*/
                  ),
                ),

                // FOTO DE PERFIL Y INFO
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      // Foto de perfil GRANDE
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Color(0xFFFFB6D9),
                          backgroundImage: AssetImage('assets/img/iconPatricio1.jpeg'),
                        ),
                      ),

                      SizedBox(height: 15),

                      // Nombre GRANDE
                      Text(
                        'Patricio Estrella',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      SizedBox(height: 25),
                      /*
                      // Stats en fila (GRANDES)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildBigStatItem('12', 'Ejercicios', '💪'),
                          SizedBox(width: 50),
                          _buildBigStatItem('5', 'Días', '🔥'),
                        ],
                      ),

                      SizedBox(height: 20),*/

                      // Badge de nivel MUY VISIBLE
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFFD54F), Color(0xFFFFB74D)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.4),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 10),
                            Text(
                              'PRINCIPIANTE',
                              style: TextStyle(
                                color: Colors.brown.shade800,
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 180),

            // SECCIÓN SIMPLE DE MI PROGRESO
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*Text(
                    'Mi Progreso',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 20),

                  // Cards GRANDES y simples
                  _buildSimpleStatCard(
                    '🔥 Racha Actual',
                    '5 días seguidos',
                    '¡Sigue así, estrella!',
                    Color(0xFFFF7043),
                  ),

                  _buildSimpleStatCard(
                    '⏱️ Tiempo Total',
                    '1 hora 20 minutos',
                    'Esta semana',
                    Color(0xFF4DD0E1),
                  ),

                  _buildSimpleStatCard(
                    '💪 Ejercicios Favoritos',
                    'Estiramientos',
                    'Lo que más haces',
                    Color(0xFF66BB6A),
                  ),*/

                  SizedBox(height: 50),

                  // FOTOS DE PROGRESO
                  GaleriaFotosProgreso(),

                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNav(currentIndex: 2), //Perfil
    );
  }

  Widget _buildBigStatItem(String value, String label, String emoji) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 36)),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF69B4),
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleStatCard(String title, String value, String subtitle, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              title.split(' ')[0],
              style: TextStyle(fontSize: 30),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.substring(2),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSimpleDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
        content: Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF69B4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: Text('¡Entendido!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}