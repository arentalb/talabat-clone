class CartItem {
  final String foodId;
  final int optionId;
  final int quantity;
  final String storeId;

  CartItem(
      {required this.foodId,
      required this.optionId,
      required this.quantity,
      required this.storeId});

  factory CartItem.fromMap(Map<String, dynamic> map) => CartItem(
        foodId: map['foodId'],
        optionId: map['optionId'],
        quantity: map['quantity'],
        storeId: map['storeId'],
      );

  Map<String, dynamic> toMap() => {
        'foodId': foodId,
        'optionId': optionId,
        'quantity': quantity,
        'storeId': storeId,
      };
}
