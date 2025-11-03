import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expandable/expandable.dart';
import 'package:page_transition/page_transition.dart';
import 'package:camerakit_flutter/camerakit_flutter.dart';
import 'package:camerakit_flutter/lens_model.dart';
import 'package:tryon/view/tryon_page.dart';

import 'category_itemlist.dart';

class ItemData extends StatefulWidget {
  const ItemData({super.key});

  @override
  State<ItemData> createState() => _ItemDataState();
}

class _ItemDataState extends State<ItemData> implements CameraKitFlutterEvents {
  late final CameraKitFlutterImpl _cameraKitFlutterImpl;

  // 🔹 Replace these with your actual IDs from Lens Studio / Snap Kit
  static const String groupId = "5b29451d-1ba0-403c-92cd-614b5eb54be9";
  static const String lensId = "a4b12f9c-xxxx-xxxx-xxxx-xxxxxxxxxxxx";

  @override
  void initState() {
    super.initState();
    _cameraKitFlutterImpl = CameraKitFlutterImpl(cameraKitFlutterEvents: this);
  }

  // 🔸 Open CameraKit directly from within the ItemData page
  void _openCameraKit() {
    _cameraKitFlutterImpl.openCameraKitWithSingleLens(
      groupId: groupId,
      lensId: lensId,
      isHideCloseButton: false,
    );
  }

  @override
  void onCameraKitResult(Map<dynamic, dynamic> result) {
    final filePath = result["path"] as String?;
    final fileType = result["type"] as String?;
    debugPrint("Captured: $filePath ($fileType)");
  }

  @override
  void receivedLenses(List<Lens> lensList) {
    debugPrint("Received ${lensList.length} lenses");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.leftToRightWithFade,
              child: const CategoryItemList(),
            ),
          ),
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
                child: Image.asset(
                  'assets/pantsuit.webp',
                  fit: BoxFit.cover,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title + price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'White pantsuit',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '\$580.00',
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
                                      'Stylish touch coat, classic, pleasant to the touch from natural materials. Perfect for semi-formal occasions and daily wear, designed to enhance your elegance.',
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
                            (sizeLabel) => Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: const Color(0xffF5F5F5),
                                child: Text(
                                  sizeLabel,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
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
                      onPressed: ()=>Navigator.push(context, PageTransition(type: PageTransitionType.fade,child: TryOnPage()))
                      //  _openCameraKit
                       , // 👈 integrated lens open
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
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added to basket")),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: Text(
                        'Add to Basket',
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
