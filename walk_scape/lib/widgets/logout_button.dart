import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../services/auth_service.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  final _authService = AuthService();
  bool _isSigningOut = false;

  Future<void> _signOut() async {
    if (_isSigningOut) return;

    setState(() => _isSigningOut = true);
    final errorMessage = await _authService.signOut();

    if (!mounted) return;
    setState(() => _isSigningOut = false);

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Log out',
      icon: _isSigningOut
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.forest,
              ),
            )
          : const Icon(Icons.logout, color: AppColors.forest),
      onPressed: _isSigningOut ? null : _signOut,
    );
  }
}