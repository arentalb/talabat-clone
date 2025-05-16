import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talabat/models/cart_item.model.dart';
import 'package:talabat/models/food.model.dart';
import 'package:talabat/models/option.model.dart';
import 'package:talabat/models/order.model.dart';
import 'package:talabat/services/store.service.dart';
import 'package:talabat/services/user.service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPagePageState();
}

class _CartPagePageState extends State<CartPage> {
  final user = FirebaseAuth.instance.currentUser;
  late final UserService _userService;
  final StoreService _storeService = StoreService();

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _userService = UserService(user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<CartItem>>(
        stream: _userService.getCart(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final cartItems = snapshot.data!;
          if (cartItems.isEmpty) {
            return const Center(
              child: Text(
                "Cart is empty",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          return FutureBuilder<List<FoodItem>>(
            future: _storeService.getFoods(cartItems.first.storeId),
            builder: (context, foodSnapshot) {
              if (!foodSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final foods = foodSnapshot.data!;

              int total = cartItems.fold(0, (sum, item) {
                final food = foods.firstWhere((f) => f.id == item.foodId,
                    orElse: () => FoodItem(
                        id: '',
                        name: '',
                        category: '',
                        imageUrl: '',
                        options: []));
                final opt = food.options.firstWhere(
                    (o) => o.id == item.optionId,
                    orElse: () => Option(id: 0, name: '', price: 0));
                return sum + (item.quantity * opt.price);
              });

              return SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Place the order and have fun",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 14),
                    for (var item in cartItems) _buildCartItem(item, foods),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total is $total IQD",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange),
                            onPressed: () async {
                              // Call placeOrder here using _userService.placeOrder(...)
                              await _userService.placeOrder(
                                Order(
                                  id: '',
                                  storeId: cartItems.first.storeId,
                                  items: cartItems,
                                  total: total,
                                  status: 'pending',
                                  timestamp: DateTime.now(),
                                ),
                              );
                            },
                            child: const Text("Order Now",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCartItem(CartItem item, List<FoodItem> foods) {
    final food = foods.firstWhere((f) => f.id == item.foodId,
        orElse: () => FoodItem(
            id: '', name: 'Unknown', category: '', imageUrl: '', options: []));
    final option = food.options.firstWhere((o) => o.id == item.optionId,
        orElse: () => Option(id: 0, name: 'Unknown', price: 0));

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            children: [
              Image.network(
                food.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 80),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(food.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () async {
                            await _userService.removeFromCart(
                                item.foodId, item.optionId);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          child: const Text("X",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    Text(option.name),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${item.quantity} x ${option.price} IQD"),
                        Text("Total: ${item.quantity * option.price} IQD",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
