class Option {
  final int id;
  final String name;
  final int price;

  Option({
    required this.id,
    required this.name,
    required this.price,
  });

  Option.empty()
      : id = 0,
        name = '',
        price = 0;
}

class FoodItem {
  final int foodId;
  final String name;
  final String category;
  final List<Option> options;
  final String imageUrl;

  FoodItem({
    required this.foodId,
    required this.name,
    required this.category,
    required this.options,
    required this.imageUrl,
  });

  FoodItem.empty()
      : foodId = 0,
        name = '',
        category = '',
        options = [],
        imageUrl = '';
}
