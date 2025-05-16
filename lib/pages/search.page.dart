import 'package:flutter/material.dart';
import 'package:talabat/sliders/foodDetail.slider.dart';
import 'package:talabat/sliders/storeDetail.slider.dart';
import 'package:talabat/models/store.model.dart';
import 'package:talabat/models/food.model.dart';
import 'package:talabat/services/store.service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final StoreService _storeService = StoreService();

  String _searchQuery = "";
  String _searchMode = "Store Name";
  List<Store> _allStores = [];
  List<FoodItem> _allFoods = [];
  List<dynamic> _searchResults = [];

  final List<String> _searchModes = ["Store Name", "Food Name"];

  @override
  void initState() {
    super.initState();
    _loadStoresAndFoods();
  }

  Future<void> _loadStoresAndFoods() async {
    final stores = await _storeService.fetchStoresOnce();
    final allFoods = await _storeService.fetchAllFoodsAcrossStores();

    setState(() {
      _allStores = stores;
      _allFoods = allFoods;
      _searchResults = stores;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();

      if (_searchMode == "Store Name") {
        _searchResults = _allStores.where((store) {
          return store.storeName.toLowerCase().contains(_searchQuery);
        }).toList();
      } else {
        _searchResults = _allFoods.where((food) {
          return food.name.toLowerCase().contains(_searchQuery) ||
              food.category.toLowerCase().contains(_searchQuery);
        }).toList();
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
                        _searchResults =
                            value == "Store Name" ? _allStores : _allFoods;
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
                          leading: Image.network(
                            store.storeImageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                          ),
                          title: Text(store.storeName),
                          subtitle: Text(
                              "Categories: ${store.categories.join(', ')}"),
                          onTap: () {
                            Navigator.of(context)
                                .push(_navigateToStore(store.id));
                          },
                        );
                      } else {
                        final food = _searchResults[index] as FoodItem;
                        final store = _allStores.firstWhere(
                          (store) => store.id == food.id.split("_").first,
                          orElse: () => Store(
                            id: '',
                            storeName: 'Unknown',
                            storeImageUrl: '',
                            categories: [],
                            isTrend: false,
                          ),
                        );
                        return ListTile(
                          leading: Image.network(
                            food.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                          ),
                          title: Text(food.name),
                          subtitle: Text("Category: ${food.category}"),
                          onTap: () {
                            _showCustomBottomSlider(context, food.id, store.id);
                          },
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Route _navigateToStore(String storeId) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          StoreDetailSlider(storeId: storeId),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
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
              foodId: foodId,
              storeId: storeId,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }
}
