import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_nav.dart';
import 'alarma_popup.dart';
import '../../services/alarmas_service.dart';

class AlarmasScreen extends StatefulWidget {
  @override
  _AlarmasScreenState createState() => _AlarmasScreenState();
}

class _AlarmasScreenState extends State<AlarmasScreen> {
  List<Map<String, dynamic>> alarmas = [];
  final AlarmasService _service = AlarmasService();

  @override
  void initState() {
    super.initState();
    _cargarAlarmas();
  }

  Future<void> _cargarAlarmas() async {
    final cargadas = await _service.cargarAlarmas();
    setState(() {
      alarmas = cargadas;
    });
  }

  Future<void> _guardarAlarmas() async {
    await _service.guardarAlarmas(alarmas);
  }

  Future<void> _crearNuevaAlarma() async {
    final nuevaAlarma = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => AlarmaPopup(),
    );

    if (nuevaAlarma != null) {
      setState(() {
        alarmas.add(nuevaAlarma);
      });

      await _guardarAlarmas();
      await _service.programarAlarma(nuevaAlarma);

      _showSimpleDialog(
        "⏰ Alarma creada",
        "Tu alarma fue programada correctamente",
      );
    }
  }

  Future<void> _toggleAlarma(Map<String, dynamic> alarma, bool activa) async {
    setState(() {
      alarma['activa'] = activa;
    });

    if (activa) {
      await _service.programarAlarma(alarma);
    } else {
      await _service.cancelarAlarmas(alarma['id']);
    }

    await _guardarAlarmas();
  }

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
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.brown.shade800,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.brown.shade800),
            onPressed: () {
              _showSimpleDialog(
                "💡 Ayuda",
                "Aquí puedes crear alarmas para tus ejercicios.",
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              _mensajitoSuperior(),

              SizedBox(height: 30),

              _contador(),

              SizedBox(height: 20),

              ...(alarmas.isEmpty
                  ? [Text("No tienes alarmas creadas aún 😴", style: TextStyle(fontSize: 20))]
                  : alarmas.map((a) => _buildAlarmaCard(a)).toList()),

              SizedBox(height: 20),

              _botonAgregar(),

              SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 0),
    );
  }

  Widget _mensajitoSuperior() {
    return Container(
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
          Text(
            '¡No te olvides, PATRICIO!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.brown.shade800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Las alarmas te ayudarán a recordar tus ejercicios',
            style: TextStyle(
              fontSize: 20,
              color: Colors.brown.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _contador() {
    return Row(
      children: [
        Text(
          'Alarmas Activas',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
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
        children: [
          Row(
            children: [
              // Hora y título
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alarma["hora"],
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: alarma["activa"] ? Colors.black87 : Colors.grey,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      alarma["titulo"],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: alarma["activa"] ? Colors.black87 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Switch
              Transform.scale(
                scale: 1.3,
                child: Switch(
                  value: alarma["activa"],
                  onChanged: (v) => _toggleAlarma(alarma, v),
                  activeColor: Color(0xFF66BB6A),
                ),
              ),

              SizedBox(width: 10),

              // Botón de eliminar
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red.withOpacity(0.7),
                  size: 30,
                ),
                onPressed: () => _confirmarEliminarAlarma(alarma),
              ),
            ],
          ),

          SizedBox(height: 15),

          // Chips de días
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: alarma["dias"].map<Widget>((d) {
              return _buildDayBadge(d, alarma['activa']);
            }).toList(),
          ),
        ],
      ),
    );
  }

// Función para confirmar eliminación
  Future<void> _confirmarEliminarAlarma(Map<String, dynamic> alarma) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 10),
            Text('Eliminar alarma'),
          ],
        ),
        content: Text(
          '¿Estás seguro de que deseas eliminar la alarma "${alarma['titulo']}" a las ${alarma['hora']}?',
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Eliminar',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _eliminarAlarma(alarma);
    }
  }

// Función para eliminar la alarma
  Future<void> _eliminarAlarma(Map<String, dynamic> alarma) async {
    try {
      // Cancelar las notificaciones programadas
      final alarmasService = AlarmasService();
      await alarmasService.cancelarAlarmas(alarma['id']);

      // Eliminar de la lista
      setState(() {
        alarmas.remove(alarma);
      });

      // Guardar cambios
      await alarmasService.guardarAlarmas(alarmas);

      // Mostrar confirmación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Alarma eliminada correctamente'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      print('❌ Error al eliminar alarma: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 10),
              Text('Error al eliminar la alarma'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Widget _buildDayBadge(String dia, bool activa) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: activa ? Color(0xFFFF69B4) : Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          dia,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: activa ? Colors.white : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }

  Widget _botonAgregar() {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFFF69B4),
          width: 3,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: _crearNuevaAlarma,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_alarm, size: 35, color: Color(0xFFFF69B4)),
            SizedBox(width: 15),
            Text(
              "Agregar Nueva Alarma",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF69B4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSimpleDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
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
              child: Text("¡Entendido!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}