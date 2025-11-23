import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Alarmas
import 'package:alarm/alarm.dart';

// Servicios
import 'services/alarmas_service.dart';

// Pantallas
import 'screens/login_screen.dart';

Future<void> main() async {
  // Asegura que los widgets estén inicializados antes de Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Orientación de pantalla (opcional - solo portrait)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 1. Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Inicializar Alarm
  await Alarm.init();

  // 3. Reprogramar alarmas guardadas (importante!)
  final alarmasService = AlarmasService();
  await alarmasService.reprogramarAlarmasGuardadas();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Patricio',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}