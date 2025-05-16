import 'package:flutter/material.dart';
import 'package:talabat/utils/helpers/cart.helper.dart';
import 'package:talabat/utils/helpers/order.helper.dart';
import 'package:talabat/utils/helpers/store.helper.dart';
import 'package:talabat/utils/models/cartOrderItem.model.dart';
import 'package:talabat/utils/models/food_item.model.dart';
import 'package:talabat/utils/models/store.model.dart';
import 'package:talabat/utils/data/cart.data.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPagePageState();
}

class _CartPagePageState extends State<CartPage> {
  Store? currentStore;

  @override
  void initState() {
    super.initState();
    fetchCurrentStore();
  }

  void fetchCurrentStore() {
    currentStore = getStoreOfTheCart();
  }

  @override
  Widget build(BuildContext context) {
    if (calculateCartTotal() <= 0) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Cart", style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 249, 109, 33),
        ),
        body: const Center(
          child: Text(
            "Cart is empty",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart", style: TextStyle(color: Colors.white)),
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
            if (currentStore != null) ...[
              Text(
                currentStore?.storeName ?? "No store found",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              for (var item in cartData.items) _buildCartItem(item),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total is ${calculateCartTotal()} IQD",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.orange),
                        ),
                        onPressed: () {
                          createOrder();
                          setState(() {});
                        },
                        child: const Text(
                          "Order Now",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(CartOrderItem item) {
    final food = currentStore?.foods.firstWhere(
      (foodItem) => foodItem.foodId == item.foodId,
      orElse: () => FoodItem(
        foodId: -1,
        name: "Unknown Food",
        category: "Unknown",
        options: [],
        imageUrl: "",
      ),
    );

    final option = food?.options.firstWhere(
      (option) => option.id == item.optionId,
      orElse: () => Option(id: -1, name: "Unknown Option", price: 0),
    );

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                food!.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          food.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            deleteItemFromCart(food.foodId, option!.id);
                            setState(() {});
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text(
                            "X",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Text(option?.name ?? "Unknown Option"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${item.quantity} x ${option?.price} IQD"),
                        Text(
                          "Total: ${(item.quantity * (option?.price ?? 0))} IQD",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
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
