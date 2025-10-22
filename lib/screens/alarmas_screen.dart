// lib/screens/alarmas_screen.dart
import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';

class AlarmasScreen extends StatefulWidget {
  @override
  _AlarmasScreenState createState() => _AlarmasScreenState();
}

class _AlarmasScreenState extends State<AlarmasScreen> {
  // Lista de alarmas (simuladas)
  List<Map<String, dynamic>> alarmas = [
    {
      'id': 1,
      'hora': '09:00',
      'titulo': 'Ejercicio Matutino',
      'mensaje': '¡Buenos días, PATRICIO! Hora de mover esa estrella de mar',
      'emoji': '',
      'activa': true,
      'dias': ['L', 'M', 'X', 'J', 'V'],
    },
    /*{
      'id': 2,
      'hora': '14:00',
      'titulo': 'Pausa del Almuerzo',
      'mensaje': '¡Pausa del helado! 5 minutos de ejercicio',
      'emoji': '🍦',
      'activa': true,
      'dias': ['L', 'M', 'X', 'J', 'V', 'S', 'D'],
    },
    {
      'id': 3,
      'hora': '21:00',
      'titulo': 'Estiramiento Nocturno',
      'mensaje': 'Estiramiento antes de dormir bajo tu roca',
      'emoji': '🌙',
      'activa': false,
      'dias': ['L', 'M', 'X', 'J', 'V', 'S', 'D'],
    },

     */
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF5F7),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFD54F),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(Icons.alarm, color: Colors.brown.shade800, size: 28),
            SizedBox(width: 10),
            Text(
              'Mis Alarmas',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.brown.shade800,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.brown.shade800, size: 28),
            onPressed: () {
              _showSimpleDialog(
                '💡 Ayuda',
                'Las alarmas te recordarán hacer ejercicio. ¡No te olvides!',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // MENSAJE MOTIVACIONAL GRANDE
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFD54F), Color(0xFFFFB74D)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text('⏰', style: TextStyle(fontSize: 50)),
                    SizedBox(height: 15),
                    Text(
                      '¡No te olvides, PATRICIO!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.shade800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Las alarmas te ayudarán a recordar tus ejercicios',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.brown.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // CONTADOR DE ALARMAS ACTIVAS
              Row(
                children: [
                  Text(
                    'Alarmas Activas',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF66BB6A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${alarmas.where((a) => a['activa']).length}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // LISTA DE ALARMAS
              ...alarmas.map((alarma) => _buildAlarmaCard(alarma)).toList(),

              SizedBox(height: 20),

              // BOTÓN GRANDE PARA AGREGAR ALARMA
              Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Color(0xFFFF69B4),
                    width: 3,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      _showSimpleDialog(
                        '➕ Nueva Alarma',
                        'Aquí podrás crear una nueva alarma personalizada',
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_alarm,
                          size: 35,
                          color: Color(0xFFFF69B4),
                        ),
                        SizedBox(width: 15),
                        Text(
                          'Agregar Nueva Alarma',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF69B4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 2),
    );
  }

  Widget _buildAlarmaCard(Map<String, dynamic> alarma) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: alarma['activa']
              ? Color(0xFF66BB6A).withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: alarma['activa']
                ? Color(0xFF66BB6A).withOpacity(0.15)
                : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FILA SUPERIOR: Emoji + Hora + Switch
          Row(
            children: [
              // Emoji
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFFFD54F).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  alarma['emoji'],
                  style: TextStyle(fontSize: 30),
                ),
              ),

              SizedBox(width: 15),

              // Hora y Título
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alarma['hora'],
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: alarma['activa'] ? Colors.black87 : Colors.grey,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      alarma['titulo'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: alarma['activa'] ? Colors.black87 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Switch GRANDE
              Transform.scale(
                scale: 1.3,
                child: Switch(
                  value: alarma['activa'],
                  onChanged: (value) {
                    setState(() {
                      alarma['activa'] = value;
                    });
                    _showSimpleDialog(
                      value ? '✅ Alarma Activada' : '⏸️ Alarma Pausada',
                      value
                          ? '¡Te recordaré hacer ejercicio!'
                          : 'Alarma desactivada temporalmente',
                    );
                  },
                  activeColor: Color(0xFF66BB6A),
                  inactiveThumbColor: Colors.grey,
                ),
              ),
            ],
          ),

          SizedBox(height: 15),

          // MENSAJE
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.message, size: 20, color: Colors.grey.shade600),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    alarma['mensaje'],
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 15),

          // DÍAS DE LA SEMANA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDayBadge('L', alarma['dias'].contains('L')),
              _buildDayBadge('M', alarma['dias'].contains('M')),
              _buildDayBadge('X', alarma['dias'].contains('X')),
              _buildDayBadge('J', alarma['dias'].contains('J')),
              _buildDayBadge('V', alarma['dias'].contains('V')),
              _buildDayBadge('S', alarma['dias'].contains('S')),
              _buildDayBadge('D', alarma['dias'].contains('D')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayBadge(String day, bool active) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: active ? Color(0xFFFF69B4) : Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: active ? Colors.white : Colors.grey.shade500,
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
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
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
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: Text(
                '¡Entendido!',
                style: TextStyle(
                  fontSize: 16,
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