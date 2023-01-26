import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/screens/account/account_page.dart';
import 'package:food_delivery_app_development/screens/auth/sign_up_page.dart';
import 'package:food_delivery_app_development/screens/cart/cart_page.dart';
import 'package:food_delivery_app_development/screens/home/history_page.dart';
import 'package:food_delivery_app_development/screens/home/main_food_page.dart';
import 'package:food_delivery_app_development/shared/utils/colors.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  int currentIndex = 0;
  List<Widget> pages = [
    MainFoodPage(),
    Center(child: Text('ali')),
    CartHistoryPage(),
    // CartPage(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: Dimensions.iconSize24,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: AppColors.mainColor,
        unselectedItemColor: Colors.amberAccent,
        currentIndex: currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items:  [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined), label: 'history'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart,), label: 'cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
        ],
      ),
    );
  }

}
