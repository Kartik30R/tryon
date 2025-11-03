import 'package:flutter/material.dart';
import 'package:tryon/view/cart.dart';
import 'package:tryon/view/home_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

 final List<Widget> _pages = [
    HomePage(),
    Center(child: Text('Favorites Page')),
    Cart(),
    Center(child: Text('Profile Page')),
  ];

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
                    label: 'Favorite',
                    icon: Icon(Icons.favorite),
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
                selectedItemColor: Color(0xffFEDA7A),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
