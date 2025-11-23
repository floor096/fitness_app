import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/foto_progreso.dart';

class ServicioAlmacenamientoFotos {
  final ImagePicker _picker = ImagePicker();

  // para el directorio donde guardamos las fotos
  Future<Directory> _getPhotosDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final photosDir = Directory('${appDir.path}/fotos_progreso');

    // lo crea si no existe
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }

    return photosDir;
  }

  // para el archivo donde guardamos los metadatos (info de las fotos)
  Future<File> _getMetadataFile() async {
    final dir = await _getPhotosDirectory();
    return File('${dir.path}/metadata.json');
  }

  // TOMAR FOTO CON LA CÁMARA
  Future<FotoProgreso?> tomarFotoConCamara() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200, // tamaño
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (photo == null) return null;

      return await _guardarFoto(photo);
    } catch (e) {
      print('Error al tomar foto: $e');
      return null;
    }
  }

  // SELECCIONAR FOTO DE LA GALERÍA
  Future<FotoProgreso?> seleccionarDeGaleria() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (photo == null) return null;

      return await _guardarFoto(photo);
    } catch (e) {
      print('Error al seleccionar foto: $e');
      return null;
    }
  }

  // guardar en el almacenamiento local
  Future<FotoProgreso> _guardarFoto(XFile photo) async {
    final dir = await _getPhotosDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'progreso_$timestamp.jpg';
    final savedPath = '${dir.path}/$fileName';

    // la copia en el directorio de la app
    await File(photo.path).copy(savedPath);

    // crea FotoProgreso
    final fotoProgreso = FotoProgreso(
      id: timestamp.toString(),
      rutaArchivo: savedPath,
      fecha: DateTime.now(),
    );

    //  metadata
    await _agregarMetadata(fotoProgreso);

    return fotoProgreso;
  }

  // metadata al  JSON
  Future<void> _agregarMetadata(FotoProgreso foto) async {
    final file = await _getMetadataFile();
    List<FotoProgreso> fotos = await obtenerTodasLasFotos();

    fotos.add(foto);

    // ordena por fecha
    fotos.sort((a, b) => b.fecha.compareTo(a.fecha));

    final jsonList = fotos.map((f) => f.toJson()).toList();
    await file.writeAsString(json.encode(jsonList));
  }

  // OBTENER TODAS LAS FOTOS
  Future<List<FotoProgreso>> obtenerTodasLasFotos() async {
    try {
      final file = await _getMetadataFile();

      if (!await file.exists()) {
        return [];
      }

      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);

      return jsonList.map((json) => FotoProgreso.fromJson(json)).toList();
    } catch (e) {
      print('Error al cargar fotos: $e');
      return [];
    }
  }

  // ELIMINAR UNA FOTO
  Future<void> eliminarFoto(FotoProgreso foto) async {
    try {
      // elimina el archivo de imagen
      final file = File(foto.rutaArchivo);
      if (await file.exists()) {
        await file.delete();
      }

      // elimina metadata
      final metadataFile = await _getMetadataFile();
      List<FotoProgreso> fotos = await obtenerTodasLasFotos();

      fotos.removeWhere((f) => f.id == foto.id);

      final jsonList = fotos.map((f) => f.toJson()).toList();
      await metadataFile.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Error al eliminar foto: $e');
    }
  }
}