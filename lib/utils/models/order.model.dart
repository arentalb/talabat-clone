import 'package:talabat/utils/models/cartOrderItem.model.dart';

class Order {
  int storeId;
  List<CartOrderItem> items;
  int total;
  String status;

  Order({
    required this.storeId,
    required this.items,
    required this.total,
    required this.status,
  });

  Order.empty()
      : storeId = 0,
        items = [],
        total = 0,
        status = '';
}
