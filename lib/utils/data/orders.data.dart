import 'package:talabat/utils/models/cartOrderItem.model.dart';
import 'package:talabat/utils/models/order.model.dart';

List<Order> ordersData = [
  Order(
    storeId: 1,
    items: [
      CartOrderItem(foodId: 101, quantity: 2, optionId: 1),
      CartOrderItem(foodId: 102, quantity: 3, optionId: 2),
    ],
    total: 20000,
    status: "delivered",
  ),
  Order(
    storeId: 2,
    items: [
      CartOrderItem(foodId: 201, quantity: 1, optionId: 1),
      CartOrderItem(foodId: 202, quantity: 4, optionId: 2),
    ],
    total: 35000,
    status: "pending ...",
  ),
  Order(
    storeId: 2,
    items: [
      CartOrderItem(foodId: 201, quantity: 1, optionId: 1),
      CartOrderItem(foodId: 202, quantity: 4, optionId: 2),
    ],
    total: 35000,
    status: "on its way ...",
  ),
  Order(
    storeId: 3,
    items: [
      CartOrderItem(foodId: 301, quantity: 1, optionId: 3),
      CartOrderItem(foodId: 301, quantity: 4, optionId: 1),
    ],
    total: 35000,
    status: "cooking ...",
  ),
  Order(
    storeId: 4,
    items: [
      CartOrderItem(foodId: 401, quantity: 1, optionId: 1),
      CartOrderItem(foodId: 403, quantity: 4, optionId: 1),
    ],
    total: 35000,
    status: "uhd ...",
  ),
];
