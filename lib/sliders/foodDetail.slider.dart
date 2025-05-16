import 'package:flutter/material.dart';
import 'package:talabat/models/food.model.dart';
import 'package:talabat/models/option.model.dart';
import 'package:talabat/services/store.service.dart';
import 'package:talabat/services/user.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talabat/models/cart_item.model.dart';

class FoodDetailSlider extends StatefulWidget {
  final String foodId;
  final String storeId;
  final ScrollController scrollController;

  const FoodDetailSlider({
    super.key,
    required this.storeId,
    required this.foodId,
    required this.scrollController,
  });

  @override
  State<FoodDetailSlider> createState() => _FoodDetailSliderState();
}

class _FoodDetailSliderState extends State<FoodDetailSlider> {
  final StoreService _storeService = StoreService();
  late final UserService _userService;

  FoodItem? food;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (user != null) _userService = UserService(user!.uid);
    _loadFoodData();
  }

  Future<void> _loadFoodData() async {
    final foods = await _storeService.getFoods(widget.storeId);
    for (var f in foods) {
      debugPrint('Food: id=${f.id}, name=${f.name}, imageUrl=${f.imageUrl}');
      for (var o in f.options) {
        debugPrint('Option: ${o.id}, name=${o.name}, price=${o.price}');
      }
    }

    final match = foods.firstWhere(
      (f) => f.id == widget.foodId,
      orElse: () =>
          FoodItem(id: '', name: '', category: '', imageUrl: '', options: []),
    );

    setState(() => food = match);
  }

  Widget buildImage(String url) {
    if (url.isEmpty) {
      return const Icon(Icons.image_not_supported, size: 80);
    }

    return Image.network(
      url,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.broken_image),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const SizedBox(
          width: 80,
          height: 80,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (food == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Column(
        children: [
          buildImage(food!.imageUrl),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: SingleChildScrollView(
                controller: widget.scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(food!.name,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 20),
                    const Text('Options:',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 10),
                    ...food!.options
                        .map((option) => _optionRow(option))
                        .toList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionRow(Option option) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${option.name} - ${option.price} IQD',
              style: const TextStyle(fontSize: 16)),
          _optionBtn(foodId: food!.id, optionId: option.id),
        ],
      ),
    );
  }

  Widget _optionBtn({required String foodId, required int optionId}) {
    return StatefulBuilder(builder: (context, setState) {
      int quantity = 0;

      return StreamBuilder<List<CartItem>>(
        stream: _userService.getCart(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final match = snapshot.data!.firstWhere(
              (item) => item.foodId == foodId && item.optionId == optionId,
              orElse: () =>
                  CartItem(foodId: '', optionId: 0, quantity: 0, storeId: ''),
            );
            quantity = match.quantity;
          }

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () async {
                    await _userService.addToCart(CartItem(
                      foodId: foodId,
                      optionId: optionId,
                      quantity: quantity + 1,
                      storeId: widget.storeId,
                    ));
                  },
                  child: const Text("+", style: TextStyle(color: Colors.white)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
                  onPressed: () async {
                    if (quantity > 0) {
                      await _userService.addToCart(CartItem(
                        foodId: foodId,
                        optionId: optionId,
                        quantity: quantity - 1,
                        storeId: widget.storeId,
                      ));
                    }
                  },
                  child: const Text("-", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
