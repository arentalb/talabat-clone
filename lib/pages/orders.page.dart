import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talabat/models/order.model.dart';
import 'package:talabat/models/food.model.dart';
import 'package:talabat/models/option.model.dart';
import 'package:talabat/models/store.model.dart';
import 'package:talabat/services/cart-order.service.dart';
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 3),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("You haven't placed any orders yet.",
                        style: TextStyle(fontSize: 16)),
                  );
                }

                final orders = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: orders.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          "Track your delicious orders below ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    }

                    final order = orders[index - 1];

                    return FutureBuilder(
                      future: Future.wait([
                        _storeService.getStoreById(order.storeId),
                        _storeService.getFoods(order.storeId)
                      ]),
                      builder: (context, AsyncSnapshot<List<dynamic>> snap) {
                        if (!snap.hasData) {
                          return const SizedBox.shrink();
                        }

                        final store = snap.data![0] as Store?;
                        final foodList = snap.data![1] as List<FoodItem>;
                        final storeName = store?.storeName ?? "Unknown Store";

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Order from: $storeName",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              ...order.items.map((item) {
                                final food = foodList.firstWhere(
                                  (f) => f.id == item.foodId,
                                  orElse: () => FoodItem(
                                      id: '',
                                      name: 'Unknown Food',
                                      category: '',
                                      imageUrl: '',
                                      options: []),
                                );
                                final option = food.options.firstWhere(
                                  (o) => o.id == item.optionId,
                                  orElse: () =>
                                      Option(id: 0, name: 'Unknown', price: 0),
                                );

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                      "${food.name} - ${option.name} x${item.quantity}"),
                                );
                              }).toList(),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total: ${order.total} IQD",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Chip(
                                    label: Text(order.status),
                                    backgroundColor: order.status == "pending"
                                        ? Colors.orange.shade100
                                        : Colors.green.shade100,
                                    labelStyle: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
