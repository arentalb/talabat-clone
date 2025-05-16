import 'cart_item.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String storeId;
  final List<CartItem> items;
  final int total;
  final String status;
  final DateTime timestamp;

  Order(
      {required this.id,
      required this.storeId,
      required this.items,
      required this.total,
      required this.status,
      required this.timestamp});

  factory Order.fromMap(Map<String, dynamic> map, String id) => Order(
        id: id,
        storeId: map['storeId'],
        items: List<CartItem>.from(map['items']
            .map((e) => CartItem.fromMap(Map<String, dynamic>.from(e)))),
        total: map['total'],
        status: map['status'],
        timestamp: (map['timestamp'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toMap() => {
        'storeId': storeId,
        'items': items.map((e) => e.toMap()).toList(),
        'total': total,
        'status': status,
        'timestamp': Timestamp.fromDate(timestamp),
      };
}
