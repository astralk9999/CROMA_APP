import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../shared/widgets/croma_bottom_nav.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isLoggedIn = false;
  String _email = '';
  String _name = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = SupabaseService.client.auth.currentUser;
    setState(() {
      _isLoggedIn = user != null;
      _email = user?.email ?? '';
      _name = user?.userMetadata?['full_name'] as String? ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── HEADER ───
              Container(
                color: Colors.black,
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Center(
                        child: Icon(Icons.person, size: 36, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isLoggedIn) ...[
                      Text(
                        _name.isNotEmpty ? _name : _email,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (_name.isNotEmpty)
                        Text(
                          _email,
                          style: const TextStyle(color: Colors.white60, fontSize: 13),
                        ),
                    ] else ...[
                      const Text(
                        'INVITADO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: _showLoginDialog,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white, width: 2),
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        ),
                        child: const Text('INICIAR SESIÓN'),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // ─── SETTINGS SECTIONS ───
              _buildSection(
                title: 'MI CUENTA',
                children: [
                  if (_isLoggedIn)
                    _buildTile(Icons.local_shipping_outlined, 'Dirección de envío por defecto', () {
                      _showAddressDialog();
                    }),
                  if (_isLoggedIn)
                    _buildTile(Icons.lock_outline, 'Cambiar contraseña', () {
                      _showChangePasswordDialog();
                    }),
                  _buildTile(Icons.language, 'Idioma', () {
                    _showLanguageDialog();
                  }),
                ],
              ),

              _buildSection(
                title: 'INFORMACIÓN',
                children: [
                  _buildTile(Icons.info_outline, 'Sobre nosotros', () {
                    context.push('/about');
                  }),
                  _buildTile(Icons.mail_outline, 'Contacto', () {
                    context.push('/contact');
                  }),
                ],
              ),

              if (_isLoggedIn)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: OutlinedButton(
                    onPressed: _logout,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red, width: 2),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'CERRAR SESIÓN',
                      style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
                    ),
                  ),
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CromaBottomNav(currentIndex: 4),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 2,
              color: Colors.grey,
            ),
          ),
        ),
        ...children,
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  // ─── DIALOGS ───

  void _showLoginDialog() {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('INICIAR SESIÓN', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 8),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Contraseña'), obscureText: true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCELAR')),
          ElevatedButton(
            onPressed: () async {
              try {
                await SupabaseService.client.auth.signInWithPassword(
                  email: emailCtrl.text.trim(),
                  password: passCtrl.text,
                );
                if (ctx.mounted) Navigator.pop(ctx);
                _loadUserData();
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: const Text('ENTRAR', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddressDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('DIRECCIÓN POR DEFECTO', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Calle y número')),
            const SizedBox(height: 8),
            TextField(decoration: const InputDecoration(labelText: 'Ciudad')),
            const SizedBox(height: 8),
            TextField(decoration: const InputDecoration(labelText: 'Código postal')),
            const SizedBox(height: 8),
            TextField(decoration: const InputDecoration(labelText: 'País')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCELAR')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dirección guardada'), backgroundColor: Colors.black),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: const Text('GUARDAR', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final passCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('CAMBIAR CONTRASEÑA', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        content: TextField(
          controller: passCtrl,
          decoration: const InputDecoration(labelText: 'Nueva contraseña'),
          obscureText: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCELAR')),
          ElevatedButton(
            onPressed: () async {
              try {
                await SupabaseService.client.auth.updateUser(
                  UserAttributes(password: passCtrl.text),
                );
                if (ctx.mounted) Navigator.pop(ctx);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contraseña actualizada'), backgroundColor: Colors.black),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: const Text('GUARDAR', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('IDIOMA', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
        children: [
          SimpleDialogOption(
            child: const Text('🇪🇸  Español'),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Idioma: Español'), backgroundColor: Colors.black),
              );
            },
          ),
          SimpleDialogOption(
            child: const Text('🇬🇧  English'),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Language: English'), backgroundColor: Colors.black),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    await SupabaseService.client.auth.signOut();
    _loadUserData();
  }
}
