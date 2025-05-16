import 'package:flutter/material.dart';
import 'package:talabat/utils/data/cart.data.dart';
import 'package:talabat/utils/helpers/cart.helper.dart';
import 'package:talabat/utils/models/cart.model.dart';
import 'package:talabat/utils/models/food_item.model.dart';
import 'package:talabat/utils/models/store.model.dart';
import 'package:talabat/utils/data/stores.data.dart';

class FoodDetailSlider extends StatefulWidget {
  final int storeId;
  final int foodId;
  final ScrollController scrollController;

  const FoodDetailSlider({
    super.key,
    required this.storeId,
    required this.foodId,
    required this.scrollController,
  });

  @override
  State<FoodDetailSlider> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailSlider> {
  Store? store;
  FoodItem? food;
  Cart cart = cartData;

  @override
  void initState() {
    super.initState();
    fetchStoreData();
  }

  void fetchStoreData() {
    store = storesData.firstWhere(
      (store) => store.storeId == widget.storeId,
      orElse: () => Store.empty(),
    );

    if (store != null) {
      food = store!.foods.firstWhere(
        (food) => food.foodId == widget.foodId,
        orElse: () => FoodItem.empty(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (store == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Store not founded ",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            food!.imageUrl,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                controller: widget.scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food!.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Options:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...food!.options.map<Widget>((option) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${option.id}: ${option.name} - ${option.price} IQD',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                                _optionBtn(
                                  storeId: widget.storeId,
                                  foodId: widget.foodId,
                                  optionId: option.id,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      })
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionBtn({
    required int storeId,
    required int foodId,
    required int optionId,
  }) {
    return StatefulBuilder(builder: (context, setState) {
      final quantity = cart.items.indexWhere((item) =>
                  item.foodId == foodId && item.optionId == optionId) !=
              -1
          ? cart.items
              .firstWhere(
                  (item) => item.foodId == foodId && item.optionId == optionId)
              .quantity
          : 0;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                addItemToCart(storeId, foodId, optionId);
                setState(() {});
              },
              child: const Text(
                "+",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '$quantity',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                removeItemFromCart(foodId, optionId);
                setState(() {});
              },
              child: const Text(
                "-",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    });
  }
}
