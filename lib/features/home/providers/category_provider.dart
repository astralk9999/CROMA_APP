import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:croma_app/core/services/supabase_service.dart';
import 'package:croma_app/shared/models/category.dart';

part 'category_provider.g.dart';

@riverpod
Future<List<Category>> allCategories(Ref ref) async {
  final response = await SupabaseService.client.from('categories').select();

  return (response as List).map((json) => Category.fromJson(json)).toList();
}
