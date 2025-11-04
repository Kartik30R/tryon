import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tryon/controller/app_provider.dart';
import 'package:tryon/models/cart.dart';
 import 'confirm_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the provider for changes to the cart
    final appProvider = context.watch<AppProvider>();

    // Calculate totals
    double subtotal = 0;
    if (appProvider.cart != null) {
      subtotal = appProvider.cart!.items.fold(
          0.0, (sum, item) => sum + (item.item.price * item.qty));
    }
    const double deliveryFee = 10.0;
    final double total = subtotal + deliveryFee;

    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Basket',
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        // No back button needed, it's in the bottom nav
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          Expanded(
            // This container will show the list of cart items
            child: Consumer<AppProvider>(
              builder: (context, provider, child) {
                if (provider.cartLoading && provider.cart == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.cart == null || provider.cart!.items.isEmpty) {
                  return const Center(
                    child: Text(
                      'Your cart is empty',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                // We have a cart with items, show the list
                return ListView.builder(
                  itemCount: provider.cart!.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = provider.cart!.items[index];
                    return CartItemTile(cartItem: cartItem);
                  },
                );
              },
            ),
          ),
          
          // Bottom Order Info section
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            height: 322,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Center(
                      child: Text(
                        'Order Info',
                        style: GoogleFonts.poppins(
                            fontSize: 25, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Order Summary
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: <Widget>[
                        _OrderInfoRow(
                          label: 'Subtotal',
                          value: '\$${subtotal.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 10),
                        _OrderInfoRow(
                          label: 'Delivery',
                          value: '\$${deliveryFee.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 10),
                        _OrderInfoRow(
                          label: 'Total',
                          value: '\$${total.toStringAsFixed(2)}',
                          isTotal: true,
                        ),
                        const SizedBox(height: 40),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: SizedBox(
                              height: 55,
                              width: 200,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black),
                                onPressed: (appProvider.cart?.items.isEmpty ?? true)
                                ? null // Disable if cart is empty
                                : () => Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: const ConfirmPage(),
                                  ),
                                ),
                                child: Text(
                                  'Place an Order',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper widget for displaying a single cart item
class CartItemTile extends StatelessWidget {
  final CartItem cartItem;
  const CartItemTile({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: <Widget>[
          // You had this checkbox, I'm keeping it but it's not functional
          const Icon(Icons.check_box_rounded),
          const SizedBox(width: 15),
          
          // --- IMAGE REMOVED AS REQUESTED ---
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(15),
          //   child: Image.network(
          //     cartItem.item.imagesUrl.isNotEmpty
          //         ? cartItem.item.imagesUrl[0]
          //         : 'https://placehold.co/70x70/eee/ccc?text=No+Image',
          //     height: 70,
          //     width: 70,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // const SizedBox(width: 15),
          // ----------------------------------

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  cartItem.item.name,
                  style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  '(Size: ${cartItem.item.size.name.characters.first})', // Show item size
                  style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  '\$${cartItem.item.price.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 16),
                )
              ],
            ),
          ),
          // Quantity controls
          Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.grey, size: 18),
                onPressed: () {
                  provider.updateCartItemQty(
                      cartItem.item.id, cartItem.qty - 1);
                },
              ),
              Text(
                ' ${cartItem.qty} ', // Pad with spaces
                style: GoogleFonts.poppins(fontSize: 18),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.grey, size: 18),
                onPressed: () {
                  provider.updateCartItemQty(
                      cartItem.item.id, cartItem.qty + 1);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Helper widget for order info rows
class _OrderInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _OrderInfoRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: isTotal ? 23 : 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

