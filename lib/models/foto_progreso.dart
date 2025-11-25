class FotoProgreso {
  final String id;
  final String rutaArchivo;
  final DateTime fecha;
  final String? urlSupabase;

  FotoProgreso({
    required this.id,
    required this.rutaArchivo,
    required this.fecha,
    this.urlSupabase,
  });

  // convertir JSON (para guardar/cargar)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rutaArchivo': rutaArchivo,
      'fecha': fecha.toIso8601String(),
      'urlSupabase': urlSupabase,
    };
  }

  // crear desde JSON
  factory FotoProgreso.fromJson(Map<String, dynamic> json) {
    return FotoProgreso(
      id: json['id'],
      rutaArchivo: json['rutaArchivo'],
      fecha: DateTime.parse(json['fecha']),
      urlSupabase: json['urlSupabase'],
    );
  }

  // metodo para copiar con cambios
  FotoProgreso copyWith({String? urlSupabase}) {
    return FotoProgreso(
      id: id,
      rutaArchivo: rutaArchivo,
      fecha: fecha,
      urlSupabase: urlSupabase ?? this.urlSupabase,
    );
  }
}