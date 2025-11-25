import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/foto_progreso.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServicioAlmacenamientoFotos {
  final ImagePicker _picker = ImagePicker();
  final _supabase = Supabase.instance.client;

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
    // Guarda en  local primero
    final dir = await _getPhotosDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'progreso_$timestamp.jpg';
    final savedPath = '${dir.path}/$fileName';
    await File(photo.path).copy(savedPath);

    // crea el  objeto
    FotoProgreso fotoProgreso = FotoProgreso(
      id: timestamp.toString(),
      rutaArchivo: savedPath,
      fecha: DateTime.now(),
    );

    // guarda metadata local
    await _agregarMetadata(fotoProgreso);

    // se sube en segundo plano
    subirASupabase(fotoProgreso).then((url) async {
      if (url != null) {
        print('✅ Foto sincronizada con Supabase: $url');
        // Actualizar la foto con la URL
        fotoProgreso = fotoProgreso.copyWith(urlSupabase: url);
        await _actualizarMetadata(fotoProgreso);
      }
    });
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
      print('⚠️ Error al cargar fotos: $e');
      return [];
    }
  }

  // ELIMINAR UNA FOTO
  Future<void> eliminarFoto(FotoProgreso foto) async {
    try {
      // Eliminar archivo local
      final file = File(foto.rutaArchivo);
      if (await file.exists()) {
        await file.delete();
      }

      // Eliminar de Supabase
      final supabaseFileName = 'progress_${foto.id}.jpg';
      await eliminarDeSupabase(supabaseFileName);

      // Actualizar metadata local
      final metadataFile = await _getMetadataFile();
      List<FotoProgreso> fotos = await obtenerTodasLasFotos();

      fotos.removeWhere((f) => f.id == foto.id);

      final jsonList = fotos.map((f) => f.toJson()).toList();
      await metadataFile.writeAsString(json.encode(jsonList));

    } catch (e) {
      print('Error al eliminar foto: $e');
    }
  }


  // SUBIR FOTO A SUPABASE
  Future<String?> subirASupabase(FotoProgreso foto) async {
    try {
      final file = File(foto.rutaArchivo);
      final bytes = await file.readAsBytes();
      final fileName = 'progress_${foto.id}.jpg';

      // Subir al bucket
      await _supabase.storage
          .from('fotos_progreso')
          .uploadBinary(fileName, bytes);

      // Obtener URL pública
      final url = _supabase.storage
          .from('fotos_progreso')
          .getPublicUrl(fileName);

      return url;

    } catch (e) {
      print('Error al subir a Supabase: $e');
      return null;
    }
  }

  // DESCARGAR FOTO DESDE SUPABASE
  Future<void> descargarDeSupabase(String fileName, String rutaLocal) async {
    try {
      final bytes = await _supabase.storage
          .from('fotos_progreso')
          .download(fileName);

      final file = File(rutaLocal);
      await file.writeAsBytes(bytes);

    } catch (e) {
      print('️⚠️  Error al descargar de Supabase: $e');
    }
  }

  // ELIMINAR DE SUPABASE
  Future<void> eliminarDeSupabase(String fileName) async {
    try {
      final response = await _supabase.storage
          .from('fotos_progreso')
          .remove([fileName]);

      print('✅ Eliminado de Supabase: $fileName');
      print('Response: $response'); // Para debug

    } catch (e) {
      print('⚠️ Error al eliminar de Supabase: $e');
      rethrow; // Relanza el error para verlo
    }
  }

  //sincronizar fotos locales que aún no están en Supabase
  Future<void> sincronizarConSupabase() async {
    final fotos = await obtenerTodasLasFotos();
    for (var foto in fotos) {
      if (foto.urlSupabase == null) {
    // Esta foto no está en Supabase, subirla
        await subirASupabase(foto);
      }
    }
  }

  //actualizar datos foto
  Future<void> _actualizarMetadata(FotoProgreso fotoActualizada) async {
    final file = await _getMetadataFile();
    final fotos = await obtenerTodasLasFotos();

    final nuevasFotos = fotos.map((f) {
      if (f.id == fotoActualizada.id) return fotoActualizada;
      return f;
    }).toList();

    final jsonList = nuevasFotos.map((f) => f.toJson()).toList();
    await file.writeAsString(json.encode(jsonList));
  }



}