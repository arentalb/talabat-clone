import 'option.model.dart';

class FoodItem {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final List<Option> options;

  FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.options,
  });

  factory FoodItem.fromMap(Map<String, dynamic> map, String id) {
    final rawOptions = map['options'] as List<dynamic>?;

    return FoodItem(
      id: id,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      options: rawOptions != null
          ? rawOptions
              .map((e) => Option.fromMap(Map<String, dynamic>.from(e)))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
      'options': options.map((e) => e.toMap()).toList(),
    };
  }
}
