class Option {
  final int id;
  final String name;
  final int price;

  Option({required this.id, required this.name, required this.price});

  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(
      id: map['id'] as int,
      name: map['name'] as String,
      price: map['price'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}
