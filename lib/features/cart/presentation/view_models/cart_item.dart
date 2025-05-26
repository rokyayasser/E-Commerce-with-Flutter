// lib/features/cart/data/CartItem.dart

import 'package:ecommerce/features/home/data/models/ProductModel.dart';

class CartItem {
  final Data product;
  final int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }
}
