import 'package:fitness_app/screens/home/widgets/BreathingCard.dart';
import 'package:fitness_app/screens/home/widgets/InsigniaGradient.dart';
import 'package:fitness_app/screens/home/widgets/MotivationalSwitcher.dart';
import 'package:fitness_app/screens/home/widgets/QuickOption.dart';
import 'package:fitness_app/screens/home/widgets/TrainingCard.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../services/servicio_almacenamiento_fotos.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../ejercicios/ejercicios_screen.dart';
import '../perfil_screen.dart';
import '../alarmas/alarmas_screen.dart';
import '../ajustes_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;
  //late Timer _fraseTimer;
  int _fraseActual = 0;


  @override
  void initState() {
    super.initState();

    // Sincronizar fotos con Supabase al iniciar la app
    ServicioAlmacenamientoFotos().sincronizarConSupabase();

    // Animación de "respiración" para Patricio
    _breathController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _breathAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    // Timer para cambiar frases cada 5 segundos
    //_fraseTimer = Timer.periodic(Duration(seconds: 5), (timer) {
    //  setState(() {
    //    _fraseActual = (_fraseActual + 1) % frases.length;
    //  });
    //});
  }

  @override
  void dispose() {
    _breathController.dispose();
    //_fraseTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF9F0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),

                // SALUDO GRANDE
                Text(
                  '¡Bienvenido!',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Hoy es un buen día.',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.grey.shade600,
                  ),
                ),

                SizedBox(height: 15),

                // PATRICIO ANIMADO CON ILUSTRACIÓN
                BreathingCard(breathAnimation: _breathAnimation),

                SizedBox(height: 30),

                // FRASE MOTIVACIONAL QUE CAMBIA
                MotivationalSwitcher(),

                SizedBox(height: 40),

                /*
                // TÍTULO DE SECCIÓN
                Text(
                  'Tus Logros',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                /*Text(
                  'Sigue así, estrella de mar',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.grey.shade600,
                  ),
                ),*/

                //SizedBox(height: 12),

                // GRID DE INSIGNIAS (2x2)
                Row(
                  children: [
                    Expanded(
                      child: InsigniaGradient(
                        emoji: '🔥',
                        valor: '5 días',
                        label: 'Racha Activa',
                        gradient: [Color(0xFFFF6B6B), Color(0xFFFF4757)],
                        desbloqueado: true,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: InsigniaGradient(
                        emoji: '💪',
                        valor: '12',
                        label: 'Ejercicios',
                        gradient: [Color(0xFFFF69B4), Color(0xFFFF1493)],
                        desbloqueado: true,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: InsigniaGradient(
                        emoji: '⏱️',
                        valor: '1h 20m',
                        label: 'Tiempo Total',
                        gradient: [Color(0xFF4DD0E1), Color(0xFF00ACC1)],
                        desbloqueado: true,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: InsigniaGradient(
                        emoji: '⭐',
                        valor: 'Nivel 2',
                        label: '100 pts más',
                        gradient: [Color(0xFFE0E0E0), Color(0xFFBDBDBD)],
                        desbloqueado: false,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 40),*/

                // ENTRENAR AHORA
                Text(
                  'Entrenar Ahora',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: 14),

                // CARD GRANDE PARA IR A EJERCICIOS
                TrainingCard(),

                SizedBox(height: 25),

                // ACCESOS RÁPIDOS
                QuickOption(
                  emoji: '📸',
                  titulo: 'Ver mi Progreso',
                  subtitulo: 'Fotos antes y después',
                  gradient: [Color(0xFFFFB6D9), Color(0xFFFF69B4)],
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, anim1, anim2) => PerfilScreen(),
                        transitionDuration: Duration.zero,
                      ),
                    );
                  },
                ),

                SizedBox(height: 15),

                QuickOption(
                  emoji: '⏰',
                  titulo: 'Mis Alarmas',
                  subtitulo: 'Recordatorios de ejercicio',
                  gradient: [Color(0xFFFFD93D), Color(0xFFFFB74D)],
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, anim1, anim2) => AlarmasScreen(),
                        transitionDuration: Duration.zero,
                      ),
                    );
                  },
                ),

                /*SizedBox(height: 15),

                QuickOption(
                  emoji: '⚙️',
                  titulo: 'Ajustes',
                  subtitulo: 'Notificaciones y sonidos',
                  gradient: [Color(0xFF9E9E9E), Color(0xFF757575)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AjustesScreen()),
                    );
                  },
                ),

                 */

                SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 0),
    );
  }

  void _showSimpleDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF69B4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                '¡Entendido!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}