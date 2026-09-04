import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'pages/login_page.dart';
// import 'widgets/main_nav_shell.dart'; // use this as home once login connects to it

void main() {
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
      // UI-only preview: starts on the Login page.
      // Swap to `const MainNavShell()` to preview the post-login pages directly.
      home: const LoginPage(),
    );
  }
}