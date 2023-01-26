import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/controllers/cart_controller.dart';
import 'package:food_delivery_app_development/controllers/popular_prodcut_controller.dart';
import 'package:food_delivery_app_development/controllers/recommended_product_controller.dart';
import 'package:food_delivery_app_development/routes/route_helper.dart';
import 'package:food_delivery_app_development/screens/home/home_page.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
//we can load dependencies from here
  Future<void> _loadResourses() async {
   await Get.find<PopularProductController>().getPopularProductList();
    await Get.find<RecommendedProductController>().getRecommendedProductList();
  }

  @override
  void initState() {

    super.initState();
    _loadResourses();
    controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 850))
          ..forward(); //make instance first and forward it
    animation = CurvedAnimation(curve: Curves.easeInToLinear, parent: controller);
    //after animation go to a next page directly
    Timer(
       const Duration(milliseconds: 2500), () => Get.to(()=>HomePage()));
  }
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ScaleTransition(
              scale: animation,
              child: Center(
                  child: Image.asset(
                'assets/images/food logo part 1.jpg',
                width: Dimensions.spalshImg,
              ))),
          Center(
              child: Image.asset(
            'assets/images/food logo part 2.png',
            width: Dimensions.spalshImg,
          ))
        ],
      ),
    );
  }
}
