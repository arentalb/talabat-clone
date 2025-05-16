class CartOrderItem {
  int foodId;
  int quantity;
  int optionId;

  CartOrderItem({
    required this.foodId,
    required this.quantity,
    required this.optionId,
  });

  CartOrderItem.empty()
      : foodId = 0,
        quantity = 0,
        optionId = 0;
}
