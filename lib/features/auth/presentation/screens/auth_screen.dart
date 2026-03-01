import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/auth_provider.dart';
import '../../../../core/providers/language_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authNotifier = ref.read(authNotifierProvider.notifier);
      if (_isLogin) {
        await authNotifier.signIn(
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        await authNotifier.signUp(
          _emailController.text.trim(),
          _passwordController.text,
          _nameController.text.trim(),
        );
      }
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEs = ref.watch(languageProvider) == 'es';

    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/chromakopia_logo.png',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 60),

                // Toggle
                Row(
                  children: [
                    _ToggleTab(
                      label: isEs ? 'INICIAR SESIÓN' : 'SIGN IN',
                      isActive: _isLogin,
                      onTap: () => setState(() => _isLogin = true),
                    ),
                    const SizedBox(width: 24),
                    _ToggleTab(
                      label: isEs ? 'REGISTRARSE' : 'REGISTER',
                      isActive: !_isLogin,
                      onTap: () => setState(() => _isLogin = false),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Name field (only for Register)
                if (!_isLogin) ...[
                  _AuthTextField(
                    controller: _nameController,
                    label: isEs ? 'NOMBRE COMPLETO' : 'FULL NAME',
                    hintText: 'Tyler Okonma',
                    validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 24),
                ],

                // Email field
                _AuthTextField(
                  controller: _emailController,
                  label: 'EMAIL',
                  hintText: 'user@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v == null || !v.contains('@') ? 'Email inválido' : null,
                ),
                const SizedBox(height: 24),

                // Password field
                _AuthTextField(
                  controller: _passwordController,
                  label: isEs ? 'CONTRASEÑA' : 'PASSWORD',
                  hintText: '••••••••',
                  obscureText: true,
                  validator: (v) => v == null || v.length < 6 ? 'Mínimo 6 caracteres' : null,
                ),

                const SizedBox(height: 48),

                // Submit Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF202020),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF202020)),
                        )
                      : Text(
                          (_isLogin ? (isEs ? 'ENTRAR' : 'SIGN IN') : (isEs ? 'CREAR CUENTA' : 'CREATE ACCOUNT')).toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
                        ),
                ),

                if (_isLogin) ...[
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Forgot password logic?
                      },
                      child: Text(
                        isEs ? '¿OLVIDASTE TU CONTRASEÑA?' : 'FORGOT PASSWORD?',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ToggleTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white38,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 2,
            width: 40,
            color: isActive ? Colors.white : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _AuthTextField({
    required this.controller,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white24),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide.none,
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide.none,
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: Colors.white24, width: 1),
            ),
            errorStyle: const TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    );
  }
}
