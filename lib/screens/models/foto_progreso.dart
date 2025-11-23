class FotoProgreso {
  final String id;
  final String rutaArchivo;
  final DateTime fecha;

  FotoProgreso({
    required this.id,
    required this.rutaArchivo,
    required this.fecha,
  });

  // convertir JSON (para guardar/cargar)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rutaArchivo': rutaArchivo,
      'fecha': fecha.toIso8601String(),
    };
  }

  // crear desde JSON
  factory FotoProgreso.fromJson(Map<String, dynamic> json) {
    return FotoProgreso(
      id: json['id'],
      rutaArchivo: json['rutaArchivo'],
      fecha: DateTime.parse(json['fecha']),
    );
  }
}