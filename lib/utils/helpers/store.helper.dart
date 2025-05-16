import 'package:talabat/utils/data/cart.data.dart';
import 'package:talabat/utils/data/stores.data.dart';
import 'package:talabat/utils/models/store.model.dart';

Store getStoreOfTheCart() {
  return storesData.firstWhere(
    (store) => store.storeId == cartData.storeId,
    orElse: () => Store(
      storeId: -1,
      isTrend: false,
      storeName: "",
      storeImageUrl: "",
      categories: [],
      foods: [],
    ),
  );
}
