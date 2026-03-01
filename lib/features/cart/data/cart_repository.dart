import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../shared/models/cart_item.dart';

class CartRepository {
  static const String _cartKey = 'croma_cart_items';

  Future<List<CartItem>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? itemsJson = prefs.getString(_cartKey);

    if (itemsJson == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(itemsJson);
      return decoded.map((e) => CartItem.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveCartItems(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final String itemsJson = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_cartKey, itemsJson);
  }

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }
}
