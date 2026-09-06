import 'package:flutter/material.dart';
import '../app_colors.dart';

// entry login page
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoginMode = true;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                      const SizedBox(height: 40),

                      // Email field
                      const _FieldLabel(text: 'Email'),
                      const SizedBox(height: 8),
                      const TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'you@example.com',
                          prefixIcon: Icon(
                            Icons.mail_outline,
                            color: AppColors.leaf,
                          ),
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
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: AppColors.leaf,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () {
                              setState(
                                () => _obscurePassword = !_obscurePassword,
                              );
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
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: AppColors.leaf,
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
                            child: Divider(color: AppColors.sage, thickness: 1),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'or',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                          Expanded(
                            child: Divider(color: AppColors.sage, thickness: 1),
                          ),
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
                        child: TextButton(
                          onPressed: () {
                            setState(() => _isLoginMode = !_isLoginMode);
                          },
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
