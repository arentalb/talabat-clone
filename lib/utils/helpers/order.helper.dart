import 'package:talabat/utils/data/cart.data.dart';
import 'package:talabat/utils/data/orders.data.dart';
import 'package:talabat/utils/data/stores.data.dart';
import 'package:talabat/utils/helpers/cart.helper.dart';
import 'package:talabat/utils/models/order.model.dart';

void createOrder() {
  int total = calculateCartTotal();
  final newOrder = Order(
    storeId: cartData.storeId,
    items: List.from(cartData.items),
    total: total,
    status: "pending",
  );
  ordersData.add(newOrder);
  clearCart();
}

String getFoodName(int storeId, int foodId) {
  final store = storesData.firstWhere((store) => store.storeId == storeId);
  final food = store.foods.firstWhere((food) => food.foodId == foodId);
  return food.name;
}

String getOptionName(int storeId, int foodId, int optionId) {
  final store = storesData.firstWhere((store) => store.storeId == storeId);
  final food = store.foods.firstWhere((food) => food.foodId == foodId);
  final option = food.options.firstWhere((option) => option.id == optionId);
  return option.name;
}
