import 'package:talabat/utils/models/cartOrderItem.model.dart';

class Cart {
  int storeId;
  List<CartOrderItem> items;

  Cart({
    required this.storeId,
    required this.items,
  });

  Cart.empty()
      : storeId = 0,
        items = [];
}
