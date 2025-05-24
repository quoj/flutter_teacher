import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:t2305m_teacher/screen/cart/cart_screen.dart';
import 'package:t2305m_teacher/screen/home/home_screen.dart';
import 'package:t2305m_teacher/screen/profile/profile_screen.dart';
import 'package:t2305m_teacher/screen/search/search_screen.dart';
import 'package:t2305m_teacher/screen/home/ui/feature_products.dart'; // Import màn hình FeatureProductsScreen

class RootPage extends StatefulWidget {
  final bool isAdmin;
  const RootPage({super.key, this.isAdmin = false});

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final List<Widget> screens = [
    ProfileScreen(), // <-- biểu tượng teacher.jpg sẽ mở màn hình này
    SearchScreen(),
    HomeScreen(),
    // CartScreen(),
  ];

  int _selectedIndex = 0;

  void changeScreen(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void navigateToFeatureProducts() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FeatureProductsScreen()), // Điều hướng đến màn hình FeatureProductsScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: screens[_selectedIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 8,
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.black54,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          onTap: (index) {
            // Cập nhật index nút ba chấm là cuối cùng (index = 2)
            if (index == 2) {
              navigateToFeatureProducts();
            } else {
              changeScreen(index);
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: CircleAvatar(
                backgroundImage: AssetImage('assets/images/teacher.jpg'),
                radius: 15,
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FontAwesomeIcons.ellipsisH,
                  color: Colors.black,
                ),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
