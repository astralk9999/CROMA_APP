import 'package:flutter/material.dart';

enum AdminSortOption {
  newest,
  oldest,
  priceDesc,
  priceAsc,
  stockDesc,
  stockAsc,
  alphabetical,
}

class AdminSortDropdown extends StatelessWidget {
  final AdminSortOption value;
  final ValueChanged<AdminSortOption> onChanged;

  const AdminSortDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AdminSortOption>(
          value: value,
          dropdownColor: const Color(0xFF27272a),
          icon: const Icon(Icons.sort, color: Colors.white54, size: 16),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
          items: const [
            DropdownMenuItem(value: AdminSortOption.newest, child: Text('MÁS RECIENTES')),
            DropdownMenuItem(value: AdminSortOption.oldest, child: Text('MÁS ANTIGUOS')),
            DropdownMenuItem(value: AdminSortOption.alphabetical, child: Text('A - Z')),
            DropdownMenuItem(value: AdminSortOption.priceDesc, child: Text('MAYOR PRECIO/VALOR')),
            DropdownMenuItem(value: AdminSortOption.priceAsc, child: Text('MENOR PRECIO/VALOR')),
            DropdownMenuItem(value: AdminSortOption.stockDesc, child: Text('MAYOR CANTIDAD')),
            DropdownMenuItem(value: AdminSortOption.stockAsc, child: Text('MENOR CANTIDAD')),
          ],
        ),
      ),
    );
  }
}
