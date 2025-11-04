import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tryon/controller/app_provider.dart'; 
import 'package:tryon/view/cart.dart';
import 'package:tryon/view/home_page.dart';
import 'package:tryon/view/orders_page.dart';
import 'package:tryon/view/profile_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  // Store the pages in a list
  final List<Widget> _pages = [
    const HomePage(),
    const OrdersPage(),
    const CartPage(),  
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
       
    if (index == 2) {
      context.read<AppProvider>().fetchCart();
    }
    if (index == 3) {
      context.read<AppProvider>().fetchUserData();
    }
    // -------------------------

    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
      context.read<AppProvider>().fetchAllItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      // Use IndexedStack to preserve state of each tab
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: const Color(0xff23272C),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 60,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                items: const [
                  BottomNavigationBarItem(
                    label: 'Home',
                    icon: Icon(Icons.home),
                  ),
                  BottomNavigationBarItem(
                    label: 'Orders', // Changed from 'Favorite'
                    icon: Icon(Icons.receipt_long), // Changed icon
                  ),
                  BottomNavigationBarItem(
                    label: 'Cart',
                    icon: Icon(Icons.shopping_cart),
                  ),
                  BottomNavigationBarItem(
                    label: 'Profile',
                    icon: Icon(Icons.person),
                  ),
                ],
                unselectedItemColor: Colors.grey,
                selectedItemColor: const Color(0xffFEDA7A),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


 
