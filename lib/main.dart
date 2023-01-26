import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/controllers/cart_controller.dart';
import 'package:food_delivery_app_development/controllers/popular_prodcut_controller.dart';
import 'package:food_delivery_app_development/controllers/recommended_product_controller.dart';
import 'package:food_delivery_app_development/routes/route_helper.dart';
import 'package:food_delivery_app_development/screens/address/add_address_page.dart';
import 'package:food_delivery_app_development/screens/auth/sign_in_page.dart';
import 'package:food_delivery_app_development/screens/auth/sign_up_page.dart';
import 'package:food_delivery_app_development/screens/cart/cart_page.dart';
import 'package:food_delivery_app_development/screens/food/popular_food_detail.dart';
import 'package:food_delivery_app_development/screens/food/recommended_food_details.dart';
import 'package:food_delivery_app_development/screens/home/home_page.dart';
import 'package:food_delivery_app_development/screens/home/main_food_page.dart';
import 'package:food_delivery_app_development/screens/home/food_body_page.dart';
import 'package:food_delivery_app_development/screens/spalsh/splash_screen.dart';
import 'package:food_delivery_app_development/shared/utils/colors.dart';
import 'package:get/get.dart';
import 'package:food_delivery_app_development/helper/dependencies.dart' as dep;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //must initiate the connection here
  await dep.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //to load persistent data in cart history
    Get.find<CartController>().getCartData();
    return GetBuilder<PopularProductController>(
      builder: (_) => GetBuilder<RecommendedProductController>(
        builder: (_) => GetMaterialApp(
          theme: ThemeData(
            primaryColor: AppColors.mainColor,
            fontFamily: 'Lato',
          ),
          debugShowCheckedModeBanner: false,
          // home: SplashScreen(),
          initialRoute: RouteHelper.getSplashPage(),
          getPages: RouteHelper.getRoutes(),
        ),
      ),
    );
  }
}
