import 'package:flutter/material.dart';
import 'package:talabat/models/store.model.dart';
import 'package:talabat/models/food.model.dart';
import 'package:talabat/models/option.model.dart';
import 'package:talabat/services/store.service.dart';

class AdminStorePage extends StatefulWidget {
  const AdminStorePage({super.key});

  @override
  State<AdminStorePage> createState() => _AdminStorePageState();
}

class _AdminStorePageState extends State<AdminStorePage> {
  final storeService = StoreService();

  final _storeNameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _categoriesController = TextEditingController();

  final _foodNameController = TextEditingController();
  final _foodCategoryController = TextEditingController();
  final _foodImageUrlController = TextEditingController();
  final List<Option> _options = [];

  final _optionNameController = TextEditingController();
  final _optionPriceController = TextEditingController();

  String? selectedStoreId;

  void _createStore() async {
    final store = Store(
      id: '',
      storeName: _storeNameController.text.trim(),
      storeImageUrl: _imageUrlController.text.trim(),
      categories:
          _categoriesController.text.split(',').map((c) => c.trim()).toList(),
      isTrend: true,
    );
    await storeService.createStore(store);
    _storeNameController.clear();
    _imageUrlController.clear();
    _categoriesController.clear();
  }

  void _addOption() {
    final name = _optionNameController.text.trim();
    final price = int.tryParse(_optionPriceController.text.trim());
    if (name.isNotEmpty && price != null) {
      setState(() {
        final id = _options.length + 1;
        _options.add(Option(id: id, name: name, price: price));
        _optionNameController.clear();
        _optionPriceController.clear();
      });
    }
  }

  void _addFood() async {
    if (selectedStoreId == null) return;

    final food = FoodItem(
      id: '',
      name: _foodNameController.text.trim(),
      category: _foodCategoryController.text.trim(),
      imageUrl: _foodImageUrlController.text.trim(),
      options: _options.toList(),
    );

    await storeService.addFood(selectedStoreId!, food);
    _foodNameController.clear();
    _foodCategoryController.clear();
    _foodImageUrlController.clear();
    _options.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin - Manage Stores')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create Store',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(
              controller: _storeNameController,
              decoration: const InputDecoration(labelText: 'Store Name'),
            ),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            TextField(
              controller: _categoriesController,
              decoration: const InputDecoration(
                  labelText: 'Categories (comma separated)'),
            ),
            ElevatedButton(
                onPressed: _createStore, child: const Text('Add Store')),
            const Divider(height: 40),
            const Text('Add Food to Store',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            StreamBuilder<List<Store>>(
              stream: storeService.getStores(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return DropdownButton<String>(
                  hint: const Text('Select Store'),
                  value: selectedStoreId,
                  onChanged: (value) => setState(() => selectedStoreId = value),
                  items: snapshot.data!.map((store) {
                    return DropdownMenuItem(
                        value: store.id, child: Text(store.storeName));
                  }).toList(),
                );
              },
            ),
            TextField(
              controller: _foodNameController,
              decoration: const InputDecoration(labelText: 'Food Name'),
            ),
            TextField(
              controller: _foodCategoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: _foodImageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _optionNameController,
                    decoration: const InputDecoration(labelText: 'Option Name'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _optionPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Price'),
                  ),
                ),
                IconButton(
                  onPressed: _addOption,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ..._options.map((opt) => Text('${opt.name} - ${opt.price} IQD')),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _addFood, child: const Text('Add Food')),
          ],
        ),
      ),
    );
  }
}
