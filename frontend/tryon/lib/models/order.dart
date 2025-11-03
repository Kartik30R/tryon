import 'dart:convert';

import 'package:tryon/models/enums.dart';
// import 'enums.dart';

// This is the sub-document in the order's 'items' array
class OrderItem {
  final String itemId; // Not populated, just the ID
  final int qty;
  final num priceAtTime;
  final String id; // sub-document's _id

  OrderItem({
    required this.itemId,
    required this.qty,
    required this.priceAtTime,
    required this.id,
  });
  
  factory OrderItem.fromRawJson(String str) => OrderItem.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        itemId: json["itemId"] as String,
        qty: json["qty"] as int,
        priceAtTime: json["priceAtTime"] as num,
        id: json["_id"] as String,
      );

  Map<String, dynamic> toJson() => {
        "itemId": itemId,
        "qty": qty,
        "priceAtTime": priceAtTime,
        "_id": id,
      };

  // Add copyWith, toString, and equality operators
}

// This is the main Order model
class Order {
  final String id;
  final OrderStatus status;
  final String address;
  final List<OrderItem> items;
  final String userId;
  final num totalPrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Order({
    required this.id,
    required this.status,
    required this.address,
    required this.items,
    required this.userId,
    required this.totalPrice,
    this.createdAt,
    this.updatedAt,
  });

  factory Order.fromRawJson(String str) => Order.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["_id"] as String,
        status: OrderStatus.fromJson(json["status"] as String),
        address: json["address"] as String,
        items: (json["items"] as List<dynamic>?)
                ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        userId: json["userId"] as String,
        totalPrice: json["totalPrice"] as num,
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.tryParse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "status": status.toJson(),
        "address": address,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "userId": userId,
        "totalPrice": totalPrice,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
  
  // Add copyWith, toString, and equality operators
}