import 'dart:convert';

import 'package:tryon/models/cart.dart';
// import 'cart.dart';

// For /auth/login and /auth/signup
class AuthResponse {
  final String msg;
  final String userId;

  AuthResponse({required this.msg, required this.userId});

  factory AuthResponse.fromRawJson(String str) =>
      AuthResponse.fromJson(json.decode(str));
  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        msg: json["msg"] as String,
        userId: json["userId"] as String,
      );
}

// For /cart/add, /cart/remove, /cart/update
class CartResponse {
  final String msg;
  final Cart cart;

  CartResponse({required this.msg, required this.cart});

  factory CartResponse.fromRawJson(String str) =>
      CartResponse.fromJson(json.decode(str));
  factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
        msg: json["msg"] as String,
        cart: Cart.fromJson(json["cart"] as Map<String, dynamic>),
      );
}

// For /order/checkout
class CheckoutResponse {
  final String msg;
  final String orderId;
  final num totalPrice;

  CheckoutResponse({
    required this.msg,
    required this.orderId,
    required this.totalPrice,
  });

  factory CheckoutResponse.fromRawJson(String str) =>
      CheckoutResponse.fromJson(json.decode(str));
  factory CheckoutResponse.fromJson(Map<String, dynamic> json) =>
      CheckoutResponse(
        msg: json["msg"] as String,
        orderId: json["orderId"] as String,
        totalPrice: json["totalPrice"] as num,
      );
}