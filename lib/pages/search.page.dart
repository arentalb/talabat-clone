import 'package:flutter/material.dart';
import 'package:talabat/sliders/foodDetail.slider.dart';
import 'package:talabat/sliders/storeDetail.slider.dart';
import 'package:talabat/utils/data/stores.data.dart';
import 'package:talabat/utils/models/food_item.model.dart';
import 'package:talabat/utils/models/store.model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchQuery = "";
  String _searchMode = "Store Name";
  List<dynamic> _searchResults = [];

  final List<String> _searchModes = ["Store Name", "Food Name"];

  @override
  void initState() {
    super.initState();
    _searchResults = storesData;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();

      if (_searchMode == "Store Name") {
        _searchResults = storesData.where((store) {
          return store.storeName.toLowerCase().contains(_searchQuery);
        }).toList();
      } else if (_searchMode == "Food Name") {
        _searchResults = storesData
            .expand((store) => store.foods)
            .where((food) =>
                food.name.toLowerCase().contains(_searchQuery) ||
                food.category.toLowerCase().contains(_searchQuery))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 249, 109, 33),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: _searchMode,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _searchMode = value;
                        _searchResults = _searchMode == "Store Name"
                            ? storesData
                            : storesData
                                .expand((store) => store.foods)
                                .toList();
                        _searchQuery = "";
                      });
                    }
                  },
                  items: _searchModes.map((mode) {
                    return DropdownMenuItem<String>(
                      value: mode,
                      child: Text(mode),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Search...",
                      border: InputBorder.none,
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _searchResults.isEmpty
                ? const Center(
                    child: Text(
                      "No results found",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      if (_searchMode == "Store Name") {
                        final store = _searchResults[index] as Store;
                        return ListTile(
                          leading: Image.asset(
                            store.storeImageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(store.storeName),
                          subtitle: Text(
                              "Categories: ${store.categories.join(', ')}"),
                          onTap: () {
                            Navigator.of(context)
                                .push(_navigateToStore(store.storeId));
                          },
                        );
                      } else if (_searchMode == "Food Name") {
                        final food = _searchResults[index] as FoodItem;
                        return ListTile(
                          leading: Image.asset(
                            food.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(food.name),
                          subtitle: Text("Category: ${food.category}"),
                          onTap: () {
                            final store = storesData.firstWhere(
                              (store) => store.foods
                                  .any((f) => f.foodId == food.foodId),
                              orElse: () => Store.empty(),
                            );

                            _showCustomBottomSlider(
                              context,
                              food.foodId,
                              store.storeId,
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

Route _navigateToStore(int storeId) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        StoreDetailSlider(storeId: storeId),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
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
