// lib/features/cart/presentation/view_models/CartCubit.dart

import 'package:ecommerce/features/cart/presentation/view_models/cart_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/features/home/data/models/ProductModel.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  void addItemToCart(Data product) {
    final currentState = state;

    if (currentState is CartUpdated) {
      final existingItemIndex = currentState.cartItems
          .indexWhere((item) => item.product.id == product.id);

      if (existingItemIndex == -1) {
        // If the item does not exist, add it
        final updatedCartItems = [
          ...currentState.cartItems,
          CartItem(product: product, quantity: 1)
        ];
        emit(CartUpdated(updatedCartItems));
      } else {
        // If it exists, update the quantity
        final existingItem = currentState.cartItems[existingItemIndex];
        final updatedItem =
            existingItem.copyWith(quantity: existingItem.quantity + 1);
        final updatedCartItems = List<CartItem>.from(currentState.cartItems);
        updatedCartItems[existingItemIndex] = updatedItem;
        emit(CartUpdated(updatedCartItems));
      }
    } else {
      // If the state is initial, create a new cart with the item
      emit(CartUpdated([CartItem(product: product, quantity: 1)]));
    }
  }

  void removeItem(Data product) {
    if (state is CartUpdated) {
      final currentItems = (state as CartUpdated).cartItems;
      final existingItemIndex =
          currentItems.indexWhere((item) => item.product.id == product.id);

      if (existingItemIndex != -1) {
        List<CartItem> updatedCartItems;

        final existingItem = currentItems[existingItemIndex];
        if (existingItem.quantity > 1) {
          // Decrease the quantity
          final updatedItem =
              existingItem.copyWith(quantity: existingItem.quantity - 1);
          updatedCartItems = List<CartItem>.from(currentItems);
          updatedCartItems[existingItemIndex] = updatedItem;
        } else {
          // Remove the item completely if quantity is 1
          updatedCartItems = currentItems
              .where((item) => item.product.id != product.id)
              .toList();
        }

        emit(CartUpdated(updatedCartItems));
      }
    }
  }

  void clearCart() {
    emit(CartUpdated([])); // Emit an empty cart state
  }

  double get totalPrice {
    if (state is CartUpdated) {
      return (state as CartUpdated).cartItems.fold(
            0.0,
            (total, item) => total + (item.product.price * item.quantity),
          );
    }
    return 0.0;
  }
}
