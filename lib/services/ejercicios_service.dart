import 'package:cloud_firestore/cloud_firestore.dart';

//para cargar ejercicios
class EjerciciosService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener todos los ejercicios
  Future<List<Map<String, dynamic>>> obtenerEjercicios() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('ejercicios')
          .orderBy('orden')
          .get();

      return snapshot.docs
          .map((doc) => {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      })
          .toList();
    } catch (e) {
      print('Error al obtener ejercicios: $e');
      return [];
    }
  }

  // Obtener ejercicios por categoría
  Future<List<Map<String, dynamic>>> obtenerEjerciciosPorCategoria(
      String categoria) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('ejercicios')
          .where('categoria', isEqualTo: categoria)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // Marcar ejercicio como completado
  Future<void> marcarCompletado(String ejercicioId) async {
    try {
      await _firestore
          .collection('ejercicios')
          .doc(ejercicioId)
          .update({'completado': true});
    } catch (e) {
      print('Error: $e');
    }
  }
}