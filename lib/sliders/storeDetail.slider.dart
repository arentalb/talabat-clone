import 'package:flutter/material.dart';
import 'package:talabat/models/food.model.dart';
import 'package:talabat/models/store.model.dart';
import 'package:talabat/services/store.service.dart';
import 'package:talabat/sliders/foodDetail.slider.dart';
import 'package:talabat/widgets/storedetail.card.dart';

class StoreDetailSlider extends StatefulWidget {
  final String storeId;

  const StoreDetailSlider({super.key, required this.storeId});

  @override
  State<StoreDetailSlider> createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailSlider> {
  final StoreService _storeService = StoreService();
  Store? store;
  List<FoodItem> foods = [];
  String selectedCategory = "";

  @override
  void initState() {
    super.initState();
    fetchStore();
  }

  void fetchStore() async {
    final stores = await _storeService.getStores().first;
    final found = stores.firstWhere((s) => s.id == widget.storeId,
        orElse: () => Store(
            id: '',
            storeName: '',
            storeImageUrl: '',
            categories: [],
            isTrend: false));
    final foodList = await _storeService.getFoods(found.id);
    setState(() {
      store = found;
      foods = foodList;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (store == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final filteredFoods = selectedCategory.isEmpty
        ? foods
        : foods.where((f) => f.category == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title:
            Text(store!.storeName, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 249, 109, 33),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.orange,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/background.png", fit: BoxFit.cover),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(store!.storeName,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(store!.storeImageUrl,
                                  width: 80, height: 80, fit: BoxFit.cover),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: store!.categories.map((category) {
                              final selected = selectedCategory == category;
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selected
                                        ? Colors.orange[100]
                                        : Colors.white,
                                    foregroundColor: Colors.black,
                                  ),
                                  onPressed: () => setState(() {
                                    selectedCategory = selected ? "" : category;
                                  }),
                                  child: Text(category),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        for (var food in filteredFoods)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: StoreDetailCard(
                              name: food.name,
                              description: food.category,
                              imagePath: food.imageUrl,
                              onTap: () => _showCustomBottomSlider(
                                  context, food.id, store!.id),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomBottomSlider(
      BuildContext context, String foodId, String storeId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.3,
          maxChildSize: 1.0,
          builder: (context, scrollController) {
            return FoodDetailSlider(
              foodId: foodId, // Adjust this if `foodId` is string type
              storeId: storeId,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }
}
