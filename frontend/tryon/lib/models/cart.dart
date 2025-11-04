import 'dart:convert';
import 'package:tryon/models/item.dart';

// This is the sub-document in the cart's 'items' array
class CartItem {
  final Item? item; // Populated from 'itemId', MADE NULLABLE
  final int qty;
  final String id; // This is the sub-document's _id

  CartItem({
    required this.item,
    required this.qty,
    required this.id,
  });

  factory CartItem.fromRawJson(String str) =>
      CartItem.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        // --- FIX ---
        // Check if 'itemId' is null or not a Map before parsing
        item: json["itemId"] == null || json["itemId"] is! Map<String, dynamic>
            ? null // Set item to null if data is bad
            : Item.fromJson(json["itemId"] as Map<String, dynamic>),
        // --- END FIX ---
        qty: json["qty"] as int,
        id: json["_id"] as String,
      );

  Map<String, dynamic> toJson() => {
        "itemId": item?.toJson(), // Use null-safe operator
        "qty": qty,
        "_id": id,
      };

  CartItem copyWith({
    Item? item,
    int? qty,
    String? id,
  }) {
    return CartItem(
      item: item ?? this.item,
      qty: qty ?? this.qty,
      id: id ?? this.id,
    );
  }
}

// This is the main Cart model
class Cart {
  final String id;
  final String userId;
  final List<CartItem> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Cart({
    required this.id,
    required this.userId,
    required this.items,
    this.createdAt,
    this.updatedAt,
  });

  factory Cart.fromRawJson(String str) => Cart.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["_id"] as String,
        userId: json["userId"] as String,
        // --- FIX ---
        // Filter out any items that have a null item object after parsing
        items: (json["items"] as List<dynamic>?)
                ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
                .where((cartItem) => cartItem.item != null) // Filters out null items
                .toList() ??
            [],
        // --- END FIX ---
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.tryParse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
