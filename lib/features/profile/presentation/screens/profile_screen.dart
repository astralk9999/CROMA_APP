import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../shared/widgets/croma_bottom_nav.dart';
import '../../data/profile_provider.dart';

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
    final lang = ref.watch(languageProvider);
    final isEs = lang == 'es';

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── HEADER ───
                Container(
                  color: const Color(0xFF202020),
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
                        const SizedBox(height: 16),
                        
                        // Admin Panel Button
                        ref.watch(userProfileProvider).when(
                          data: (profile) => profile?.role == 'admin' 
                            ? Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: TextButton.icon(
                                  onPressed: () => context.push('/admin'),
                                  icon: const Icon(Icons.admin_panel_settings_outlined, color: Colors.amber, size: 18),
                                  label: const Text('PANEL DE ADMINISTRACIÓN', style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ] else ...[
                        Text(
                          isEs ? 'INVITADO' : 'GUEST',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () => context.push('/auth').then((_) => _loadUserData()),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white, width: 2),
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          ),
                          child: Text(isEs ? 'INICIAR SESIÓN' : 'SIGN IN'),
                        ),
                      ],
                    ],
                  ),
                ),

              const SizedBox(height: 8),

              // ─── SETTINGS SECTIONS ───
              _buildSection(
                title: isEs ? 'MI CUENTA' : 'MY ACCOUNT',
                children: [
                  if (_isLoggedIn) ...[
                    _buildTile(Icons.shopping_bag_outlined, isEs ? 'Mis pedidos' : 'My orders', () {
                      context.push('/orders');
                    }),
                    _buildTile(Icons.assignment_return_outlined, isEs ? 'Mis devoluciones' : 'My returns', () {
                      context.push('/returns');
                    }),
                    _buildTile(Icons.local_shipping_outlined, isEs ? 'Dirección de envío' : 'Shipping address', () {
                      _showAddressDialog(isEs);
                    }),
                  ],
                  if (_isLoggedIn)
                    _buildTile(Icons.lock_outline, isEs ? 'Cambiar contraseña' : 'Change password', () {
                      _showChangePasswordDialog(isEs);
                    }),
                  _buildTile(Icons.language, isEs ? 'Idioma' : 'Language', () {
                    _showLanguageDialog(isEs);
                  }, isLast: true),
                ],
              ),

              _buildSection(
                title: isEs ? 'INFORMACIÓN' : 'INFORMATION',
                children: [
                  _buildTile(Icons.info_outline, isEs ? 'Sobre nosotros' : 'About us', () {
                    context.push('/about');
                  }),
                  _buildTile(Icons.mail_outline, isEs ? 'Contacto' : 'Contact', () {
                    context.push('/contact');
                  }, isLast: true),
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
                    child: Text(
                      isEs ? 'CERRAR SESIÓN' : 'SIGN OUT',
                      style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
                    ),
                  ),
                ),

              const SizedBox(height: 120),
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
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 13,
              letterSpacing: 2,
              color: Colors.black54,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12, width: 1),
            borderRadius: BorderRadius.zero,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF202020).withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildTile(IconData icon, String title, VoidCallback onTap, {bool isLast = false}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: const Color(0xFF202020), size: 22),
          title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black38),
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        if (!isLast)
          const Divider(height: 1, indent: 56, endIndent: 20, color: Colors.black12),
      ],
    );
  }

  // ─── DIALOGS ───


  void _showAddressDialog(bool isEs) {
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
                SnackBar(content: Text('Dirección guardada'), backgroundColor: Color(0xFF202020)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF202020),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: const Text('GUARDAR', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(bool isEs) {
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
                    SnackBar(content: Text('Contraseña actualizada'), backgroundColor: Color(0xFF202020)),
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
              backgroundColor: const Color(0xFF202020),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: const Text('GUARDAR', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(bool isEs) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(isEs ? 'IDIOMA' : 'LANGUAGE', style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
        children: [
          SimpleDialogOption(
            child: const Text('🇪🇸  Español'),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(languageProvider.notifier).setLanguage('es');
            },
          ),
          SimpleDialogOption(
            child: const Text('🇬🇧  English'),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(languageProvider.notifier).setLanguage('en');
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
