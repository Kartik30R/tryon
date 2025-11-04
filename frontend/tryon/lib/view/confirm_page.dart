import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tryon/controller/app_provider.dart';
import 'package:tryon/view/bottom_navigation.dart';
 
class ConfirmPage extends StatefulWidget {
  const ConfirmPage({super.key});

  @override
  State<ConfirmPage> createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  final _addressController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
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

  Future<void> _handleConfirmOrder() async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a delivery address")),
      );
      return;
    }

    setState(() => _isLoading = true);
    final appProvider = context.read<AppProvider>();
    final success = await appProvider.checkout(_addressController.text);
    
    if (mounted) {
      setState(() => _isLoading = false);
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order placed successfully!")),
      );
      // Navigate to the Orders page (index 1) and clear the navigation stack
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const BottomNavigation()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(appProvider.cartError ?? "Checkout failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    // Calculate total from provider
    double subtotal = 0;
    if (appProvider.cart != null) {
      subtotal = appProvider.cart!.items.fold(
          0.0, (sum, item) => sum + (item.item.price * item.qty));
    }
    const double deliveryFee = 10.0; // Assuming same fee as cart
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
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Delivery Address',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: 'Enter your full delivery address',
                        labelStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Order Summary',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    // Show a summary of items
                    Container(
                      height: 200, // Limit height
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: (appProvider.cart?.items.isEmpty ?? true)
                      ? const Center(child: Text("No items in cart"))
                      : ListView.builder(
                        shrinkWrap: true,
                        itemCount: appProvider.cart!.items.length,
                        itemBuilder: (context, index) {
                          final item = appProvider.cart!.items[index];
                          return ListTile(
                            leading: Image.network(
                              item.item.imagesUrl.isNotEmpty ? item.item.imagesUrl[0] : 'https://placehold.co/50x50',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(item.item.name),
                            subtitle: Text('Qty: ${item.qty}'),
                            trailing: Text('\$${(item.item.price * item.qty).toStringAsFixed(2)}'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Bottom total and confirm button
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Row(
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
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Row(
                  children: <Widget>[
                    Icon(Icons.check_box_rounded),
                    SizedBox(width: 15),
                    Text(
                      'Call me for clarification',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
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
                            ? const CircularProgressIndicator(color: Colors.white)
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
        ],
      ),
    );
  }
}
