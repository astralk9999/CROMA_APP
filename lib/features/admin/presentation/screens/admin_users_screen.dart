import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/admin_repository.dart';
import '../../../../shared/widgets/croma_app_bar.dart';
import '../../../../shared/widgets/croma_loading.dart';
import '../widgets/admin_drawer.dart';

class AdminUsersScreen extends ConsumerWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allAdminUsersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: CromaAppBar(
        title: const Text(
          'GESTIÓN_USUARIOS',
          style: TextStyle(
            color: Color(0xFF202020),
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ),
      drawer: const AdminDrawer(),
      body: usersAsync.when(
        data: (users) => ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return _UserAdminCard(user: user);
          },
        ),
        loading: () => const Center(child: CromaLoading()),
        error: (e, __) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _UserAdminCard extends StatelessWidget {
  final Map<String, dynamic> user;

  const _UserAdminCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final createdAt = DateTime.tryParse(user['created_at']?.toString() ?? '');
    final dateStr = createdAt != null ? DateFormat('dd/MM/yyyy').format(createdAt) : 'N/A';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(color: Color(0xFFF9F9F9), shape: BoxShape.circle),
            child: const Icon(Icons.person_outline, color: Colors.black26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (user['full_name'] ?? 'USUARIO SIN NOMBRE').toString().toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.black, fontSize: 13, letterSpacing: -0.5),
                ),
                Text(
                  (user['email'] ?? '').toString(),
                  style: const TextStyle(color: Colors.black26, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'REGISTRADO',
                style: TextStyle(color: Colors.black26, fontSize: 8, fontWeight: FontWeight.black, letterSpacing: 1),
              ),
              Text(
                dateStr,
                style: const TextStyle(fontWeight: FontWeight.black, fontSize: 11, tabularNums: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
