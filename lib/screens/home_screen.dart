/*
// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'ejercicios_screen.dart';
import 'perfil_screen.dart';
import '../widgets/custom_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  /*void _onNavTap(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    Widget screen;
    switch (index) {
      case 1:
        screen = EjerciciosScreen();
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

   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF5F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER CON SALUDO
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¡Hola Patricio!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Hoy es un buen día para ejercitar',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(0.3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.notifications, color: Color(0xFFFF69B4), size: 28),
                        onPressed: () {
                          _showSimpleDialog('🔔 Notificaciones', 'No tienes nuevas notificaciones');
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30),

                // CARD DE MOTIVACIÓN GRANDE
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF69B4), Color(0xFFE91E63)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.4),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('🌟', style: TextStyle(fontSize: 40)),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '¡Llevas 5 días seguidos!',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Eres una estrella de mar campeona',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text('🔥', style: TextStyle(fontSize: 20)),
                          Text('🔥', style: TextStyle(fontSize: 20)),
                          Text('🔥', style: TextStyle(fontSize: 20)),
                          Text('🔥', style: TextStyle(fontSize: 20)),
                          Text('🔥', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 10),
                          Text(
                            '5 DÍAS',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                // SECCIÓN HOY
                Text(
                  'Ejercicio de Hoy',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: 15),

                // CARD DE EJERCICIO SUGERIDO - MUY GRANDE
                Container(
                  width: double.infinity,
                  height: 230,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EjerciciosScreen()),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF66BB6A).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),

                                    child: Text(
                                      'RECOMENDADO',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF66BB6A),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Estiramientos\nMatutinos',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      height: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time, size: 16, color: Colors.grey),
                                      SizedBox(width: 5),
                                      Text(
                                        '5 minutos',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Icon(Icons.favorite, size: 16, color: Colors.pink),
                                      SizedBox(width: 5),
                                      Text(
                                        'Fácil',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFF69B4),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '¡EMPEZAR AHORA!',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 15),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                'https://ih1.redbubble.net/image.3791362301.1816/bg,f8f8f8-flat,750x,075,f-pad,750x1000,f8f8f8.u2.jpg',
                                width: 150,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 100,
                                    color: Color(0xFFFFB6D9),
                                    child: Icon(Icons.star_half, size: 50, color: Colors.white),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // TUS STATS - SIMPLE
                Text(
                  'Mi Progreso',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: 15),

                // GRID DE STATS GRANDES
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        Icons.fitness_center_rounded,
                        '12',
                        'Ejercicios',
                        Color(0xFFFF7043),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: _buildStatCard(
                        Icons.timelapse_outlined,
                        '1:20',
                        'Horas',
                        Color(0xFF4DD0E1),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        Icons.local_fire_department,
                        '350',
                        'Calorías',
                        Color(0xFFFFD54F),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: _buildStatCard(
                        Icons.auto_graph,
                        '-2kg',
                        'Progreso',
                        Color(0xFF66BB6A),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30),

                // ACCESOS RÁPIDOS
                Text(
                  'Accesos Rápidos',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: 15),

                _buildQuickAccessCard(
                  '',
                  'Reservar Maquina',
                  'Vamos a ejercitar musculos.',
                  Color(0xFFFFD54F),
                ),
/*
                _buildQuickAccessCard(
                  '',
                  'Fotos de Progreso',
                  'Ve cuánto has mejorado',
                  Color(0xFFFF69B4),
                ),

                _buildQuickAccessCard(
                  '',
                  'Mis Objetivos',
                  'Peso, tiempo, etc.',
                  Color(0xFF4DD0E1),
                ),
*/
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),

      /* bottomNavigationBar: _buildBottomNav(), */
      bottomNavigationBar: CustomBottomNav(currentIndex: 0),  // 0 = Home
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, Color color) {
    return Container(
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
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 40,
          ),
          SizedBox(height: 10),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard(String emoji, String title, String subtitle, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            _showSimpleDialog('$emoji $title', 'Próximamente disponible');
          },
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(emoji, style: TextStyle(fontSize: 28)),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 24),
              ],
            ),
          ),
        ),
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

 */

