import 'package:talabat/utils/data/cart.data.dart';
import 'package:talabat/utils/data/stores.data.dart';
import 'package:talabat/utils/models/cartOrderItem.model.dart';
import 'package:talabat/utils/models/food_item.model.dart';

void addItemToCart(int storeId, int foodId, int optionId) {
  final storeIdOfNewItem = storeId;
  if (cartData.items.isNotEmpty && cartData.storeId != storeIdOfNewItem) {
    cartData.items.clear();
    cartData.storeId = storeId;
  }

  final existingItemIndex = cartData.items
      .indexWhere((item) => item.foodId == foodId && item.optionId == optionId);

  if (existingItemIndex != -1) {
    cartData.items[existingItemIndex].quantity++;
  } else {
    cartData.items.add(CartOrderItem(
      foodId: foodId,
      quantity: 1,
      optionId: optionId,
    ));
  }
}

void removeItemFromCart(int foodId, int optionId) {
  final existingItemIndex = cartData.items
      .indexWhere((item) => item.foodId == foodId && item.optionId == optionId);

  if (existingItemIndex != -1) {
    if (cartData.items[existingItemIndex].quantity > 1) {
      cartData.items[existingItemIndex].quantity--;
    } else {
      cartData.items.removeAt(existingItemIndex);
    }
  }
}

void deleteItemFromCart(int foodId, int optionId) {
  cartData.items.removeWhere(
      (item) => item.foodId == foodId && item.optionId == optionId);
}

int calculateCartTotal() {
  int total = 0;

  for (var item in cartData.items) {
    FoodItem food = storesData
        .expand((store) => store.foods)
        .firstWhere((food) => food.foodId == item.foodId);

    Option selectedOption =
        food.options.firstWhere((option) => option.id == item.optionId);

    total += selectedOption.price * item.quantity;
  }

  return total;
}

void clearCart() {
  cartData.items.clear();
  cartData.storeId = -1;
}
