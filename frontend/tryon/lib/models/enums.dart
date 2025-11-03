// --- Item Enums ---

enum ItemSize {
  SMALL,
  MEDIUM,
  LARGE;

  String toJson() => name;
  static ItemSize fromJson(String json) => values.byName(json);
}

enum ItemCategory {
  upperwear,
  bottomwear,
  shoes,
  watch,
  accessories;

  String toJson() => name;
  static ItemCategory fromJson(String json) => values.byName(json);
}

enum ArType {
  WANNA,
  LENS,
  DEEP;

  String toJson() => name;
  static ArType fromJson(String json) => values.byName(json);
}

// --- Order Enum ---

enum OrderStatus {
  PENDING,
  CONFIRMED,
  SHIPPED,
  DELIVERED,
  CANCELLED;

  String toJson() => name;
  static OrderStatus fromJson(String json) => values.byName(json);
}