// lib/screens/home_screen.dart
// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/custom_bottom_nav.dart';
import 'ejercicios_screen.dart';
import 'perfil_screen.dart';
import 'alarmas_screen.dart';
import 'ajustes_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;
  late Timer _fraseTimer;
  int _fraseActual = 0;

  // Frases motivacionales para Patricio
  List<Map<String, String>> frases = [
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

  @override
  void initState() {
    super.initState();

    // Animación de "respiración" para Patricio
    _breathController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _breathAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    // Timer para cambiar frases cada 5 segundos
    _fraseTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _fraseActual = (_fraseActual + 1) % frases.length;
      });
    });
  }

  @override
  void dispose() {
    _breathController.dispose();
    _fraseTimer.cancel();
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
                  '¡Hola Patricio!',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Hoy es un buen día para ejercitar',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),

                SizedBox(height: 30),

                // PATRICIO ANIMADO CON ILUSTRACIÓN
                AnimatedBuilder(
                  animation: _breathAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _breathAnimation.value,
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
                ),

                SizedBox(height: 30),

                // FRASE MOTIVACIONAL QUE CAMBIA
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 600),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    key: ValueKey<int>(_fraseActual),
                    width: double.infinity,
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFD93D), Color(0xFFFFB74D)],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFFF9800), width: 5),
                        right: BorderSide(color: Color(0xFFFF9800), width: 5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          frases[_fraseActual]['emoji']!,
                          style: TextStyle(fontSize: 50),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            frases[_fraseActual]['texto']!,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.brown.shade800,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 40),

                // TÍTULO DE SECCIÓN
                Text(
                  'Tus Logros',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Sigue así, estrella de mar',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.shade600,
                  ),
                ),

                SizedBox(height: 25),

                // GRID DE INSIGNIAS CON GRADIENTES (2x2)
                Row(
                  children: [
                    Expanded(
                      child: _buildInsigniaGradient(
                        '🔥',
                        '5 días',
                        'Racha Activa',
                        [Color(0xFFFF6B6B), Color(0xFFFF4757)],
                        true,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: _buildInsigniaGradient(
                        '💪',
                        '12',
                        'Ejercicios',
                        [Color(0xFFFF69B4), Color(0xFFFF1493)],
                        true,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: _buildInsigniaGradient(
                        '⏱️',
                        '1h 20m',
                        'Tiempo Total',
                        [Color(0xFF4DD0E1), Color(0xFF00ACC1)],
                        true,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: _buildInsigniaGradient(
                        '⭐',
                        'Nivel 2',
                        '100 pts más',
                        [Color(0xFFE0E0E0), Color(0xFFBDBDBD)],
                        false,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 40),

                // ENTRENAR AHORA
                Text(
                  'Entrenar Ahora',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: 20),

                // CARD GRANDE PARA IR A EJERCICIOS
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF69B4), Color(0xFFFF1493)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFC2185B), width: 6),
                      right: BorderSide(color: Color(0xFFC2185B), width: 6),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, anim1, anim2) => EjerciciosScreen(),
                            transitionDuration: Duration.zero,
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.fitness_center,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 25),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ver Ejercicios',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Elige tu ejercicio de hoy',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 25),

                // ACCESOS RÁPIDOS
                _buildQuickOption(
                  '📸',
                  'Ver mi Progreso',
                  'Fotos antes y después',
                  [Color(0xFFFFB6D9), Color(0xFFFF69B4)],
                      () {
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

                _buildQuickOption(
                  '⏰',
                  'Mis Alarmas',
                  'Recordatorios de ejercicio',
                  [Color(0xFFFFD93D), Color(0xFFFFB74D)],
                      () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, anim1, anim2) => AlarmasScreen(),
                        transitionDuration: Duration.zero,
                      ),
                    );
                  },
                ),

                SizedBox(height: 15),

                /*
                _buildQuickOption(
                  '⚙️',
                  'Ajustes',
                  'Notificaciones y sonidos',
                  [Color(0xFF9E9E9E), Color(0xFF757575)],
                      () {
                    _showSimpleDialog(
                      '⚙️ Ajustes',
                      'La pantalla de ajustes estará disponible próximamente',
                    );
                  },
                ),

                 */
                _buildQuickOption(
                  '⚙️',
                  'Ajustes',
                  'Notificaciones y sonidos',
                  [Color(0xFF9E9E9E), Color(0xFF757575)],
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AjustesScreen()),
                    );
                  },
                ),

                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 0),
    );
  }

  Widget _buildInsigniaGradient(
      String emoji,
      String valor,
      String label,
      List<Color> gradient,
      bool desbloqueado,
      ) {
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
        padding: EdgeInsets.all(20),
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
            SizedBox(height: 10),
            Text(
              valor,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: desbloqueado ? Colors.white : Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
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

  Widget _buildQuickOption(
      String emoji,
      String titulo,
      String subtitulo,
      List<Color> gradient,
      VoidCallback onTap,
      ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border(
          bottom: BorderSide(color: gradient[1], width: 5),
          right: BorderSide(color: gradient[1], width: 5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(22),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(emoji, style: TextStyle(fontSize: 32)),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        subtitulo,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white.withOpacity(0.8),
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
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