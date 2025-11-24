import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/custom_bottom_nav.dart';

class RecompensasScreen extends StatefulWidget {
  @override
  _RecompensasScreenState createState() => _RecompensasScreenState();
}

class _RecompensasScreenState extends State<RecompensasScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Color _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) {
      return Color(0xFFFF69B4);
    }
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Color(0xFFFF69B4);
    }
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'star':
        return Icons.star;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'favorite':
        return Icons.favorite;
      case 'stars':
        return Icons.stars;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'military_tech':
        return Icons.military_tech;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF9F0),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER CON INFO
            StreamBuilder<DocumentSnapshot>(
              stream: _firestore.collection('estadisticas').doc('patricio').snapshots(),
              builder: (context, snapshot) {
                int puntosActuales = 0;

                if (snapshot.hasData && snapshot.data!.exists) {
                  Map<String, dynamic> stats = snapshot.data!.data() as Map<String, dynamic>;
                  puntosActuales = stats['puntosTotal'] ?? 0;
                }

                return Container(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Tus Logros',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
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
                                Icon(Icons.stars, color: Colors.white, size: 30),
                                SizedBox(width: 10),
                                Text(
                                  '$puntosActuales pts',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sigue ejercitando, Patricio',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: _firestore.collection('estadisticas').doc('patricio').snapshots(),
                builder: (context, statsSnapshot) {
                  Map<String, dynamic>? stats;

                  if (statsSnapshot.hasData && statsSnapshot.data!.exists) {
                    stats = statsSnapshot.data!.data() as Map<String, dynamic>;
                  }

                  // StreamBuilder para leer logros desde Firebase
                  return StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('logros').orderBy('orden').snapshots(),
                    builder: (context, logrosSnapshot) {
                      if (logrosSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFFF69B4),
                          ),
                        );
                      }

                      if (!logrosSnapshot.hasData || logrosSnapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.emoji_events_outlined,
                                size: 80,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'No hay logros disponibles',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      List<Map<String, dynamic>> logros = logrosSnapshot.data!.docs.map((doc) {
                        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                        data['docId'] = doc.id;
                        return data;
                      }).toList();

                      return SingleChildScrollView(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          children: [
                            ...logros.asMap().entries.map((entry) {
                              int index = entry.key;
                              Map<String, dynamic> logro = entry.value;
                              bool esUltimo = index == logros.length - 1;

                              // Determina si esta completado
                              bool completado = _verificarLogroCompletado(logro, stats);

                              // Determina  si es el actual
                              bool esActual = false;
                              if (!completado && index > 0) {
                                bool anteriorCompletado = _verificarLogroCompletado(logros[index - 1], stats);
                                esActual = anteriorCompletado;
                              } else if (!completado && index == 0) {
                                esActual = true;
                              }

                              return Column(
                                children: [
                                  _buildLogroItem(logro, completado, esActual),
                                  if (!esUltimo) _buildConnector(completado),
                                ],
                              );
                            }).toList(),

                            SizedBox(height: 100),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 1),
    );
  }

  bool _verificarLogroCompletado(Map<String, dynamic> logro, Map<String, dynamic>? stats) {
    if (stats == null) return false;

    Map<String, dynamic> requisito = logro['requisito'];
    String tipo = requisito['tipo'];
    int cantidad = requisito['cantidad'];

    switch (tipo) {
      case 'ejercicios_completados':
        return (stats['ejerciciosCompletados'] ?? 0) >= cantidad;
      case 'racha':
        return (stats['rachaActual'] ?? 0) >= cantidad;
      case 'puntos':
        return (stats['puntosTotal'] ?? 0) >= cantidad;
      default:
        return false;
    }
  }

  Widget _buildLogroItem(Map<String, dynamic> logro, bool completado, bool esActual) {
    bool bloqueado = !completado && !esActual;

    Color colorPrincipal = bloqueado
        ? Colors.grey.shade300
        : _parseColor(logro['color']);
    Color colorBorde = bloqueado
        ? Colors.grey.shade500
        : _parseColor(logro['color']);
    IconData icono = _getIcon(logro['iconName'] ?? 'star');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  ICONO GRANDE
          Column(
            children: [
              Container(
                width: 80,
                height: 80,
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
                        size: 40,
                        color: Colors.white,
                      )
                          : bloqueado
                          ? Icon(
                        Icons.lock,
                        size: 40,
                        color: Colors.grey.shade600,
                      )
                          : Icon(
                        icono,
                        size: 40,
                        color: Colors.white,
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
              margin: EdgeInsets.only(top: 3),
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
                          logro['titulo'] ?? 'Sin título',
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
                            '+${logro['puntos'] ?? 0} pts',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: colorPrincipal,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    logro['subtitulo'] ?? 'Sin descripción',
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
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ],
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
                            fontSize: 18,
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
}