import 'package:tryon/view/cart.dart';
import 'package:tryon/view/categories.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tryon/view/item_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      extendBody: true,
      backgroundColor: Color(0xffF3F3F3),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Flexible(
                        child: Container(
                      margin: EdgeInsets.only(right: 10),
                      child: TextField(
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            suffixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 30,
                            ),
                            hintText: 'Search',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black))),
                      ),
                    )),
                    Icon(Icons.filter_alt_rounded)
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: Category())),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.category_rounded,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'All',
                        style: GoogleFonts.poppins(),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          'assets/dress.png',
                          height: 35,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text('Clothing')
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          'assets/sunglasses.png',
                          height: 35,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text('Accessories')
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Image.asset('assets/handbag.png', height: 35),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text('Bags')
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 35),
                      width: 20,
                      child: Icon(
                        Icons.discount_outlined,
                        size: 30,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('50% OFF',
                              style: GoogleFonts.poppins(
                                  letterSpacing: 4,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700)),
                          Text('on all women\'s shoes',
                              style: TextStyle(wordSpacing: 1))
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        width: 20,
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          size: 30,
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'New Items',
                  style: GoogleFonts.poppins(
                      fontSize: 25, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap:()=>Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: ItemData())),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        height: 260,
                        // color: Colors.black,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    'assets/whiteshirt.jpg',
                                    fit: BoxFit.cover,
                                    height: 210,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    margin: EdgeInsets.all(6),
                                    child: CircleAvatar(
                                        foregroundColor: Colors.black,
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.favorite)),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'White shirt',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '\$72',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900, fontSize: 15),
                                ),
                                Icon(
                                  Icons.add,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 260,
                      // color: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/pantsuit.webp',
                                  fit: BoxFit.cover,
                                  height: 210,
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  margin: EdgeInsets.all(6),
                                  child: CircleAvatar(
                                      foregroundColor: Colors.black,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.favorite_border)),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Pant suit',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '\$52',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 15),
                              ),
                              Icon(
                                Icons.add,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 260,
                      // color: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/pantsuit.webp',
                                  fit: BoxFit.cover,
                                  height: 210,
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  margin: EdgeInsets.all(6),
                                  child: CircleAvatar(
                                      foregroundColor: Colors.black,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.favorite_border)),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Pant suit',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '\$52',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 15),
                              ),
                              Icon(
                                Icons.add,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 260,
                      // color: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/whiteshirt.jpg',
                                  fit: BoxFit.cover,
                                  height: 210,
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  margin: EdgeInsets.all(6),
                                  child: CircleAvatar(
                                      foregroundColor: Colors.black,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.favorite)),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'White shirt',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '\$72',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 15),
                              ),
                              Icon(
                                Icons.add,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 80,
              )
            ]),
      ),
    );
  }
}