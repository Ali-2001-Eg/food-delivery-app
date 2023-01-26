//init method which is required to connection between client and server
import 'package:food_delivery_app_development/controllers/auth_controller.dart';
import 'package:food_delivery_app_development/controllers/cart_controller.dart';
import 'package:food_delivery_app_development/controllers/location_controller.dart';
import 'package:food_delivery_app_development/controllers/popular_prodcut_controller.dart';
import 'package:food_delivery_app_development/controllers/recommended_product_controller.dart';
import 'package:food_delivery_app_development/controllers/user_controller.dart';
import 'package:food_delivery_app_development/data/api/api_client.dart';
import 'package:food_delivery_app_development/data/repository/auth_repo.dart';
import 'package:food_delivery_app_development/data/repository/cart_repo.dart';
import 'package:food_delivery_app_development/data/repository/location_repo.dart';
import 'package:food_delivery_app_development/data/repository/popualr_product_repo.dart';
import 'package:food_delivery_app_development/data/repository/recommended_product_repo.dart';
import 'package:food_delivery_app_development/data/repository/user_repo.dart';
import 'package:food_delivery_app_development/shared/utils/constants.dart';
import 'package:get/get.dart';
import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  //load shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();
 Get.lazyPut(() => sharedPreferences);//to load it in the app and controllers
  //load the api client
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.BASE_URL,sharedPreferences:Get.find()));
  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: sharedPreferences));
  //load the repositories
  Get.lazyPut(() => PopularProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => RecommendedProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => CartRepo(sharedPreferences:Get.find()));
  Get.lazyPut(() => UserRepo(apiClient:Get.find()));
  Get.lazyPut(() => LocationRepo(apiClient:Get.find(), sharedPreferences: Get.find()));
  //load the controllers
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => PopularProductController(popularProductRepo: Get.find()));
  Get.lazyPut(
      () => RecommendedProductController(recommendedProductRepo: Get.find()));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));

  Get.lazyPut(() => UserController(userRepo: Get.find()));
  Get.lazyPut(() => LocationController(locationRepo: Get.find()));
}
