import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talabat/models/order.model.dart';
import 'package:talabat/models/food.model.dart';
import 'package:talabat/models/option.model.dart';
import 'package:talabat/services/user.service.dart';
import 'package:talabat/services/store.service.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final user = FirebaseAuth.instance.currentUser;
  late final UserService _userService;
  final StoreService _storeService = StoreService();

  @override
  void initState() {
    super.initState();
    if (user != null) _userService = UserService(user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: user == null
          ? const Center(child: Text("Not logged in"))
          : StreamBuilder<List<Order>>(
              stream: _userService.getOrders(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final orders = snapshot.data!;
                if (orders.isEmpty) {
                  return const Center(child: Text("No orders found."));
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Your Orders",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 14),
                      ...orders.map((order) => FutureBuilder<List<FoodItem>>(
                            future: _storeService.getFoods(order.storeId),
                            builder: (context, foodSnapshot) {
                              final foodList = foodSnapshot.data ?? [];

                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Text('Store ID: ${order.storeId}'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...order.items.map((item) {
                                        final food = foodList.firstWhere(
                                            (f) => f.id == item.foodId,
                                            orElse: () => FoodItem(
                                                id: '',
                                                name: 'Unknown Food',
                                                category: '',
                                                imageUrl: '',
                                                options: []));
                                        final option = food.options.firstWhere(
                                            (o) => o.id == item.optionId,
                                            orElse: () => Option(
                                                id: 0,
                                                name: 'Unknown Option',
                                                price: 0));
                                        return Text(
                                            '${food.name} - ${option.name} x${item.quantity}');
                                      }),
                                      Text('Total: ${order.total} IQD'),
                                      Text('Status: ${order.status}'),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
