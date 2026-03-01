import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filter_provider.g.dart';

class Filters {
  final String? brand;
  final String? color;
  final double? maxPrice;
  final String? sortBy;

  const Filters({this.brand, this.color, this.maxPrice, this.sortBy});

  Filters copyWith({
    String? brand,
    String? color,
    double? maxPrice,
    String? sortBy,
    bool clearBrand = false,
    bool clearColor = false,
    bool clearMaxPrice = false,
  }) {
    return Filters(
      brand: clearBrand ? null : (brand ?? this.brand),
      color: clearColor ? null : (color ?? this.color),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

@riverpod
class ProductFilters extends _$ProductFilters {
  @override
  Filters build() {
    return const Filters();
  }

  void setBrand(String? brand) {
    state = state.copyWith(brand: brand, clearBrand: brand == null);
  }

  void setColor(String? color) {
    state = state.copyWith(color: color, clearColor: color == null);
  }

  void setMaxPrice(double? price) {
    state = state.copyWith(maxPrice: price, clearMaxPrice: price == null);
  }

  void clearAll() {
    state = const Filters();
  }
}
