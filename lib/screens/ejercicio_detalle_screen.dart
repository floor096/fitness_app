import 'package:flutter/material.dart';

class EjercicioDetalleScreen extends StatelessWidget {
  final Map<String, dynamic> ejercicio;

  const EjercicioDetalleScreen({
    Key? key,
    required this.ejercicio,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    Color colorPrincipal = _parseColor(ejercicio['color']);
    String imagenUrl = ejercicio['imagenUrl'] ?? '';
    String gifUrl = ejercicio['gifUrl'] ?? '';
    String emoji = ejercicio['emoji'] ?? '💪';
    List<dynamic> instrucciones = ejercicio['instrucciones'] ?? [];

    return Scaffold(
      backgroundColor: Color(0xFFFFF9F0),
      appBar: AppBar(
        backgroundColor: colorPrincipal,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          ejercicio['titulo'] ?? 'Ejercicio',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // IMAGEN/GIF GRANDE
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: colorPrincipal.withOpacity(0.2),
              ),
              child: (gifUrl.isNotEmpty)
                  ? Image.network(
                gifUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildImagenFallback(imagenUrl, emoji, colorPrincipal);
                },
              )
                  : _buildImagenFallback(imagenUrl, emoji, colorPrincipal),
            ),

            SizedBox(height: 25),

            // INFO DEL EJERCICIO
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITULO Y EMOJI
                  Row(
                    children: [
                      Text(
                        emoji,
                        style: TextStyle(fontSize: 40),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ejercicio['titulo'] ?? 'Sin título',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            /* SizedBox(height: 5),
                            Text(
                              ejercicio['subtitulo'] ?? '',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey.shade600,
                              ),
                            ),*/
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 25),

                  // STATS EN CARDS
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          '⏱️',
                          '${ejercicio['duracion'] ?? 5} min',
                          'Duración',
                          Color(0xFF4DD0E1),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: _buildStatCard(
                          '🔁',
                          '${ejercicio['repeticiones'] ?? 10}',
                          'Repeticiones',
                          Color(0xFFFF9800),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          '⭐',
                          '+${ejercicio['puntos'] ?? 20}',
                          'Puntos',
                          Color(0xFFFFD700),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: _buildStatCard(
                          '🎯',
                          ejercicio['categoria'] ?? 'Ejercicio',
                          'Categoría',
                          colorPrincipal,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30),

                  // INSTRUCCIONES
                  Text(
                    'Instrucciones',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 15),

                  ...instrucciones.asMap().entries.map((entry) {
                    int index = entry.key;
                    String instruccion = entry.value.toString();
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border(
                          left: BorderSide(
                            color: colorPrincipal,
                            width: 4,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: colorPrincipal,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              instruccion,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  SizedBox(height: 30),

                  // MENSAJE MOTIVACIONAL
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFD93D), Color(0xFFFFB74D)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFFF9800), width: 5),
                        right: BorderSide(color: Color(0xFFFF9800), width: 5),
                      ),
                    ),
                    child: Row(
                      children: [
                        /*Text('💪', style: TextStyle(fontSize: 35)),
                        SizedBox(width: 15),*/
                        Expanded(
                          child: Text(
                            '¡Vamos Patricio! Tú puedes con esto',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.brown.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // BOTON EMPEZAR
                  Container(
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorPrincipal, colorPrincipal.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      border: Border(
                        bottom: BorderSide(
                          color: colorPrincipal.withOpacity(0.5),
                          width: 6,
                        ),
                        right: BorderSide(
                          color: colorPrincipal.withOpacity(0.5),
                          width: 6,
                        ),
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
                        onTap: () {
                          // A ejercicio_activo_screen
                          _mostrarDialogoProximamente(context);
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.play_arrow,
                                size: 35,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'EMPEZAR',
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

                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagenFallback(String imagenUrl, String emoji, Color color) {
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
            child: Text(emoji, style: TextStyle(fontSize: 120)),
          );
        },
      );
    } else {
      return Center(
        child: Text(emoji, style: TextStyle(fontSize: 120)),
      );
    }
  }

  Widget _buildStatCard(String emoji, String valor, String label, Color color) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border(
          bottom: BorderSide(color: color.withOpacity(0.5), width: 3),
          right: BorderSide(color: color.withOpacity(0.5), width: 3),
        ),
      ),
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: 28)),
          SizedBox(height: 8),
          Text(
            valor,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoProximamente(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text(
          '🚧 Próximamente',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
        content: Text(
          'La pantalla de ejercicio activo estará disponible pronto',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF69B4),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                '¡Entendido!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}