import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:tryon/core/api/api_service.dart';
import 'package:tryon/core/network/api_client.dart';
import 'package:tryon/core/utils/shared_pref_utils.dart';
import 'package:tryon/models/cart.dart';
import 'package:tryon/models/item.dart';
import 'package:tryon/models/order.dart';
import 'package:tryon/models/user.dart';
 

/// AppProvider
///
/// Manages all global application state, including authentication,
/// user data (cart, orders), and global data (item catalog).
class AppProvider with ChangeNotifier {
  final ApiService _apiService;

  // --- Private State Variables ---

  // Authentication
  bool _isLoggedIn = false;
  String? _userId;
  User? _currentUser; // Optional: store full user object
  bool _authLoading = false;
  String? _authError;

  // Item Catalog
  List<Item> _allItems = [];
  bool _itemsLoading = false;
  String? _itemsError;

  // User's Cart
  Cart? _cart;
  bool _cartLoading = false;
  String? _cartError;

  // User's Orders
  List<Order> _userOrders = [];
  bool _ordersLoading = false;
  String? _ordersError;

  // --- Public Getters ---

  // Auth
  bool get isLoggedIn => _isLoggedIn;
  String? get userId => _userId;
  User? get currentUser => _currentUser;
  bool get authLoading => _authLoading;
  String? get authError => _authError;

  // Items
  List<Item> get allItems => _allItems;
  bool get itemsLoading => _itemsLoading;
  String? get itemsError => _itemsError;

  // Cart
  Cart? get cart => _cart;
  bool get cartLoading => _cartLoading;
  String? get cartError => _cartError;
  int get cartItemCount =>
      _cart?.items.fold(0, (sum, item) => sum??0 + item.qty) ?? 0;

  // Orders
  List<Order> get userOrders => _userOrders;
  bool get ordersLoading => _ordersLoading;
  String? get ordersError => _ordersError;

  // --- Constructor ---

  /// Creates the AppProvider.
  ///
  /// Accesses the singleton ApiService from ApiClient
  /// and immediately tries to load the user session.
  AppProvider() : _apiService = ApiClient().apiService {
    _loadUserSession();
  }

  /// Checks SharedPreferences for a saved session and loads
  /// user data if one is found.
  void _loadUserSession() async {
    _isLoggedIn = SharedPrefUtils.isLoggedIn();
    _userId = SharedPrefUtils.getUserId();

    if (_isLoggedIn && _userId != null) {
      // User is logged in, fetch their essential data
      // We can run these in parallel
      await Future.wait([
        fetchCart(),
        fetchUserOrders(),
        // fetchCurrentUserDetails(), // Optional: if you add a /user/:id route
      ]);
    }
    
    // Always fetch the item catalog
    await fetchAllItems();

    // Notify listeners after all initial data is loaded
    notifyListeners();
  }

  // --- Internal Helper ---

  /// Parses a DioException to get a user-friendly error message
  String _parseError(DioException e, [String defaultMsg = "An error occurred"]) {
    if (e.response?.data != null && e.response!.data['msg'] != null) {
      return e.response!.data['msg'] as String;
    }
    return defaultMsg;
  }

  // --- Public Methods (Actions) ---

  // ========== AUTH ACTIONS ==========

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

      // Load user data after successful login
      await Future.wait([
        fetchCart(),
        fetchUserOrders(),
      ]);

      _authLoading = false;
      notifyListeners();
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

      // New user, cart will be empty but let's init it
      await fetchCart();
      _userOrders = []; // New user has no orders

      _authLoading = false;
      notifyListeners();
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

    // Clear all errors
    _authError = null;
    _cartError = null;
    _ordersError = null;

