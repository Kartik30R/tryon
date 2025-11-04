import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:tryon/core/api/api_service.dart';
import 'package:tryon/core/network/api_client.dart';
import 'package:tryon/core/utils/shared_pref_utils.dart';
import 'package:tryon/models/cart.dart';
import 'package:tryon/models/item.dart';
import 'package:tryon/models/order.dart';
import 'package:tryon/models/user.dart';

class AppProvider extends ChangeNotifier {
  late ApiService _apiService;

  // App-wide state
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String? _userId;
  String? get userId => _userId;

  User? _currentUser;
  User? get currentUser => _currentUser;

  // Loading and Error states
  bool _authLoading = false;
  bool get authLoading => _authLoading;
  String? _authError;
  String? get authError => _authError;

  bool _itemsLoading = false;
  bool get itemsLoading => _itemsLoading;
  String? _itemsError;
  String? get itemsError => _itemsError;

  bool _cartLoading = false;
  bool get cartLoading => _cartLoading;
  String? _cartError;
  String? get cartError => _cartError;

  bool _ordersLoading = false;
  bool get ordersLoading => _ordersLoading;
  String? _ordersError;
  String? get ordersError => _ordersError;

  // Data
  List<Item> _allItems = [];
  List<Item> get allItems => _allItems;

  Cart? _cart;
  Cart? get cart => _cart;

  List<Order> _userOrders = [];
  List<Order> get userOrders => _userOrders;

  AppProvider() {
    _apiService = ApiClient().apiService;
    _init();
  }

  /// Check shared prefs for a saved session on app start
  Future<void> _init() async {
    if (SharedPrefUtils.isLoggedIn()) {
      _isLoggedIn = true;
      _userId = SharedPrefUtils.getUserId();
      if (_userId != null) {
        await _loadUserSession();
      } else {
        // Mismatch, clear session
        await logout();
      }
    }
    notifyListeners();
  }

  /// Loads all user data after an init or login
  Future<void> _loadUserSession() async {
    _authLoading = true;
    notifyListeners();
    try {
      await Future.wait([
        fetchUserData(),
        fetchAllItems(),
        fetchCart(),
        fetchUserOrders(),
      ]);
      _authLoading = false;
      notifyListeners();
    } catch (e) {
      _authError = "Failed to load user session.";
      _authLoading = false;
      notifyListeners();
    }
  }

  // ========== AUTH ACTIONS ==========

  /// Fetches user data and stores it in _currentUser
  Future<void> fetchUserData() async {
    if (_userId == null) {
      _authError = "User ID not found.";
      return;
    }

    _authLoading = true;
    // Don't notify yet, let the caller decide
    
    try {
      _currentUser = await _apiService.getUserById(_userId!);
    } on DioException catch (e) {
      _authError = _parseError(e, "Failed to load user data.");
    } catch (e) {
      _authError = "An unexpected error occurred loading user data.";
    } finally {
      _authLoading = false;
      notifyListeners();
    }
  }

