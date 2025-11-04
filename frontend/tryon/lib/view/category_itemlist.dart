import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tryon/controller/app_provider.dart';
import 'package:tryon/models/item.dart';
import 'package:tryon/view/widget/item_card_widget.dart';
import '../models/enums.dart';
 

class CategoryItemListPage extends StatelessWidget {
  final String title;
  final List<ItemCategory> categories;

  const CategoryItemListPage({
    super.key,
    required this.title,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    
    // Filter the items based on the categories passed to this widget
    final List<Item> filteredItems = appProvider.allItems
        .where((item) => categories.contains(item.category))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF3F3F3),
        title: Text(
          title, // Use the dynamic title
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.w300),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context), // Go back
          child: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_alt, color: Colors.black),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Text(
              '${filteredItems.length} items', // Show dynamic item count
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _buildItemList(appProvider, filteredItems),
          ),
        ],
      ),
    );
  }

  Widget _buildItemList(AppProvider appProvider, List<Item> filteredItems) {
    if (appProvider.itemsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (appProvider.itemsError != null) {
      return Center(
          child: Text("Failed to load items: ${appProvider.itemsError}"));
    }

    if (filteredItems.isEmpty) {
      return const Center(child: Text("No items found in this category."));
    }

    // Use GridView to display the items
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: (1 / 1.6), // Same as home page
      ),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return ItemCard(item: item); // Use the reusable widget
      },
    );
  }
}
