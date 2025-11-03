import 'dart:convert';

import 'package:tryon/models/enums.dart';
// Import your enums file
// import 'enums.dart';

class Item {
  final String id;
  final String name;
  final String? description;
  final ItemSize size;
  final num price;
  final ItemCategory category;
  final String? wannaUrl;
  final String? lensId;
  final String? assetGroupId;
  final String? assetModelId;
  final List<String> imagesUrl;
  final String? deepARUrl;
  final ArType ar;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Item({
    required this.id,
    required this.name,
    this.description,
    required this.size,
    required this.price,
    required this.category,
    this.wannaUrl,
    this.lensId,
    this.assetGroupId,
    this.assetModelId,
    required this.imagesUrl,
    this.deepARUrl,
    required this.ar,
    this.createdAt,
    this.updatedAt,
  });

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["_id"] as String,
        name: json["name"] as String,
        description: json["description"] as String?,
        size: ItemSize.fromJson(json["size"] as String),
        price: json["price"] as num,
        category: ItemCategory.fromJson(json["category"] as String),
        wannaUrl: json["wannaUrl"] as String?,
        lensId: json["lensId"] as String?,
        assetGroupId: json["assetGroupId"] as String?,
        assetModelId: json["assetModelId"] as String?,
        imagesUrl: (json["imagesUrl"] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        deepARUrl: json["deepARUrl"] as String?,
        ar: ArType.fromJson(json["AR"] as String),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.tryParse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        // We don't send _id when creating, but good to have for updates
        // if (id != null) "_id": id, 
        "name": name,
        "description": description,
        "size": size.toJson(),
        "price": price,
        "category": category.toJson(),
        "wannaUrl": wannaUrl,
        "lensId": lensId,
        "assetGroupId": assetGroupId,
        "assetModelId": assetModelId,
        "imagesUrl": List<dynamic>.from(imagesUrl.map((x) => x)),
        "deepARUrl": deepARUrl,
        "AR": ar.toJson(),
      };
  
  // Add copyWith, toString, and equality operators similar to User model
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Item && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}