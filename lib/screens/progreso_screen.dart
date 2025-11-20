import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';

class ProgresoScreen extends StatefulWidget {
  @override
  _ProgresoScreenState createState() => _ProgresoScreenState();
}

class _ProgresoScreenState extends State<ProgresoScreen> {
  // Lista de niveles/logros en el camino
  List<Map<String, dynamic>> niveles = [
    {
      'id': 1,
      'titulo': 'Primera Estrella',
      'subtitulo': 'Completa tu primer ejercicio',
      'emoji': '⭐',
      'puntos': 10,
      'completado': true,
      'color': Color(0xFFFFD700),
    },
    {
      'id': 2,
      'titulo': 'Racha de 3 Días',
      'subtitulo': 'Ejercita 3 días seguidos',
      'emoji': '🔥',
      'puntos': 30,
      'completado': true,
      'color': Color(0xFFFF6347),
    },
    {
      'id': 3,
      'titulo': 'Guerrero de Fondo de Bikini',
      'subtitulo': 'Completa 10 ejercicios',
      'emoji': '💪',
      'puntos': 50,
      'completado': true,
      'color': Color(0xFFFF69B4),
    },
    {
      'id': 4,
      'titulo': 'Amigo de Bob Esponja',
      'subtitulo': 'Racha de 5 días',
      'emoji': '🧽',
      'puntos': 75,
      'completado': false,
      'actual': true,
      'color': Color(0xFFFFD93D),
    },
    {
      'id': 5,
      'titulo': 'Súper Estrella',
      'subtitulo': 'Alcanza 100 puntos',
      'emoji': '🌟',
      'puntos': 100,
      'completado': false,
      'color': Color(0xFF9C27B0),
    },
    {
      'id': 6,
      'titulo': 'Maestro del Ejercicio',
      'subtitulo': 'Completa 30 ejercicios',
      'emoji': '🏆',
      'puntos': 150,
      'completado': false,
      'color': Color(0xFF4CAF50),
    },
    {
      'id': 7,
      'titulo': 'Leyenda de Bikini Bottom',
      'subtitulo': 'Racha de 30 días',
      'emoji': '👑',
      'puntos': 300,
      'completado': false,
      'color': Color(0xFFFF9800),
    },
  ];

  @override
  Widget build(BuildContext context) {
    int puntosActuales = niveles
        .where((n) => n['completado'] == true)
        .fold(0, (sum, n) => sum + (n['puntos'] as int));

    return Scaffold(
      backgroundColor: Color(0xFFFFF9F0),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER CON INFO
            Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF69B4), Color(0xFFFF1493)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                border: Border(
                  bottom: BorderSide(color: Color(0xFFC2185B), width: 6),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Mi Camino',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border(
                            bottom: BorderSide(color: Colors.white.withOpacity(0.5), width: 3),
                            right: BorderSide(color: Colors.white.withOpacity(0.5), width: 3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text('⭐', style: TextStyle(fontSize: 24)),
                            SizedBox(width: 10),
                            Text(
                              '$puntosActuales puntos',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Sigue subiendo, Patricio',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // CAMINO/PATH CON SCROLL
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    ...niveles.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> nivel = entry.value;
                      bool esUltimo = index == niveles.length - 1;

                      return Column(
                        children: [
                          _buildNivelItem(nivel),
                          if (!esUltimo) _buildConnector(nivel['completado']),
                        ],
                      );
                    }).toList(),

                    SizedBox(height: 30),

                    /*
                    // MENSAJE FINAL
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
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
                      child: Column(
                        children: [
                          Text('🎉', style: TextStyle(fontSize: 50)),
                          SizedBox(height: 15),
                          Text(
                            '¡Más logros próximamente!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown.shade800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Sigue ejercitando para desbloquear nuevos logros',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.brown.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ), */

                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 1),
    );
  }

  Widget _buildNivelItem(Map<String, dynamic> nivel) {
    bool esActual = nivel['actual'] ?? false;
    bool completado = nivel['completado'] ?? false;
    bool bloqueado = !completado && !esActual;

    Color colorPrincipal = bloqueado ? Colors.grey.shade300 : nivel['color'];
    Color colorBorde = bloqueado ? Colors.grey.shade500 : nivel['color'];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CÍRCULO GRANDE CON EMOJI
          Column(
            children: [
              Container(
                width: esActual ? 80 : 80,
                height: esActual ? 80 : 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: bloqueado
                      ? null
                      : LinearGradient(
                    colors: [
                      colorPrincipal,
                      colorPrincipal.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  color: bloqueado ? Colors.grey.shade300 : null,
                  border: Border.all(
                    color: Colors.white,
                    width: 5,
                  ),
                  boxShadow: esActual
                      ? [
                    BoxShadow(
                      color: colorPrincipal.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ]
                      : [],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: completado
                          ? Icon(
                        Icons.check_circle,
                        size: esActual ? 50 : 40,
                        color: Colors.white,
                      )
                          : bloqueado
                          ? Icon(
                        Icons.lock,
                        size: 40,
                        color: Colors.grey.shade600,
                      )
                          : Text(
                        nivel['emoji'],
                        style: TextStyle(fontSize: esActual ? 50 : 40),
                      ),
                    ),
                    if (esActual)
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(width: 8),

          // CARD CON INFO
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border(
                  bottom: BorderSide(
                    color: bloqueado ? Colors.grey.shade400 : colorBorde,
                    width: 4,
                  ),
                  right: BorderSide(
                    color: bloqueado ? Colors.grey.shade400 : colorBorde,
                    width: 4,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          nivel['titulo'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: bloqueado ? Colors.grey.shade600 : Colors.black87,
                          ),
                        ),
                      ),
                      if (!bloqueado)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: colorPrincipal.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            '+${nivel['puntos']} pts',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorPrincipal,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    nivel['subtitulo'],
                    style: TextStyle(
                      fontSize: 18,
                      color: bloqueado ? Colors.grey.shade500 : Colors.grey.shade700,
                    ),
                  ),

                  if (completado) ...[
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.check_circle, size: 18, color: Color(0xFF4CAF50)),
                        SizedBox(width: 8),
                        Text(
                          '¡Completado!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                  ],

                  if (esActual) ...[
                    SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _showSimpleDialog(
                            '¡Vamos Patricio!',
                            'Sigue ejercitando para completar este logro',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorPrincipal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'CONTINUAR',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],

                  if (bloqueado) ...[
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.lock_outline, size: 18, color: Colors.grey.shade600),
                        SizedBox(width: 8),
                        Text(
                          'Bloqueado',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnector(bool completado) {
    return Container(
      margin: EdgeInsets.only(left: 60),
      width: 6,
      height: 50,
      decoration: BoxDecoration(
        gradient: completado
            ? LinearGradient(
          colors: [Color(0xFFFF69B4), Color(0xFFFF69B4).withOpacity(0.5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )
            : null,
        color: completado ? null : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(3),
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
