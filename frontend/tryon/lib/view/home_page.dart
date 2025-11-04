import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tryon/controller/app_provider.dart';
import 'package:tryon/models/enums.dart';
import 'package:tryon/view/categories.dart';
import 'package:tryon/view/category_itemlist.dart';
import 'package:tryon/view/widget/item_card_widget.dart';
 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch AppProvider for changes to item list
    final appProvider = context.watch<AppProvider>();

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xffF3F3F3),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 50), // For status bar
            // Search Bar
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: TextField(
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            suffixIcon: const Icon(Icons.search,
                                color: Colors.black, size: 30),
                            hintText: 'Search',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.black))),
                      ),
                    ),
                  ),
                  const Icon(Icons.filter_alt_rounded)
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Categories (NOW WIRED UP with new enums)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _CategoryIcon(
                  icon: Icons.category_rounded,
                  label: 'All',
                  onTap: () => Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const CategoryPage(),
                    ),
                  ),
                ),
                _CategoryIcon(
                  asset: 'assets/dress.png',
                  label: 'Clothing',
                  onTap: () => Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const CategoryItemListPage(
                        title: 'Clothing',
                        categories: [
                          ItemCategory.cloths // Updated
                        ],
                      ),
                    ),
                  ),
                ),
                _CategoryIcon(
                  asset: 'assets/sunglasses.png',
                  label: 'Accessories',
                  onTap: () => Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const CategoryItemListPage(
                        title: 'Accessories',
                        categories: [
                          ItemCategory.accessories, // Updated
                          ItemCategory.watch
                        ],
                      ),
                    ),
                  ),
                ),
                _CategoryIcon(
                  asset: 'assets/handbag.png',
                  label: 'Bags',
                  onTap: () => Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const CategoryItemListPage(
                        title: 'Bags',
                        // Mapped "Bags" to the accessories category
                        categories: [ItemCategory.accessories],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Promo Banner (static as per your UI)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Row(
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 35),
                      width: 20,
                      child: const Icon(Icons.discount_outlined, size: 30)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('50% OFF',
                            style: GoogleFonts.poppins(
                                letterSpacing: 4,
                                fontSize: 25,
                                fontWeight: FontWeight.w700)),
                        const Text('on all women\'s shoes',
                            style: TextStyle(wordSpacing: 1))
                      ],
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      width: 20,
                      child: const Icon(Icons.keyboard_arrow_right, size: 30))
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'New Items',
                style: GoogleFonts.poppins(
                    fontSize: 25, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 20),

            // --- Dynamic Item List ---
            _buildItemList(appProvider),

            const SizedBox(height: 80)
          ],
        ),
      ),
    );
  }

  Widget _buildItemList(AppProvider appProvider) {
    if (appProvider.itemsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (appProvider.itemsError != null) {
      return Center(
          child: Text("Failed to load items: ${appProvider.itemsError}"));
    }

    if (appProvider.allItems.isEmpty) {
      return const Center(child: Text("No items found."));
    }

    // Use GridView for a better layout
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: (1 / 1.6), // Adjust aspect ratio as needed
      ),
      itemCount: appProvider.allItems.length,
      itemBuilder: (context, index) {
        final item = appProvider.allItems[index];
        return ItemCard(item: item); // Use the new reusable widget
      },
    );
  }
}

// Helper Widget for Category Icons
class _CategoryIcon extends StatelessWidget {
  final IconData? icon;
  final String? asset;
  final String label;
  final VoidCallback onTap;

  const _CategoryIcon({
    required this.label,
    required this.onTap,
    this.icon,
    this.asset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: asset != null
                ? Image.asset(asset!, height: 35)
                : Icon(icon, size: 30, color: Colors.black),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.poppins())
      ],
    );
  }
}

