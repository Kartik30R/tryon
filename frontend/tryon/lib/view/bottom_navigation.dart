import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tryon/controller/app_provider.dart';
import 'package:tryon/view/cart.dart';
import 'package:tryon/view/home_page.dart';
import 'package:tryon/view/orders_page.dart';
 

class BottomNavigation extends StatefulWidget {
  final int initialIndex;
  const BottomNavigation({super.key, this.initialIndex = 0});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late int _selectedIndex;

  // Updated pages
  final List<Widget> _pages = [
    const HomePage(),
    const OrdersPage(), 
    const CartPage(),
    const ProfilePage(),  
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      body: _pages[_selectedIndex],
      bottomNavigationBar: SafeArea(
        child: Theme(
          data: Theme.of(context).copyWith(canvasColor: const Color(0xff23272C)),
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
                    label: 'Orders', // Updated
                    icon: Icon(Icons.receipt_long), // Updated
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

// A simple profile page with a logout button
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      appBar: AppBar(
        title: Text("Profile", style: GoogleFonts.poppins(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          onPressed: () {
            context.read<AppProvider>().logout();
           },
          child: const Text("Logout"),
        ),
      ),
    );
  }
}
