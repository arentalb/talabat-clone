import 'package:flutter/material.dart';
import 'package:talabat/utils/data/orders.data.dart';
import 'package:talabat/utils/data/stores.data.dart';

import 'package:talabat/utils/helpers/order.helper.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 249, 109, 33),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Place the order and have fun",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            ...ordersData.map<Widget>((order) {
              final storeId = order.storeId;
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
                  title: Text(
                      'Store: ${storesData.firstWhere((store) => store.storeId == storeId).storeName}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...order.items.map<Widget>((item) {
                        final foodName = getFoodName(storeId, item.foodId);
                        final optionName =
                            getOptionName(storeId, item.foodId, item.optionId);
                        return Text(
                            '$foodName - $optionName x${item.quantity}');
                      }),
                      Text('Total: \$${order.total}'),
                      Text('Status: ${order.status}'),
                    ],
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
