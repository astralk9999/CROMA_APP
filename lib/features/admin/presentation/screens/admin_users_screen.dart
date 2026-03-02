import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      appBar: const AdminAppBar(title: 'USUARIOS'),
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

          if (filtered.isEmpty) {
            return const Center(child: Text('No se encontraron usuarios'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (val) =>
                            ref.read(userSearchQueryProvider.notifier).state =
                                val,
                        decoration: const InputDecoration(
                          hintText: 'BUSCAR POR NOMBRE O EMAIL...',
                          hintStyle: TextStyle(fontSize: 12, letterSpacing: 1),
                          prefixIcon: Icon(Icons.search, size: 20),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    AdminSortDropdown(
                      value: sortOption,
                      onChanged: (val) =>
                          ref.read(userSortProvider.notifier).state = val,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final user = filtered[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      title: Text(
                        (user['full_name'] as String? ?? 'SIN NOMBRE')
                            .toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      subtitle: Text(
                        user['email'] as String? ?? 'SIN EMAIL',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      trailing: Text(
                        (user['created_at'] as String? ?? '').substring(0, 10),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black38,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const CromaLoading(),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
