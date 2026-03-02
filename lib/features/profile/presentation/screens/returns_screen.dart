import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/account_repository.dart';
import '../../../../shared/widgets/croma_loading.dart';
import '../../../../core/providers/language_provider.dart';

class ReturnsScreen extends ConsumerWidget {
  const ReturnsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final returnsAsync = ref.watch(userReturnsProvider);
    final isEs = ref.watch(languageProvider) == 'es';

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => context.pop(),
            ),
            title: Text(
              isEs ? 'MIS DEVOLUCIONES' : 'MY RETURNS',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
          ),
          SliverFillRemaining(
            child: returnsAsync.when(
              data: (returns) {
                if (returns.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.assignment_return_outlined, size: 64, color: Colors.black12),
                        const SizedBox(height: 16),
                        Text(
                          isEs ? 'No tienes solicitudes de devolución' : 'No return requests yet',
                          style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: returns.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final request = returns[index];
                    return _ReturnCard(request: request, isEs: isEs);
                  },
                );
              },
              loading: () => const Center(child: CromaLoading()),
              error: (e, __) => Center(child: Text('Error: \$e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReturnCard extends StatelessWidget {
  final dynamic request;
  final bool isEs;

  const _ReturnCard({required this.request, required this.isEs});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMMd(isEs ? 'es_ES' : 'en_US').format(request.createdAt);
    final statusColor = _getStatusColor(request.status);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF202020), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            offset: const Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RET #${request.id.toString().substring(0, 8).toUpperCase()}',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.zero,
                ),
                child: Text(
                  request.status.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'SOLICITADA EL ${date.toUpperCase()}',
            style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Colors.black12, thickness: 1),
          ),
          Text(
            isEs ? 'MOTIVO DE DEVOLUCIÓN' : 'RETURN REASON',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Colors.black54, letterSpacing: 1),
          ),
          const SizedBox(height: 4),
          Text(
            request.reason.toString().toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          ),
          if (request.details != null && request.details!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              color: const Color(0xFFF9F9F9),
              width: double.infinity,
              child: Text(
                request.details!,
                style: const TextStyle(color: Colors.black54, fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'approved':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
