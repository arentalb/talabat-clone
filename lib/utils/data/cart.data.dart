import 'package:talabat/utils/models/cart.model.dart';
import 'package:talabat/utils/models/cartOrderItem.model.dart';

List<CartOrderItem> cartItems = [
  CartOrderItem(foodId: 101, quantity: 2, optionId: 1),
  CartOrderItem(foodId: 102, quantity: 3, optionId: 2),
];

Cart cartData = Cart(storeId: 1, items: cartItems);
