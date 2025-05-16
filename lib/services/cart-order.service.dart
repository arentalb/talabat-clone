import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talabat/models/cart_item.model.dart';
import 'package:talabat/models/order.model.dart' as local_order;

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String uid;

  UserService(this.uid);

  Stream<List<CartItem>> getCart() => _db
      .collection('users')
      .doc(uid)
      .collection('cart')
      .snapshots()
      .map((snap) =>
          snap.docs.map((doc) => CartItem.fromMap(doc.data())).toList());

  Future<void> addToCart(CartItem item) async {
    final cartRef = _db.collection('users').doc(uid).collection('cart');

    final currentItems = await cartRef.get();
    final hasDifferentStore = currentItems.docs.any((doc) {
      final data = doc.data();
      return data['storeId'] != item.storeId;
    });

    if (hasDifferentStore) {
      final batch = _db.batch();
      for (final doc in currentItems.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }

    final docId = "${item.foodId}_${item.optionId}";
    await cartRef.doc(docId).set(item.toMap());
  }

  Future<void> removeFromCart(String foodId, int optionId) async {
    final docId = "${foodId}_$optionId";
    await _db
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(docId)
        .delete();
  }

  Future<void> clearCart() async {
    final batch = _db.batch();
    final docs =
        await _db.collection('users').doc(uid).collection('cart').get();
    for (final doc in docs.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Stream<List<local_order.Order>> getOrders() => _db
      .collection('users')
      .doc(uid)
      .collection('orders')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snap) => snap.docs
          .map((doc) => local_order.Order.fromMap(doc.data(), doc.id))
          .toList());

  Future<void> placeOrder(local_order.Order order) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('orders')
        .add(order.toMap());
    await clearCart();
  }
}
