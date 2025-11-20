import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/custom_bottom_nav.dart';
import 'ejercicio_detalle_screen.dart';

class EjerciciosScreen extends StatefulWidget {
  @override
  _EjerciciosScreenState createState() => _EjerciciosScreenState();
}

class _EjerciciosScreenState extends State<EjerciciosScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> ejercicios = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarEjercicios();
  }

  Future<void> _cargarEjercicios() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('ejercicios')
          .orderBy('orden')
          .get();

      setState(() {
        ejercicios = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Agregar el id del documento
          return data;
        }).toList();
        isLoading = false;
      });

      print('✅ ${ejercicios.length} ejercicios cargados');
    } catch (e) {
      print('❌ Error al cargar ejercicios: $e');
      setState(() {
        isLoading = false;
      });

      // mostrar mensaje al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar ejercicios'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
            icon: Icon(Icons.refresh, color: Colors.white, size: 28),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              _cargarEjercicios();
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFFFF69B4),
            ),
            SizedBox(height: 20),
            Text(
              'Cargando ejercicios...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      )
          : ejercicios.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('😢', style: TextStyle(fontSize: 80)),
            SizedBox(height: 20),
            Text(
              'No hay ejercicios disponibles',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Agrega ejercicios en Firestore',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _cargarEjercicios,
              icon: Icon(Icons.refresh),
              label: Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF69B4),
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
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
                border: Border(
                  bottom: BorderSide(color: Color(0xFFFF9800), width: 5),
                  right: BorderSide(color: Color(0xFFFF9800), width: 5),
                ),
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
                          '¡Bien hecho, Patricio!',
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

            // CONTADOR DE EJERCICIOS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Elige tu Ejercicio',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFFF69B4).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${ejercicios.length} disponibles',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // LISTA DE EJERCICIOS DESDE FIRESTORE
            ...ejercicios.map((ejercicio) {
              return _buildBigCategoryCard(
                ejercicio['emoji'] ?? '💪',
                ejercicio['titulo'] ?? 'Sin título',
                ejercicio['subtitulo'] ?? 'Sin descripción',
                _parseColor(ejercicio['color']),
                ejercicio['imagenUrl'] ?? '',
              );
            }).toList(),

            SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 1),
    );
  }

  Color _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) {
      return Color(0xFFFF69B4); // Color por defecto
    }

    try {
      // Convierte "#4DD0E1" a Color
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Color(0xFFFF69B4); // Color por defecto si falla
    }
  }

  Widget _buildBigCategoryCard(
      String emoji,
      String title,
      String subtitle,
      Color color,
      String imageUrl,
      ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border(
          bottom: BorderSide(color: color.withOpacity(0.5), width: 4),
          right: BorderSide(color: color.withOpacity(0.5), width: 4),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EjercicioDetalleScreen(
                  ejercicio: ejercicios.firstWhere(
                        (e) => e['titulo'] == title,
                    orElse: () => {},
                  ),
                ),
              ),
            );
          },
          child: Row(
            children: [
              // IMAGEN O EMOJI
              ClipRRect(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                child: Container(
                  width: 140,
                  height: double.infinity,
                  child: imageUrl.isNotEmpty
                      ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: color.withOpacity(0.2),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: color,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: color.withOpacity(0.3),
                            child: Center(
                              child: Text(
                                emoji,
                                style: TextStyle(fontSize: 60),
                              ),
                            ),
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
                  )
                      : Container(
                    color: color.withOpacity(0.3),
                    child: Center(
                      child: Text(
                        emoji,
                        style: TextStyle(fontSize: 60),
                      ),
                    ),
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '¡EMPEZAR!',
                          style: TextStyle(
                            fontSize: 16,
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

  /*
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

   */

}