  /// Logs in a user with email and password.
  /// Returns `true` on success, `false` on failure.
  Future<bool> login(String email, String password) async {
    _authLoading = true;
    _authError = null;
    notifyListeners();

    try {
      final body = {"email": email, "password": password};
      final response = await _apiService.login(body);

      _userId = response.userId;
      _isLoggedIn = true;
      await SharedPrefUtils.saveUserSession(_userId!);

      // Load all user data
      await _loadUserSession(); // This will notify listeners when done

      return true;
    } on DioException catch (e) {
      _authError = _parseError(e, "Invalid credentials. Please try again.");
      _authLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _authError = "An unexpected error occurred.";
      _authLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Signs up a new user.
  /// Returns `true` on success, `false` on failure.
  Future<bool> signup({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String address,
  }) async {
    _authLoading = true;
    _authError = null;
    notifyListeners();

    try {
      final body = {
        "name": name,
        "phone": phone,
        "email": email,
        "password": password,
        "address": address,
      };
      final response = await _apiService.signup(body);

      _userId = response.userId;
      _isLoggedIn = true;
      await SharedPrefUtils.saveUserSession(_userId!);

      // Load all user data
      await _loadUserSession(); // This will notify listeners when done

      return true;
    } on DioException catch (e) {
      _authError = _parseError(e, "Signup failed. Please try again.");
      _authLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _authError = "An unexpected error occurred.";
      _authLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logs out the current user and clears all session data.
  Future<void> logout() async {
    _isLoggedIn = false;
    _userId = null;
    _currentUser = null;
    _cart = null;
    _userOrders = [];
    _allItems = []; // Clear item catalog

    // Clear all errors
    _authError = null;
    _cartError = null;
    _ordersError = null;
    _itemsError = null;

    await SharedPrefUtils.clearUserSession();
    notifyListeners();
  }

  // ========== ITEM ACTIONS ==========

  /// Fetches all items from the server
  Future<void> fetchAllItems() async {
    _itemsLoading = true;
    _itemsError = null;
    // Don't notify if called from _loadUserSession
    if (!_authLoading) notifyListeners();

    try {
      _allItems = await _apiService.getAllItems();
    } on DioException catch (e) {
      _itemsError = _parseError(e, "Failed to load items.");
    } catch (e) {
      _itemsError = "An unexpected error occurred.";
    } finally {
      _itemsLoading = false;
      if (!_authLoading) notifyListeners();
    }
  }

  // ========== CART ACTIONS ==========

  /// Fetches the user's cart
  Future<void> fetchCart() async {
    if (_userId == null) return;

    _cartLoading = true;
    _cartError = null;
    // Don't notify if called from _loadUserSession
    if (!_authLoading) notifyListeners();

    try {
      _cart = await _apiService.getCart(_userId!);
    } on DioException catch (e) {
      _cartError = _parseError(e, "Failed to load cart.");
    } catch (e) {
      _cartError = "An unexpected error occurred.";
    } finally {
      _cartLoading = false;
      if (!_authLoading) notifyListeners();
    }
  }

  /// Adds an item to the cart.
  Future<void> addItemToCart(String itemId) async {
    if (_userId == null) return;

    _cartLoading = true;
    _cartError = null;
    notifyListeners();

    try {
      final body = {"userId": _userId, "itemId": itemId};
      // Don't use the returned cart, it's not populated.
      await _apiService.addItemToCart(body);

      // Fetch the full cart to get populated data
      await fetchCart();
    } on DioException catch (e) {
      _cartError = _parseError(e, "Failed to add item.");
    } catch (e) {
      _cartError = "An unexpected error occurred.";
    } finally {
      _cartLoading = false;
      notifyListeners();
    }
  }

  /// Updates an item's quantity in the cart.
  /// If qty <= 0, the item is removed.
  Future<void> updateCartItemQty(String itemId, int newQty) async {
    if (_userId == null) return;

    // Optimistic UI update
    final originalCart = _cart;
    if (newQty <= 0) {
      // Remove item
      _cart?.items.removeWhere((item) => item.item?.id == itemId);
    } else {
      // Update qty
      final index = _cart?.items.indexWhere((item) => item.item?.id == itemId);
      if (index != null && index != -1) {
        _cart?.items[index] = _cart!.items[index].copyWith(qty: newQty);
      }
    }
    _cartError = null;
    notifyListeners();

    try {
      final body = {
        "userId": _userId,
        "itemId": itemId,
        "updates": {"qty": newQty}
      };
      // API call in the background
      await _apiService.updateCartItem(body);
      // Fetch cart to re-sync
      await fetchCart();
    } on DioException catch (e) {
      _cartError = _parseError(e, "Failed to update cart.");
      _cart = originalCart; // Revert
      notifyListeners();
    } catch (e) {
      _cartError = "An unexpected error occurred.";
      _cart = originalCart; // Revert
      notifyListeners();
    }
  }

  /// Checks out the cart and creates an order.
  /// Returns `true` on success, `false` on failure.
  Future<bool> checkout(String address) async {
    _cartLoading = true;
    _cartError = null;
    notifyListeners();

    if (_userId == null) {
      _cartError = "User not logged in.";
      _cartLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final body = {"userId": _userId, "address": address};
      await _apiService.checkout(body);

      // Clear local cart and fetch empty one
      _cart = null;
      await fetchCart();
      // Refresh order list
      await fetchUserOrders();

      _cartLoading = false;
      // No notifyListeners() needed, fetchCart/fetchUserOrders will do it
      return true;
    } on DioException catch (e) {
      _cartError = _parseError(e, "Checkout failed.");
      _cartLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _cartError = "An unexpected error occurred during checkout.";
      _cartLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ========== ORDER ACTIONS ==========

  /// Fetches all orders for the current user
  Future<void> fetchUserOrders() async {
    if (_userId == null) return;

    _ordersLoading = true;
    _ordersError = null;
    if (!_authLoading) notifyListeners();

    try {
      _userOrders = await _apiService.getUserOrders(_userId!);
    } on DioException catch (e) {
      _ordersError = _parseError(e, "Failed to load orders.");
    } catch (e) {
      _ordersError = "An unexpected error occurred.";
    } finally {
      _ordersLoading = false;
      if (!_authLoading) notifyListeners();
    }
  }

  // ========== HELPERS ==========

  /// Parses a DioException to get a user-friendly error message.
  String _parseError(DioException e,
      [String defaultMsg = "An error occurred."]) {
    // --- FIX ---
    // Make this function safer to handle non-Map error responses (like 520 HTML)
    try {
      if (e.response != null &&
          e.response!.data != null &&
          e.response!.data is Map) {
        final data = e.response!.data as Map;
        // Safely check for 'msg' key
        if (data.containsKey('msg')) {
          return data['msg']?.toString() ?? defaultMsg;
        }
      }
      // If response is not a Map (e.g., HTML from a 520 error), return default.
    } catch (_) {
      // Fallback if parsing the error itself fails
      return defaultMsg;
    }
    // --- END FIX ---
    return defaultMsg;
  }
}

