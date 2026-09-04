import 'package:flutter/material.dart';
import '../app_colors.dart';

/// Login / Register Page
/// Entry point for user authentication via Firebase Auth (UI only).
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoginMode = true; // toggles between Login and Register UI
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildLogo(),
              const SizedBox(height: 16),
              Text(
                'WalkScape',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.forest,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'เดินผ่อนคลาย เติมพลังใจ ท่ามกลางธรรมชาติ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),

              // Mode toggle: Login / Register
              _buildModeToggle(),
              const SizedBox(height: 28),

              // Email field
              const _FieldLabel(text: 'Email'),
              const SizedBox(height: 8),
              const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'you@example.com',
                  prefixIcon: Icon(Icons.mail_outline, color: AppColors.leaf),
                ),
              ),
              const SizedBox(height: 18),

              // Password field
              const _FieldLabel(text: 'Password'),
              const SizedBox(height: 8),
              TextField(
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon:
                      const Icon(Icons.lock_outline, color: AppColors.leaf),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),

              // Confirm password (Register mode only)
              if (!_isLoginMode) ...[
                const SizedBox(height: 18),
                const _FieldLabel(text: 'Confirm Password'),
                const SizedBox(height: 8),
                TextField(
                  obscureText: _obscurePassword,
                  decoration: const InputDecoration(
                    hintText: '••••••••',
                    prefixIcon:
                        Icon(Icons.lock_outline, color: AppColors.leaf),
                  ),
                ),
              ],

              if (_isLoginMode) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {},
                child: Text(_isLoginMode ? 'Login' : 'Register'),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                      child: Divider(color: AppColors.sage, thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('or',
                        style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  Expanded(
                      child: Divider(color: AppColors.sage, thickness: 1)),
                ],
              ),
              const SizedBox(height: 14),

              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.g_mobiledata, size: 26),
                label: const Text('Continue with Google'),
              ),

              const SizedBox(height: 24),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: AppColors.textSecondary),
                    children: [
                      TextSpan(
                        text: _isLoginMode
                            ? "Don't have an account? "
                            : 'Already have an account? ',
                      ),
                      TextSpan(
                        text: _isLoginMode ? 'Register' : 'Login',
                        style: const TextStyle(
                          color: AppColors.forest,
                          fontWeight: FontWeight.w700,
                        ),
                        recognizer: null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() => _isLoginMode = !_isLoginMode);
                  },
                  child: Text(
                    _isLoginMode ? 'Switch to Register' : 'Switch to Login',
                    style: const TextStyle(
                      color: AppColors.leaf,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Container(
        width: 84,
        height: 84,
        decoration: BoxDecoration(
          color: AppColors.leaf,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.leaf.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Icon(Icons.park_rounded, color: Colors.white, size: 42),
      ),
    );
  }

  Widget _buildModeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.sage.withOpacity(0.35),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _buildToggleButton('Login', _isLoginMode),
          _buildToggleButton('Register', !_isLoginMode),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool selected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _isLoginMode = label == 'Login');
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.leaf : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.forest,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.forest,
      ),
    );
  }
}