    await SharedPrefUtils.clearUserSession();
    notifyListeners();
  }

   Future<void> fetchUserData() async {
    if (_userId == null) {
      _authError = "User ID not found.";
      return;
    }

    // This data is part of the auth flow, so use auth loading/error states
    // We don't notify listeners here to avoid redundant loading spinners
    // as this is usually called within another loading method.
    
    try {
      _currentUser = await _apiService.getUserById(_userId!);
      notifyListeners(); // Notify after data is fetched
    } on DioException catch (e) {
      _authError = _parseError(e, "Failed to load user data.");
      notifyListeners();
    } catch (e) {
      _authError = "An unexpected error occurred loading user data.";
      notifyListeners();
    }
  }

  // ========== ITEM ACTIONS ==========

  /// Fetches all items from the store.
  Future<void> fetchAllItems() async {
    _itemsLoading = true;
    _itemsError = null;
    // Don't notify yet, may be part of initial load

    try {
      _allItems = await _apiService.getAllItems();
    } on DioException catch (e) {
      _itemsError = _parseError(e, "Failed to load items");
    } catch (e) {
      _itemsError = "An unexpected error occurred.";
    } finally {
      _itemsLoading = false;
      notifyListeners();
    }
  }

  // ========== CART ACTIONS ==========

  /// Fetches the user's current cart.
  Future<void> fetchCart() async {
    if (_userId == null) return; // Not logged in

    _cartLoading = true;
    _cartError = null;
    notifyListeners();

    try {
      _cart = (await _apiService.getCart(_userId!)) as Cart?;
    } on DioException catch (e) {
      _cartError = _parseError(e, "Failed to load cart");
    } catch (e) {
      _cartError = "An unexpected error occurred.";
    } finally {
      _cartLoading = false;
      notifyListeners();
    }
  }

  /// Adds an item to the cart.
  Future<void> addItemToCart(String itemId) async {
    if (_userId == null) return;

    _cartLoading = true;
    _cartError = null;
    notifyListeners();

    try {
      final body = {"userId": _userId!, "itemId": itemId};
      final response = await _apiService.addItemToCart(body);
      _cart = response.cart; // API returns the updated cart
    } on DioException catch (e) {
      _cartError = _parseError(e, "Failed to add item");
    } catch (e) {
      _cartError = "An unexpected error occurred.";
    } finally {
      _cartLoading = false;
      notifyListeners();
    }
  }

  /// Removes an item from the cart.
  Future<void> removeItemFromCart(String itemId) async {
    if (_userId == null) return;

    _cartLoading = true;
    _cartError = null;
    notifyListeners();

    try {
      final body = {"userId": _userId!, "itemId": itemId};
      final response = await _apiService.removeItemFromCart(body);
      _cart = response.cart; // API returns the updated cart
    } on DioException catch (e) {
      _cartError = _parseError(e, "Failed to remove item");
    } catch (e) {
      _cartError = "An unexpected error occurred.";
    } finally {
      _cartLoading = false;
      notifyListeners();
    }
  }

  /// Updates an item's quantity in the cart.
  Future<void> updateCartItemQty(String itemId, int newQty) async {
    if (_userId == null) return;

    _cartLoading = true;
    _cartError = null;
    notifyListeners();

    try {
      final body = {
        "userId": _userId!,
        "itemId": itemId,
        "updates": {"qty": newQty}
      };
      final response = await _apiService.updateCartItem(body);
      _cart = response.cart; // API returns the updated cart
    } on DioException catch (e) {
      _cartError = _parseError(e, "Failed to update item");
    } catch (e) {
      _cartError = "An unexpected error occurred.";
    } finally {
      _cartLoading = false;
      notifyListeners();
    }
  }

  // ========== ORDER ACTIONS ==========

  /// Fetches the user's order history.
  Future<void> fetchUserOrders() async {
    if (_userId == null) return;

    _ordersLoading = true;
    _ordersError = null;
    notifyListeners();

    try {
      _userOrders = await _apiService.getUserOrders(_userId!);
    } on DioException catch (e) {
      _ordersError = _parseError(e, "Failed to load orders");
    } catch (e) {
      _ordersError = "An unexpected error occurred.";
    } finally {
      _ordersLoading = false;
      notifyListeners();
    }
  }

  /// Checks out the current cart and creates an order.
  /// Returns `true` on success, `false` on failure.
  Future<bool> checkout(String address) async {
    if (_userId == null) return false;

    _cartLoading = true; // Use cart loading as it's a cart action
    _cartError = null;
    notifyListeners();

    try {
      final body = {"userId": _userId!, "address": address};
      await _apiService.checkout(body);

      // Success! Clear the local cart and refresh the order list
      _cart = null; // Or re-fetch the now-empty cart
      await fetchCart(); // Fetches the empty cart
      await fetchUserOrders(); // Adds the new order to the list

      _cartLoading = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      _cartError = _parseError(e, "Checkout failed");
      _cartLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _cartError = "An unexpected error occurred.";
      _cartLoading = false;
      notifyListeners();
      return false;
    }
  }
}
