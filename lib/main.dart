import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Notificaciones
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'screens/login_screen.dart';

// Instancia global
final FlutterLocalNotificationsPlugin notificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  //asegura que los widgets esten inicializados antes de firebase
  WidgetsFlutterBinding.ensureInitialized();

  //Inicializa Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializa Timezones (para alarmas exactas)
  tz.initializeTimeZones();

  // configuracion de inicializacion para Android
  const AndroidInitializationSettings androidSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  // configuracion de inicializacion para iOS
  const DarwinInitializationSettings iosSettings =
  DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  // combinar configuraciones
  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  // inicializar notificaciones
  await notificationsPlugin.initialize(
    initSettings,
  );

  //  permisos en Android 13+
  // await notificationsPlugin.resolvePlatformSpecificImplementation
  //AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Patricio',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}