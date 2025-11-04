import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tryon/models/api_responses.dart';
import 'package:tryon/models/cart.dart';
import 'package:tryon/models/item.dart';
import 'package:tryon/models/order.dart';
import 'package:tryon/models/user.dart';
 

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  // --- Auth Routes ---

  @POST("/auth/signup")
  Future<AuthResponse> signup(@Body() Map<String, dynamic> body);

  @POST("/auth/login")
  Future<AuthResponse> login(@Body() Map<String, dynamic> body);
  
  @POST("/auth/adminSignup")
  Future<AuthResponse> adminSignup(@Body() Map<String, dynamic> body);

  @GET("/auth/user/{userId}")
  Future<User> getUserById(@Path("userId") String userId);

  // --- Item Routes ---

  @POST("/item/bulk")
  Future<dynamic> bulkCreateItems(@Body() Map<String, dynamic> body);

  @GET("/item")
  Future<List<Item>> getAllItems();

  @GET("/item/{id}")
  Future<Item> getItemById(@Path("id") String itemId);

  @GET("/item/category/{cat}")
  Future<List<Item>> getItemsByCategory(@Path("cat") String category);

  @GET("/item/search")
  Future<List<Item>> searchItems(@Query("q") String query);

  @PUT("/item/{id}")
  Future<Item> updateItem(
    @Path("id") String itemId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE("/item/{id}")
  Future<dynamic> deleteItem(
    @Path("id") String itemId,
    @Body() Map<String, dynamic> body, // Body must contain { "userId": "..." }
  );

  // --- Cart Routes ---

  @POST("/cart/add")
  Future<CartResponse> addItemToCart(@Body() Map<String, dynamic> body);

  @POST("/cart/remove")
  Future<CartResponse> removeItemFromCart(@Body() Map<String, dynamic> body);

  @GET("/cart/{userId}")
  Future<Cart> getCart(@Path("userId") String userId);

  @PATCH("/cart/update")
  Future<CartResponse> updateCartItem(@Body() Map<String, dynamic> body);

  // --- Order Routes ---

  @POST("/order/checkout")
  Future<CheckoutResponse> checkout(@Body() Map<String, dynamic> body);

  @GET("/order/{userId}")
  Future<List<Order>> getUserOrders(@Path("userId") String userId);
}
