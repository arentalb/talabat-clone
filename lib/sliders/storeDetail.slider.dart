import 'package:flutter/material.dart';
import 'package:talabat/utils/models/store.model.dart';
import 'package:talabat/utils/data/stores.data.dart';
import 'package:talabat/sliders/foodDetail.slider.dart';
import 'package:talabat/widgets/storedetail.card.dart';

class StoreDetailSlider extends StatefulWidget {
  final int storeId;

  const StoreDetailSlider({super.key, required this.storeId});

  @override
  State<StoreDetailSlider> createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailSlider> {
  Store? store;
  String selectedCategory = "";

  @override
  void initState() {
    super.initState();
    fetchStoreData();
  }

  void fetchStoreData() {
    final foundStore = storesData.firstWhere(
      (store) => store.storeId == widget.storeId,
      orElse: () => Store.empty(),
    );

    setState(() {
      store = foundStore;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (store == null) {
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
        title: Text(
          store!.storeName,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 249, 109, 33),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.orange,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset("assets/background.png", fit: BoxFit.cover),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                width: 1,
                                color: Colors.grey,
                              )),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  store!.storeName,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    store!.storeImageUrl,
                                    width: 80,
                                    height: 80,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ...store!.categories.map<Widget>((category) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                          selectedCategory == category
                                              ? Colors.orange[100]
                                              : Colors.white,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (selectedCategory == category) {
                                            selectedCategory = "";
                                          } else {
                                            selectedCategory = category;
                                          }
                                        });
                                      },
                                      child: Text(
                                        category,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          for (var food in store!.foods.where((food) =>
                              selectedCategory.isEmpty ||
                              food.category == selectedCategory))
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: StoreDetailCard(
                                name: food.name,
                                description: food.category,
                                imagePath: food.imageUrl,
                                onTap: () => _showCustomBottomSlider(
                                    context, food.foodId, widget.storeId),
                              ),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showCustomBottomSlider(BuildContext context, int foodId, int storeId) {
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
            foodId: foodId,
            storeId: storeId,
            scrollController: scrollController,
          );
        },
      );
    },
  );
}
