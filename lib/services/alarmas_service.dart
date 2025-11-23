 // ------------------ NUEVO CON ALARM ------------------
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alarm/alarm.dart';

class AlarmasService {
  static final AlarmasService _instance = AlarmasService._internal();
  factory AlarmasService() => _instance;
  AlarmasService._internal();

  // Clave donde guardamos las alarmas en disco
  final String _storageKey = "alarmas_guardadas";
  final String _counterKey = "alarmas_counter"; // Para IDs incrementales

  // Generar ID seguro
  Future<int> _generarIdSeguro() async {
    final prefs = await SharedPreferences.getInstance();
    int counter = prefs.getInt(_counterKey) ?? 1;

    // Si el counter se pasa del límite seguro, reiniciamos
    if (counter > 2000000) {
      counter = 1;
    }

    await prefs.setInt(_counterKey, counter + 1);
    return counter;
  }

  // 1) Guardar alarmas en SharedPreferences
  Future<void> guardarAlarmas(List<Map<String, dynamic>> alarmas) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(alarmas);
    await prefs.setString(_storageKey, jsonString);
  }

  // 2) Cargar alarmas desde SharedPreferences
  Future<List<Map<String, dynamic>>> cargarAlarmas() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_storageKey)) {
      return [];
    }

    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final List<dynamic> lista = jsonDecode(jsonString);
      return lista.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      print('Error al cargar alarmas: $e');
      return [];
    }
  }

  // 3) Crear una nueva alarma con ID seguro
  Future<Map<String, dynamic>> crearNuevaAlarma({
    required String titulo,
    required String hora,
    required List<String> dias,
    bool sound = true,
    bool vibration = true,
  }) async {
    final int idSeguro = await _generarIdSeguro();

    return {
      "id": idSeguro,
      "titulo": titulo,
      "hora": hora,
      "dias": dias,
      "sound": sound,
      "vibration": vibration,
      "activa": true,
    };
  }

  // 4) Programar alarma con el paquete alarm
  Future<void> programarAlarma(Map<String, dynamic> alarma) async {
    final String hora = alarma["hora"];
    final List dias = alarma["dias"] ?? [];
    final int baseId = alarma["id"];

    // Validar ID
    if (baseId > 2000000) {
      print('⚠️ ID demasiado grande: $baseId. Regenerando...');
      alarma["id"] = await _generarIdSeguro();
      return programarAlarma(alarma);
    }

    final partes = hora.split(":");
    final int hh = int.parse(partes[0]);
    final int mm = int.parse(partes[1]);

    // Mapeo de días
    const Map<String, int> mapaDias = {
      "L": DateTime.monday,
      "M": DateTime.tuesday,
      "X": DateTime.wednesday,
      "J": DateTime.thursday,
      "V": DateTime.friday,
      "S": DateTime.saturday,
      "D": DateTime.sunday,
    };

    for (String d in dias) {
      final int? dayNumber = mapaDias[d];
      if (dayNumber == null) continue;

      // ID único: baseId * 10 + día (1-7)
      final int alarmId = baseId * 10 + dayNumber;

      await _programarParaDia(
        alarmId: alarmId,
        dayNumber: dayNumber,
        hora: hh,
        minuto: mm,
        titulo: alarma["titulo"] ?? "Recordatorio",
        sound: alarma["sound"] ?? true,
        vibration: alarma["vibration"] ?? true,
      );
    }
  }

  // Función interna para programar un día específico
  Future<void> _programarParaDia({
    required int alarmId,
    required int dayNumber,
    required int hora,
    required int minuto,
    required String titulo,
    required bool sound,
    required bool vibration,
  }) async {
    try {
      final now = DateTime.now();
      DateTime fechaAlarma = DateTime(
        now.year,
        now.month,
        now.day,
        hora,
        minuto,
      );

      // Avanzar al próximo día de la semana correcto
      while (fechaAlarma.weekday != dayNumber) {
        fechaAlarma = fechaAlarma.add(const Duration(days: 1));
      }

      // Si ya pasó la hora de hoy, programar para la próxima semana
      if (fechaAlarma.isBefore(now)) {
        fechaAlarma = fechaAlarma.add(const Duration(days: 7));
      }

      // Configuración de la alarma
      final alarmSettings = AlarmSettings(
        id: alarmId,
        dateTime: fechaAlarma,
        assetAudioPath: 'assets/sounds/beep-alarm-1.mp3',
        loopAudio: false,
        vibrate: vibration,
        volume: sound ? 0.7 : 0.0,
        fadeDuration: 3.0,
        notificationTitle: titulo,
        notificationBody: '¡Hora de hacer tu ejercicio!',
        enableNotificationOnKill: true,
        androidFullScreenIntent: false,
      );

      await Alarm.set(alarmSettings: alarmSettings);

      print('✅ Alarma programada: ID=$alarmId, Día=$dayNumber, Hora=$hora:$minuto');
    } catch (e) {
      print('❌ Error al programar alarma: $e');
    }
  }

  // 5) Cancelar todas las alarmas de un ID base
  Future<void> cancelarAlarmas(int baseId) async {
    for (int d = 1; d <= 7; d++) {
      final int alarmId = baseId * 10 + d;
      await Alarm.stop(alarmId);
    }
    print('🗑️ Alarmas canceladas para ID base: $baseId');
  }

  // 6) Cancelar alarma de un día específico
  Future<void> cancelarAlarmaDia(int baseId, String dia) async {
    const Map<String, int> mapaDias = {
      "L": DateTime.monday,
      "M": DateTime.tuesday,
      "X": DateTime.wednesday,
      "J": DateTime.thursday,
      "V": DateTime.friday,
      "S": DateTime.saturday,
      "D": DateTime.sunday,
    };

    final int? dayNumber = mapaDias[dia];
    if (dayNumber != null) {
      final int alarmId = baseId * 10 + dayNumber;
      await Alarm.stop(alarmId);
      print('🗑️ Alarma cancelada: ID=$alarmId, Día=$dia');
    }
  }

  // 7) Cancelar TODAS las alarmas
  Future<void> cancelarTodasLasAlarmas() async {
    await Alarm.stopAll();
    print('🗑️ Todas las alarmas canceladas');
  }

  // 8) Reprogramar alarmas al iniciar la app
  Future<void> reprogramarAlarmasGuardadas() async {
    final alarmas = await cargarAlarmas();

    for (var alarma in alarmas) {
      if (alarma['activa'] == true) {
        await programarAlarma(alarma);
      }
    }

    print('🔄 ${alarmas.length} alarmas reprogramadas');
  }
}
