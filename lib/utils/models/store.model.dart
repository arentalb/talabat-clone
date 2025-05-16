import 'food_item.model.dart';

class Store {
  final int storeId;
  final bool isTrend;
  final String storeName;
  final String storeImageUrl;
  final List<String> categories;
  final List<FoodItem> foods;

  Store({
    required this.storeId,
    required this.isTrend,
    required this.storeName,
    required this.storeImageUrl,
    required this.categories,
    required this.foods,
  });

  Store.empty()
      : storeId = 0,
        isTrend = false,
        storeName = '',
        storeImageUrl = '',
        categories = [],
        foods = [];
}
