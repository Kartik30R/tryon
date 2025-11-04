import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tryon/controller/app_provider.dart';
import 'package:tryon/view/bottom_navigation.dart';


// Convert to StatefulWidget to handle form and loading state
class ConfirmPage extends StatefulWidget {
  const ConfirmPage({super.key});

  @override
  State<ConfirmPage> createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill the address from the user's profile
    final user = context.read<AppProvider>().currentUser;
    if (user != null) {
      _addressController.text = user.address;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  // Use the logic you provided
  Future<void> _handleConfirmOrder() async {
    // Validate the form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    final appProvider = context.read<AppProvider>();
    // Call checkout with the address from the text controller
    final success = await appProvider.checkout(_addressController.text);

    if (mounted) {
      setState(() => _isLoading = false);
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Order placed successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate to the main app, landing on the Orders page (index 1)
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const BottomNavigation()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(appProvider.cartError ?? "Checkout failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get user data from provider
    final appProvider = context.watch<AppProvider>();
    final user = appProvider.currentUser;

    // Calculate total from cart
    double subtotal = 0;
    if (appProvider.cart != null) {
      subtotal = appProvider.cart!.items.fold(
          0.0,
          (sum, cartItem) => cartItem.item == null
              ? sum
              : sum + (cartItem.item!.price * cartItem.qty));
    }
    const double deliveryFee = 10.0;
    final double total = subtotal + deliveryFee;

    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Place an order',
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context), // Go back to cart
          child: const Icon(
            Icons.keyboard_arrow_left,
            color: Colors.black,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 250), // Avoid overlap
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // --- User Info ---
                    _InfoTile(
                      title: 'Name',
                      subtitle: user?.name ?? 'Loading...',
                    ),
                    const SizedBox(height: 10),
                    _InfoTile(
                      title: 'Phone Number',
                      subtitle: user?.phone ?? 'Loading...',
                    ),
                    const SizedBox(height: 10),
                    // --- Address Text Field ---
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Text(
                        'Delivery address',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: TextFormField(
                        controller: _addressController,
                        style: GoogleFonts.poppins(
                            color: Colors.grey[700], fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Enter your delivery address',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a delivery address';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- Bottom Confirmation Bar ---
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              height: 222,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Total price',
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 23,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.check_box_outline_blank_rounded),
                          Container(
                            margin: const EdgeInsets.only(right: 15),
                          ),
                          Text(
                            'Call me for clarification',
                            style: GoogleFonts.poppins(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SizedBox(
                          height: 60,
                          width: 160,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black),
                            onPressed: _isLoading ? null : _handleConfirmOrder,
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text(
                                    'Confirm',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widget for static info
class _InfoTile extends StatelessWidget {
  final String title;
  final String subtitle;
  const _InfoTile({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Text(
            title,
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Text(
            subtitle,
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
          ),
        )
      ],
    );
  }
}

