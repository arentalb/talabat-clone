class Store {
  final String id;
  final String storeName;
  final String storeImageUrl;
  final List<String> categories;
  final bool isTrend;

  Store(
      {required this.id,
      required this.storeName,
      required this.storeImageUrl,
      required this.categories,
      required this.isTrend});

  factory Store.fromMap(Map<String, dynamic> map, String id) => Store(
        id: id,
        storeName: map['storeName'],
        storeImageUrl: map['storeImageUrl'],
        categories: List<String>.from(map['categories']),
        isTrend: map['isTrend'],
      );

  Map<String, dynamic> toMap() => {
        'storeName': storeName,
        'storeImageUrl': storeImageUrl,
        'categories': categories,
        'isTrend': isTrend,
      };
}
