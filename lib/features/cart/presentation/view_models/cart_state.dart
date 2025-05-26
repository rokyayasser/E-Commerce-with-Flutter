// lib/features/cart/presentation/view_models/cart_state.dart

part of 'CartCubit.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  final List<CartItem> cartItems;

  CartUpdated(this.cartItems);
}
