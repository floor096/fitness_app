import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/custom_bottom_nav.dart';
import 'ejercicio_detalle_screen.dart';
import 'home_screen.dart';

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
          data['id'] = doc.id;
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar ejercicios'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Convierte string a IconData
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF5F7),
      appBar: AppBar(
        backgroundColor: Color(0xFFFF69B4),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => HomeScreen(),
                transitionDuration: Duration.zero,
              ),
            );
          },
        ),
        title: Text(
          'Ejercicios Fáciles',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
                fontSize: 20,
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
            Icon(
              Icons.sentiment_dissatisfied,
              size: 80,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 20),
            Text(
              'No hay ejercicios disponibles',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Agrega ejercicios en Firestore',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _cargarEjercicios,
              icon: Icon(Icons.refresh, size: 24),
              label: Text(
                'Reintentar',
                style: TextStyle(fontSize: 18),
              ),
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
                  Icon(
                    Icons.star,
                    size: 45,
                    color: Colors.brown.shade800,
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¡Bien hecho, Patricio!',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown.shade800,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Vas a ser la estrella más fuerte',
                          style: TextStyle(
                            fontSize: 18,
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
                      fontSize: 28,
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
                        fontSize: 18,
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
              return _buildBigCategoryCard(ejercicio);
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
      return Color(0xFFFF69B4);
    }

    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Color(0xFFFF69B4);
    }
  }

  Widget _buildBigCategoryCard(Map<String, dynamic> ejercicio) {
    String iconName = ejercicio['iconName'] ?? '';
    String titulo = ejercicio['titulo'] ?? 'Sin título';
    String subtitulo = ejercicio['subtitulo'] ?? 'Sin descripción';
    Color color = _parseColor(ejercicio['color']);
    String imagenUrl = ejercicio['imagenUrl'] ?? '';
    IconData icon = _getIcon(iconName);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 180,
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
                  ejercicio: ejercicio,
                ),
              ),
            );
          },
          child: Row(
            children: [
              // IMAGEN O ICONO
              ClipRRect(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                child: Container(
                  width: 120,
                  height: double.infinity,
                  child: imagenUrl.isNotEmpty
                      ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imagenUrl,
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
                              child: Icon(
                                icon,
                                size: 60,
                                color: Colors.white,
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
                      child: Icon(
                        icon,
                        size: 60,
                        color: Colors.white,
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
                        titulo,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        subtitulo,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '¡EMPEZAR!',
                          style: TextStyle(
                            fontSize: 22,
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
}