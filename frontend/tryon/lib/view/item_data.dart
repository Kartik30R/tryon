import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expandable/expandable.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tryon/controller/app_provider.dart';
import 'package:tryon/models/item.dart';
 
import '../models/enums.dart';  
import 'tryon_page.dart';

class ItemDataPage extends StatefulWidget {
  final Item item;
  const ItemDataPage({super.key, required this.item});

  @override
  State<ItemDataPage> createState() => _ItemDataPageState();
}

class _ItemDataPageState extends State<ItemDataPage> {
  // Store the selected size
  String _selectedSize = "M"; // Default to M
  
  // --- ADDED FOR ASYNC BUTTON ---
  bool _isAddingToCart = false;
  // -----------------------------

  @override
  void initState() {
    super.initState();
    // Set default selected size from the item's size
    // Use the first character of the enum name (e.g., SMALL -> S)
    _selectedSize = widget.item.size.name.characters.first;
  }

  // --- UPDATED FOR void RETURN TYPE ---
  Future<void> _handleAddToCart() async {
    setState(() => _isAddingToCart = true);
    
    final appProvider = context.read<AppProvider>();
    // Call the void function, it will set state in the provider
    await appProvider.addItemToCart(widget.item.id);

    if (mounted) {
      // Check the provider's error state *after* the call
      if (appProvider.cartError == null) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Added ${widget.item.name} to basket"),
            backgroundColor: Colors.green,
          ),
        );
      }
      setState(() => _isAddingToCart = false);
    }
  }
  // ---------------------------------

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context), // Go back
          child: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // 🔹 Image section
              SizedBox(
                width: double.infinity,
                height: size.height * 0.45,
                child: Image.network(
                  widget.item.imagesUrl.isNotEmpty
                      ? widget.item.imagesUrl[0]
                      : 'https://placehold.co/600x600/eee/ccc?text=No+Image',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),

              // 🔹 Product details
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title + price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.item.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '\$${widget.item.price.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // 🔹 Expandable description
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: ExpandableNotifier(
                              child: Expandable(
                                collapsed: ExpandableButton(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Description',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Icon(Icons.keyboard_arrow_down),
                                    ],
                                  ),
                                ),
                                expanded: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Description',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        ExpandableButton(
                                          child:
                                              const Icon(Icons.keyboard_arrow_up),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      widget.item.description ??
                                          'No description available.',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Spacer to keep details from being covered by bottom bar
              const SizedBox(height: 200),
            ],
          ),

          // 🔹 Bottom control bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🔸 Size selector
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: ['S', 'M', 'L']
                          .map(
                            (sizeLabel) => GestureDetector(
                              onTap: () => setState(() => _selectedSize = sizeLabel),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: _selectedSize == sizeLabel
                                      ? Colors.black
                                      : const Color(0xffF5F5F5),
                                  child: Text(
                                    sizeLabel,
                                    style: GoogleFonts.poppins(
                                      color: _selectedSize == sizeLabel
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 🔸 Try On button
                  SizedBox(
                    height: 55,
                    width: size.width * 0.85,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        // Check if item supports WANNA AR
                        if (widget.item.ar == ArType.WANNA &&
                            widget.item.wannaUrl != null &&
                            widget.item.wannaUrl!.isNotEmpty) {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: TryOnPage(wannaUrl: widget.item.wannaUrl!),
                            ),
                          );
                        } else {
                          // Handle other AR types or no AR
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "Try-On not available for this item (Type: ${widget.item.ar.name})")),
                          );
                        }
                      },
                      icon: const Icon(Icons.accessibility_new),
                      label: Text(
                        'Try On',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 🔸 Add to Basket
                  SizedBox(
                    height: 55,
                    width: size.width * 0.85,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      // --- UPDATED OnPressed ---
                      onPressed: _isAddingToCart ? null : _handleAddToCart,
                      icon: _isAddingToCart
                          ? Container(
                              width: 24,
                              height: 24,
                              padding: const EdgeInsets.all(2.0),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Icon(Icons.add_shopping_cart),
                      label: Text(
                        _isAddingToCart ? 'Adding...' : 'Add to Basket',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

