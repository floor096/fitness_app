import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/foto_progreso.dart';
import '../services/servicio_almacenamiento_fotos.dart';

class GaleriaFotosProgreso extends StatefulWidget {
  @override
  _GaleriaFotosProgresoState createState() => _GaleriaFotosProgresoState();
}

class _GaleriaFotosProgresoState extends State<GaleriaFotosProgreso> {
  final ServicioAlmacenamientoFotos _servicio = ServicioAlmacenamientoFotos();
  List<FotoProgreso> _fotos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarFotos();
  }

  Future<void> _cargarFotos() async {
    setState(() => _cargando = true);
    final fotos = await _servicio.obtenerTodasLasFotos();
    setState(() {
      _fotos = fotos;
      _cargando = false;
    });
  }

  Future<void> _tomarFotoConCamara() async {
    final foto = await _servicio.tomarFotoConCamara();
    if (foto != null) {
      await _cargarFotos();
      _mostrarMensaje('¡Foto guardada!');
    }
  }

  Future<void> _seleccionarDeGaleria() async {
    final foto = await _servicio.seleccionarDeGaleria();
    if (foto != null) {
      await _cargarFotos();
      _mostrarMensaje('¡Foto guardada!');
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Color(0xFFFF69B4),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _verFotoCompleta(FotoProgreso foto) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            // imagen completa
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  File(foto.rutaArchivo),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            //  cerrar
            Positioned(
              top: 40,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(Icons.close, color: Color(0xFFFF69B4)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            // eliminar
            Positioned(
              top: 40,
              left: 20,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    Navigator.pop(context);
                    _confirmarEliminar(foto);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmarEliminar(FotoProgreso foto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('¿Eliminar foto?', textAlign: TextAlign.center),
        content: Text(
          'Esta acción no se puede deshacer',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _servicio.eliminarFoto(foto);
              await _cargarFotos();
              _mostrarMensaje('Foto eliminada');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text('Eliminar', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título
        Text(
          'Tus Fotos de Progreso',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        SizedBox(height: 10),

        // Botones para agregar foto
        Row(
          children: [
            Expanded(
              child: _buildBotonAgregarConIcono(
                'Cámara',
                Icons.camera_alt,
                Color(0xFFFF69B4),
                _tomarFotoConCamara,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildBotonAgregarConIcono(
                'Galería',
                Icons.photo_library,
                Color(0xFF66BB6A),
                _seleccionarDeGaleria,
              ),
            ),
          ],
        ),

        SizedBox(height: 20),

        // Grid de fotos
        if (_cargando)
          Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(color: Color(0xFFFF69B4)),
            ),
          )
        else if (_fotos.isEmpty)
          _buildEstadoVacio()
        else
          _buildGridFotos(),
      ],
    );
  }

  Widget _buildBotonAgregarConIcono(String texto, IconData icono, Color color, VoidCallback onTap) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                texto,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEstadoVacio() {
    return Container(
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFFF69B4).withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Icon(Icons.photo_camera, size: 60, color: Colors.grey.shade400),
          SizedBox(height: 15),
          Text(
            'Aún no tienes fotos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '¡Empieza a documentar tu progreso!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridFotos() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.75,
      ),
      itemCount: _fotos.length,
      itemBuilder: (context, index) {
        final foto = _fotos[index];
        return _buildTarjetaFoto(foto);
      },
    );
  }

  Widget _buildTarjetaFoto(FotoProgreso foto) {
    final formatoFecha = DateFormat('dd/MM/yyyy');

    return GestureDetector(
      onTap: () => _verFotoCompleta(foto),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.file(
                  File(foto.rutaArchivo),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Fecha
            Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFFFF69B4).withOpacity(0.1),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Text(
                formatoFecha.format(foto.fecha),
                textAlign: TextAlign.center,
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
    );
  }
}