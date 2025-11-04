// --- Item Enums ---

enum ItemSize {
  SMALL,
  MEDIUM,
  LARGE;

  String toJson() => name;
  static ItemSize fromJson(String json) => values.byName(json);
}

// Updated as per your request
enum ItemCategory {
  cloths,
  shoes,
  watch,
  accessories;

  String toJson() => name;
  static ItemCategory fromJson(String json) {
    // Handle backend values that might be different
    if (json == 'upperwear' || json == 'bottomwear') {
      return ItemCategory.cloths;
    }
    try {
      return values.byName(json);
    } catch (e) {
      // Fallback for any unknown category
      return ItemCategory.accessories;
    }
  }
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
