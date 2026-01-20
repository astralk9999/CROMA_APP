import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/product.dart';

part 'cart_provider.g.dart';

class CartItem {
  final Product product;
  final String size;
  final int quantity;

  CartItem({required this.product, required this.size, required this.quantity});

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      size: size,
      quantity: quantity ?? this.quantity,
    );
  }

  // Basic serialization
  Map<String, dynamic> toJson() => {
    'product': {
      'id': product.id,
      'name': product.name,
      'slug': product.slug,
      'price': product.price,
      'stock': product.stock,
      'images': product.images,
      'sizes': product.sizes,
      'featured': product.featured,
      // Minimal fields needed for cart display
    },
    'size': size,
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    // Reconstruct Product (minimal)
    final prodJson = json['product'] as Map<String, dynamic>;
    final product = Product(
      id: prodJson['id'],
      name: prodJson['name'],
      slug: prodJson['slug'],
      price: (prodJson['price'] as num).toDouble(),
      stock: prodJson['stock'],
      images: List<String>.from(prodJson['images']),
      sizes: List<String>.from(prodJson['sizes']),
      featured: prodJson['featured'] ?? false,
    );

    return CartItem(
      product: product,
      size: json['size'],
      quantity: json['quantity'],
    );
  }
}

@riverpod
class Cart extends _$Cart {
  static const _storageKey = 'croma_cart';

  @override
  List<CartItem> build() {
    _loadFromStorage();
    return [];
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);
    if (jsonStr != null) {
      try {
        final List<dynamic> list = jsonDecode(jsonStr);
        state = list.map((e) => CartItem.fromJson(e)).toList();
      } catch (e) {
        // Handle error or clear corrupted storage
      }
    }
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(state.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, jsonStr);
  }

  void addItem(Product product, String size, int quantity) {
    final existingIndex = state.indexWhere(
      (item) => item.product.id == product.id && item.size == size,
    );

    if (existingIndex >= 0) {
      final existingItem = state[existingIndex];
      final newItem = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
      state = [
        ...state.sublist(0, existingIndex),
        newItem,
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      state = [
        ...state,
        CartItem(product: product, size: size, quantity: quantity),
      ];
    }
    _saveToStorage();
  }

  void removeItem(String productId, String size) {
    state = state
        .where((item) => !(item.product.id == productId && item.size == size))
        .toList();
    _saveToStorage();
  }

  void updateQuantity(String productId, String size, int quantity) {
    if (quantity <= 0) {
      removeItem(productId, size);
      return;
    }

    state = state.map((item) {
      if (item.product.id == productId && item.size == size) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
    _saveToStorage();
  }

  void clearCart() {
    state = [];
    _saveToStorage();
  }
}

@riverpod
double cartTotal(Ref ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(
    0,
    (sum, item) => sum + (item.product.price * item.quantity),
  );
}

@riverpod
int cartItemCount(Ref ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.quantity);
}
