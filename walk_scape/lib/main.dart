import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'widgets/main_nav_shell.dart';
import 'app_theme.dart';

void main() async {
  // Required before calling any native plugins (Geolocator, Firebase, Camera)
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase core services
  await Firebase.initializeApp();

  runApp(const WalkScapeApp());
}

class WalkScapeApp extends StatelessWidget {
  const WalkScapeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WalkScape',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const MainNavShell(),
    );
  }
}