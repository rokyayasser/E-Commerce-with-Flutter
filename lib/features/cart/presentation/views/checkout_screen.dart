import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/features/cart/presentation/view_models/CartCubit.dart';
import 'package:ecommerce/features/cart/data/CartModel.dart';
import 'package:ecommerce/features/home/presentation/views/home_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartInitial ||
              (state is CartUpdated && state.cartItems.isEmpty)) {
            return const Center(child: Text('Your cart is empty.'));
          } else if (state is CartUpdated) {
            final cartItems = state.cartItems;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartItems[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: Image.network(
                              cartItem.product.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                      Icons.error), // Fallback for image errors
                            ),
                            title: Text(cartItem.product.name),
                            subtitle: Text(
                              '\$${cartItem.product.price} x ${cartItem.quantity}',
                            ),
                            trailing: Text(
                              '\$${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: \$${context.read<CartCubit>().totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle order submission logic here
                            // e.g., API call, navigate to confirmation, etc.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Order placed successfully!')),
                            );

                            // Optionally clear the cart after checkout
                            context.read<CartCubit>().clearCart();

                            // Navigate back to the home screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                            );
                          },
                          child: const Text('Place Order'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Unexpected state!'));
          }
        },
      ),
    );
  }
}
