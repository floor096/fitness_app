import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';

class AjustesScreen extends StatefulWidget {
  @override
  _AjustesScreenState createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  bool notificacionesActivas = true;
  bool sonidosActivos = true;
  bool musicaFondoActiva = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Color(0xFFFF69B4), size: 32),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Ajustes',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20),
        children: [
          // NOTIFICACIONES
          _buildAjusteItem(
            emoji: '🔔',
            color: Color(0xFFFFD93D),
            titulo: 'Notificaciones',
            valor: notificacionesActivas,
            onChanged: (value) {
              setState(() {
                notificacionesActivas = value;
              });
            },
          ),

          Divider(height: 1, thickness: 1, color: Colors.grey.shade200),

          // SONIDOS
          _buildAjusteItem(
            emoji: '🔊',
            color: Color(0xFFFF69B4),
            titulo: 'Sonidos',
            valor: sonidosActivos,
            onChanged: (value) {
              setState(() {
                sonidosActivos = value;
              });
            },
          ),

          Divider(height: 1, thickness: 1, color: Colors.grey.shade200),

          // MÚSICA DE FONDO
          _buildAjusteItem(
            emoji: '🎵',
            color: Color(0xFF9C27B0),
            titulo: 'Música de fondo',
            valor: musicaFondoActiva,
            onChanged: (value) {
              setState(() {
                musicaFondoActiva = value;
              });
            },
          ),

          Divider(height: 1, thickness: 1, color: Colors.grey.shade200),

          /*
          // IDIOMA (sin switch, solo navega)
          _buildAjusteItemSinSwitch(
            emoji: '🌐',
            color: Color(0xFF4DD0E1),
            titulo: 'Idioma',
            onTap: () {
              _mostrarDialogoIdioma();
            },
          ),*/
        ],
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 0),
    );
  }

  Widget _buildAjusteItem({
    required String emoji,
    required Color color,
    required String titulo,
    required bool valor,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          // EMOJI CON FONDO DE COLOR
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                emoji,
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),

          SizedBox(width: 20),

          // TÍTULO
          Expanded(
            child: Text(
              titulo,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          // SWITCH GRANDE
          Transform.scale(
            scale: 1.2,
            child: Switch(
              value: valor,
              onChanged: onChanged,
              activeColor: Color(0xFFFF69B4),
              inactiveThumbColor: Colors.grey.shade400,
              inactiveTrackColor: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAjusteItemSinSwitch({
    required String emoji,
    required Color color,
    required String titulo,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            // EMOJI CON FONDO DE COLOR
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ),

            SizedBox(width: 20),

            // TÍTULO
            Expanded(
              child: Text(
                titulo,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            // FLECHA
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }

  /*
  void _mostrarDialogoIdioma() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text(
          'Idioma',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOpcionIdioma('🇪🇸', 'Español'),
            SizedBox(height: 15),
            _buildOpcionIdioma('🇺🇸', 'English'),
            SizedBox(height: 15),
            _buildOpcionIdioma('🇵🇹', 'Português'),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpcionIdioma(String bandera, String idioma) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Idioma cambiado a $idioma'),
            backgroundColor: Color(0xFFFF69B4),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Text(bandera, style: TextStyle(fontSize: 28)),
            SizedBox(width: 15),
            Text(
              idioma,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }*/
}