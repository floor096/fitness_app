import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EjercicioActivoScreen extends StatefulWidget {
  final Map<String, dynamic> ejercicio;

  const EjercicioActivoScreen({
    Key? key,
    required this.ejercicio,
  }) : super(key: key);

  @override
  _EjercicioActivoScreenState createState() => _EjercicioActivoScreenState();
}

class _EjercicioActivoScreenState extends State<EjercicioActivoScreen> {
  Timer? _timer;
  int _segundosRestantes = 0;
  int _duracionTotal = 0;
  bool _enProgreso = false;
  bool _pausado = false;
  DateTime? _fechaInicio;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _duracionTotal = (widget.ejercicio['duracion'] ?? 5) * 60;
    _segundosRestantes = _duracionTotal;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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

  IconData _getIcon(String? iconName) {
    switch (iconName?.toLowerCase()) {
      case 'run':
      case 'cardio':
        return Icons.directions_run;
      case 'yoga':
      case 'estiramiento':
        return Icons.self_improvement;
      case 'strength':
      case 'fuerza':
        return Icons.fitness_center;
      case 'walk':
      case 'caminar':
        return Icons.directions_walk;
      default:
        return Icons.fitness_center;
    }
  }

  void _iniciarEjercicio() {
    setState(() {
      _enProgreso = true;
      _pausado = false;
      _fechaInicio = DateTime.now();
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_segundosRestantes > 0) {
          _segundosRestantes--;
        } else {
          _completarEjercicio();
        }
      });
    });
  }

  void _pausarEjercicio() {
    setState(() {
      _pausado = true;
    });
    _timer?.cancel();
  }

  void _reanudarEjercicio() {
    setState(() {
      _pausado = false;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_segundosRestantes > 0) {
          _segundosRestantes--;
        } else {
          _completarEjercicio();
        }
      });
    });
  }

  void _abandonarEjercicio() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFFF9800), size: 30),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                '¿Abandonar ejercicio?',
                style: TextStyle(fontSize: 22),
              ),
            ),
          ],
        ),
        content: Text(
          'Si abandonas ahora, no ganarás puntos. ¿Estás seguro?',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Continuar',
              style: TextStyle(fontSize: 18, color: Color(0xFF4CAF50)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _guardarEjercicioAbandonado();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF5252),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              'Abandonar',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _guardarEjercicioAbandonado() async {
    _timer?.cancel();

    try {
      DateTime fechaFin = DateTime.now();
      int tiempoReal = _duracionTotal - _segundosRestantes;

      // Guardar en ejercicios_completados como abandonado
      await _firestore.collection('ejercicios_completados').add({
        'ejercicioId': widget.ejercicio['id'],
        'titulo': widget.ejercicio['titulo'],
        'categoria': widget.ejercicio['categoria'],
        'puntos': 0,
        'duracionMinutos': widget.ejercicio['duracion'],
        'fechaInicio': _fechaInicio,
        'fechaFin': fechaFin,
        'tiempoReal': tiempoReal,
        'completado': false,
        'color': widget.ejercicio['color'],
        'iconName': widget.ejercicio['iconName'],
      });

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No te preocupes, ¡la próxima lo lograrás!'),
          backgroundColor: Color(0xFFFF9800),
        ),
      );
    } catch (e) {
      print('Error al guardar ejercicio abandonado: $e');
    }
  }

  Future<void> _completarEjercicio() async {
    _timer?.cancel();

    try {
      DateTime fechaFin = DateTime.now();
      int tiempoReal = _duracionTotal - _segundosRestantes;
      int puntosGanados = widget.ejercicio['puntos'] ?? 20;

      // 1. Guardar en ejercicios_completados
      await _firestore.collection('ejercicios_completados').add({
        'ejercicioId': widget.ejercicio['id'],
        'titulo': widget.ejercicio['titulo'],
        'categoria': widget.ejercicio['categoria'],
        'puntos': puntosGanados,
        'duracionMinutos': widget.ejercicio['duracion'],
        'fechaInicio': _fechaInicio,
        'fechaFin': fechaFin,
        'tiempoReal': tiempoReal,
        'completado': true,
        'color': widget.ejercicio['color'],
        'iconName': widget.ejercicio['iconName'],
      });

      // 2. Actualizar estadísticas del usuario
      DocumentReference statsRef = _firestore.collection('estadisticas').doc('patricio');

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot statsSnapshot = await transaction.get(statsRef);

        if (!statsSnapshot.exists) {
          // Crear documento si no existe
          transaction.set(statsRef, {
            'puntosTotal': puntosGanados,
            'ejerciciosCompletados': 1,
            'tiempoTotalMinutos': widget.ejercicio['duracion'],
            'rachaActual': 1,
            'mejorRacha': 1,
            'ultimaActividad': fechaFin,
            'nivel': 1,
            'experiencia': puntosGanados,
            'fechaRegistro': DateTime.now(),
          });
        } else {
          // Actualizar estadísticas existentes
          Map<String, dynamic> stats = statsSnapshot.data() as Map<String, dynamic>;

          int nuevoPuntosTotal = (stats['puntosTotal'] ?? 0) + puntosGanados;
          int nuevoEjerciciosCompletados = (stats['ejerciciosCompletados'] ?? 0) + 1;
          int nuevoTiempoTotal = (stats['tiempoTotalMinutos'] ?? 0) + widget.ejercicio['duracion'];

          // Calcular racha
          DateTime? ultimaActividad = (stats['ultimaActividad'] as Timestamp?)?.toDate();
          int rachaActual = stats['rachaActual'] ?? 0;

          if (ultimaActividad != null) {
            int diferenciaDias = fechaFin.difference(ultimaActividad).inDays;
            if (diferenciaDias == 1) {
              rachaActual++;
            } else if (diferenciaDias > 1) {
              rachaActual = 1;
            }
          } else {
            rachaActual = 1;
          }

          int mejorRacha = rachaActual > (stats['mejorRacha'] ?? 0)
              ? rachaActual
              : (stats['mejorRacha'] ?? 0);

          // Calcular nivel (cada 100 puntos = 1 nivel)
          int nivel = (nuevoPuntosTotal / 100).floor() + 1;

          transaction.update(statsRef, {
            'puntosTotal': nuevoPuntosTotal,
            'ejerciciosCompletados': nuevoEjerciciosCompletados,
            'tiempoTotalMinutos': nuevoTiempoTotal,
            'rachaActual': rachaActual,
            'mejorRacha': mejorRacha,
            'ultimaActividad': fechaFin,
            'nivel': nivel,
            'experiencia': nuevoPuntosTotal,
          });
        }
      });

      // 3. Navegar a pantalla de ejercicio completado (próximamente)
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.white),
              SizedBox(width: 20),
              Text('¡Ejercicio completado! +$puntosGanados puntos'),
            ],
          ),
          backgroundColor: Color(0xFF4CAF50),
          duration: Duration(seconds: 3),
        ),
      );

    } catch (e) {
      print('Error al completar ejercicio: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar el ejercicio'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatearTiempo(int segundos) {
    int minutos = segundos ~/ 60;
    int segs = segundos % 60;
    return '${minutos.toString().padLeft(2, '0')}:${segs.toString().padLeft(2, '0')}';
  }

  double _obtenerProgreso() {
    return 1 - (_segundosRestantes / _duracionTotal);
  }

  @override
  Widget build(BuildContext context) {
    Color colorPrincipal = _parseColor(widget.ejercicio['color']);
    String imagenUrl = widget.ejercicio['imagenUrl'] ?? '';
    String gifUrl = widget.ejercicio['gifUrl'] ?? '';
    String iconName = widget.ejercicio['iconName'] ?? '';
    IconData iconoPrincipal = _getIcon(iconName);
    int puntosGanados = widget.ejercicio['puntos'] ?? 20;

    return WillPopScope(
      onWillPop: () async {
        if (_enProgreso && !_pausado) {
          _pausarEjercicio();
          bool? salir = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              title: Text('¿Salir del ejercicio?'),
              content: Text('El ejercicio está en progreso. ¿Quieres abandonarlo?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                    _reanudarEjercicio();
                  },
                  child: Text('Continuar ejercicio'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Salir', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
          return salir ?? false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFFFF9F0),
        appBar: AppBar(
          backgroundColor: colorPrincipal,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () {
              if (_enProgreso && !_pausado) {
                _pausarEjercicio();
              }
              Navigator.pop(context);
            },
          ),
          title: Row(
            children: [
              Icon(iconoPrincipal, color: Colors.white, size: 28),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.ejercicio['titulo'] ?? 'Ejercicio',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // IMAGEN/GIF GRANDE
              Container(
                width: double.infinity,
                height: 330,
                decoration: BoxDecoration(
                  color: colorPrincipal.withOpacity(0.2),
                ),
                child: (gifUrl.isNotEmpty)
                    ? Image.network(
                  gifUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImagenFallback(imagenUrl, iconoPrincipal, colorPrincipal);
                  },
                )
                    : _buildImagenFallback(imagenUrl, iconoPrincipal, colorPrincipal),
              ),

              SizedBox(height: 8),

              // TIMER GRANDE
              Container(
                padding: EdgeInsets.all(25),
                margin: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorPrincipal, colorPrincipal.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border(
                    bottom: BorderSide(color: colorPrincipal.withOpacity(0.5), width: 5),
                    right: BorderSide(color: colorPrincipal.withOpacity(0.5), width: 5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorPrincipal.withOpacity(0.3),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'TIEMPO RESTANTE',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _formatearTiempo(_segundosRestantes),
                      style: TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // BARRA DE PROGRESO
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: LinearProgressIndicator(
                        value: _obtenerProgreso(),
                        minHeight: 20,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(colorPrincipal),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${(_obtenerProgreso() * 100).toInt()}% completado',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // INDICADOR DE PUNTOS
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFD93D), Color(0xFFFFB74D)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFFF9800), width: 4),
                    right: BorderSide(color: Color(0xFFFF9800), width: 4),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.stars, size: 30, color: Colors.brown.shade800),
                    SizedBox(width: 10),
                    Text(
                      'Ganarás +$puntosGanados puntos',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.shade800,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // BOTONES DE CONTROL
              if (!_enProgreso) ...[
                // BOTÓN COMENZAR
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorPrincipal, colorPrincipal.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      border: Border(
                        bottom: BorderSide(color: colorPrincipal.withOpacity(0.5), width: 6),
                        right: BorderSide(color: colorPrincipal.withOpacity(0.5), width: 6),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorPrincipal.withOpacity(0.4),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: _iniciarEjercicio,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_arrow, size: 35, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'COMENZAR',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // BOTONES PAUSAR/REANUDAR Y ABANDONAR
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 60,
                          child: ElevatedButton.icon(
                            onPressed: _pausado ? _reanudarEjercicio : _pausarEjercicio,
                            icon: Icon(
                              _pausado ? Icons.play_arrow : Icons.pause,
                              size: 28,
                              color: Colors.white,
                            ),
                            label: Text(
                              _pausado ? 'REANUDAR' : 'PAUSAR',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _pausado ? Color(0xFF4CAF50) : Color(0xFFFF9800),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 8,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: _abandonarEjercicio,
                          icon: Icon(Icons.close, size: 28, color: Colors.white),
                          label: Text(
                            'SALIR',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF5252),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 8,
                            padding: EdgeInsets.symmetric(horizontal: 25),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12),

                // BOTÓN TERMINAR AHORA
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _pausarEjercicio();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            title: Row(
                              children: [
                                Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 30),
                                SizedBox(width: 10),
                                Text('¿Terminar ahora?'),
                              ],
                            ),
                            content: Text(
                              '¿Ya completaste todas las repeticiones? Ganarás +$puntosGanados puntos.',
                              style: TextStyle(fontSize: 18),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _reanudarEjercicio();
                                },
                                child: Text(
                                  'Continuar',
                                  style: TextStyle(fontSize: 18, color: Colors.grey),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _completarEjercicio();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF4CAF50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  'Terminar',
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.check_circle_outline, size: 28, color: Colors.white),
                      label: Text(
                        'TERMINAR AHORA',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 8,
                      ),
                    ),
                  ),
                ),
              ],

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagenFallback(String imagenUrl, IconData icono, Color color) {
    if (imagenUrl.isNotEmpty) {
      return Image.network(
        imagenUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(color: color),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(icono, size: 100, color: color),
          );
        },
      );
    } else {
      return Center(
        child: Icon(icono, size: 100, color: color),
      );
    }
  }
}