import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tryon/view/category_itemlist.dart';
import '../models/enums.dart';
 
class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF3F3F3),
        title: Text(
          'Categories',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.w300),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context), // Go back
          child: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: <Widget>[
              // --- Toggles (Static UI) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 55,
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black)),
                    child: Center(
                      child: Text(
                        'Woman',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    width: 150,
                    child: Center(
                      child: Text(
                        'Man',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // --- Category List (Dynamic Navigation) ---
              _CategoryTile(
                asset: 'assets/dress.png',
                title: 'Clothing',
                onTap: () => Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: const CategoryItemListPage(
                      title: 'Clothing',
                      categories: [ItemCategory.cloths],
                    ),
                  ),
                ),
              ),
              _CategoryTile(
                asset: 'assets/sneakers.png',
                title: 'Shoes',
                onTap: () => Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: const CategoryItemListPage(
                      title: 'Shoes',
                      categories: [ItemCategory.shoes],
                    ),
                  ),
                ),
              ),
              _CategoryTile(
                asset: 'assets/sunglasses.png',
                title: 'Accessories',
                onTap: () => Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: const CategoryItemListPage(
                      title: 'Accessories',
                      categories: [ItemCategory.accessories],
                    ),
                  ),
                ),
              ),
              _CategoryTile(
                icon: Icons.watch, // Used an icon
                title: 'Watches',
                onTap: () => Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: const CategoryItemListPage(
                      title: 'Watches',
                      categories: [ItemCategory.watch],
                    ),
                  ),
                ),
              ),
              _CategoryTile(
                asset: 'assets/handbag.png',
                title: 'Handbags',
                onTap: () => Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: const CategoryItemListPage(
                      title: 'Handbags',
                      // Mapped to accessories
                      categories: [ItemCategory.accessories],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper Widget for Category Tiles
class _CategoryTile extends StatelessWidget {
  final String? asset;
  final IconData? icon;
  final String title;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.title,
    required this.onTap,
    this.asset,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 35),
                width: 25,
                child: asset != null
                    ? Image.asset(asset!, height: 35)
                    : Icon(icon, size: 30, color: Colors.black),
              ),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                      letterSpacing: 1,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                width: 20,
                child: const Icon(
                  Icons.keyboard_arrow_right,
                  size: 30,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
