import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talabat/models/food.model.dart';
import 'package:talabat/models/store.model.dart';

class StoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Store>> getStores() =>
      _db.collection('stores').snapshots().map((snap) =>
          snap.docs.map((doc) => Store.fromMap(doc.data(), doc.id)).toList());

  Future<List<FoodItem>> getFoods(String storeId) async {
    final snapshot =
        await _db.collection('stores').doc(storeId).collection('foods').get();
    return snapshot.docs
        .map((doc) => FoodItem.fromMap(doc.data(), doc.id))
        .toList();
  }

// bo admin
  Future<void> createStore(Store store) async {
    await _db.collection('stores').add(store.toMap());
  }

  Future<void> addFood(String storeId, FoodItem food) async {
    await _db
        .collection('stores')
        .doc(storeId)
        .collection('foods')
        .add(food.toMap());
  }
}
