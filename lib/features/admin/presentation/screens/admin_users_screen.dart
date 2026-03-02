import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/admin_repository.dart';
import '../../../../shared/widgets/croma_loading.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_drawer.dart';
import '../widgets/admin_sort_dropdown.dart';

final userSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');
final userSortProvider = StateProvider.autoDispose<AdminSortOption>(
  (ref) => AdminSortOption.newest,
);

class AdminUsersScreen extends ConsumerWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allAdminUsersProvider);
    final searchQuery = ref.watch(userSearchQueryProvider);
    final sortOption = ref.watch(userSortProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminAppBar(title: 'GESTIÓN DE USUARIOS'),
      drawer: const AdminDrawer(),
      body: usersAsync.when(
        data: (users) {
          var filtered = users.where((u) {
            final name = (u['full_name'] as String? ?? '').toLowerCase();
            final email = (u['email'] as String? ?? '').toLowerCase();
            final query = searchQuery.toLowerCase();
            return name.contains(query) || email.contains(query);
          }).toList();

          filtered.sort((a, b) {
            switch (sortOption) {
              case AdminSortOption.newest:
                return (b['created_at'] as String? ?? '').compareTo(
                  a['created_at'] as String? ?? '',
                );
              case AdminSortOption.oldest:
                return (a['created_at'] as String? ?? '').compareTo(
                  b['created_at'] as String? ?? '',
                );
              case AdminSortOption.alphabetical:
                return (a['full_name'] as String? ?? '').compareTo(
                  b['full_name'] as String? ?? '',
                );
              default:
                return 0;
            }
          });

          return CustomScrollView(
            slivers: [
              _buildIndustrialActionBar(
                context,
                ref,
                filtered.length,
                users.length,
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final user = filtered[index];
                    return _UserAdminCard(user: user);
                  }, childCount: filtered.length),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
        loading: () => const Center(child: CromaLoading()),
        error: (e, __) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildIndustrialActionBar(
    BuildContext context,
    WidgetRef ref,
    int visibleCount,
    int totalCount,
  ) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(bottom: 24.0, top: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF18181b),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 50,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: Colors.white54,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              onChanged: (val) =>
                                  ref
                                          .read(
                                            userSearchQueryProvider.notifier,
                                          )
                                          .state =
                                      val,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.0,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'IDENTIFICAR USUARIO...',
                                hintStyle: TextStyle(
                                  color: Colors.white24,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0,
                                ),
                                border: InputBorder.none,
                                filled: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  AdminSortDropdown(
                    value: ref.watch(userSortProvider),
                    onChanged: (val) =>
                        ref.read(userSortProvider.notifier).state = val,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.black.withValues(alpha: 0.03),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.05),
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF3f3f46),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ref.watch(userSearchQueryProvider).isEmpty
                            ? '$totalCount PERFILES REGISTRADOS'
                            : '$visibleCount DE $totalCount RESULTADOS',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.black.withValues(alpha: 0.03),
                  ),
                ),
              ],
            ),
          ],
        ),
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
    final dateStr = createdAt != null
        ? DateFormat('dd/MM/yyyy').format(createdAt)
        : 'N/A';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFF9F9F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline, color: Colors.black26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (user['full_name'] ?? 'USUARIO SIN NOMBRE')
                      .toString()
                      .toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  (user['email'] ?? '').toString(),
                  style: const TextStyle(
                    color: Colors.black26,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'REGISTRADO',
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              Text(
                dateStr,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
