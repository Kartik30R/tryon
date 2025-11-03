import 'dart:convert';

class User {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final bool isAdmin;
  final String? cartId;
  final List<String> orderIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.isAdmin,
    this.cartId,
    required this.orderIds,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"] as String,
        name: json["name"] as String,
        phone: json["phone"] as String,
        email: json["email"] as String,
        address: json["address"] as String,
        isAdmin: json["isAdmin"] as bool? ?? false,
        cartId: json["cartId"] as String?,
        orderIds: (json["orderIds"] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.tryParse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "address": address,
        "isAdmin": isAdmin,
        "cartId": cartId,
        "orderIds": List<dynamic>.from(orderIds.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
  
  // Other helpful methods
  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    bool? isAdmin,
    String? cartId,
    List<String>? orderIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      isAdmin: isAdmin ?? this.isAdmin,
      cartId: cartId ?? this.cartId,
      orderIds: orderIds ?? this.orderIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, isAdmin: $isAdmin)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}