import 'package:flutter/material.dart';
import 'package:talabat/pages/store_detail.page.dart';
import 'package:talabat/models/store.model.dart';
import 'package:talabat/services/store.service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final StoreService _storeService = StoreService();

  List<Store> _allStores = [];
  List<Store> _filteredStores = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadStores();
  }

  Future<void> _loadStores() async {
    final stores = await _storeService.fetchStoresOnce();
    setState(() {
      _allStores = stores;
      _filteredStores = stores;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredStores = _allStores
          .where(
              (store) => store.storeName.toLowerCase().contains(_searchQuery))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsetsDirectional.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Search for anything ",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search by store name...",
                border: InputBorder.none,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: _filteredStores.isEmpty
                ? const Center(
                    child: Text("No results found",
                        style: TextStyle(fontSize: 16)))
                : ListView.builder(
                    itemCount: _filteredStores.length,
                    itemBuilder: (context, index) {
                      final store = _filteredStores[index];
                      return ListTile(
                        leading: Image.network(
                          store.storeImageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image),
                        ),
                        title: Text(store.storeName),
                        subtitle:
                            Text("Categories: ${store.categories.join(', ')}"),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) =>
                                    StoreDetailPage(storeId: store.id)),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    ));
  }
}
