import 'package:food_delivery_app_development/models/signup_model.dart';
import 'package:food_delivery_app_development/screens/address/add_address_page.dart';
import 'package:food_delivery_app_development/screens/address/pick_address_map.dart';
import 'package:food_delivery_app_development/screens/auth/sign_in_page.dart';
import 'package:food_delivery_app_development/screens/cart/cart_page.dart';
import 'package:food_delivery_app_development/screens/food/popular_food_detail.dart';
import 'package:food_delivery_app_development/screens/food/recommended_food_details.dart';
import 'package:food_delivery_app_development/screens/home/history_page.dart';
import 'package:food_delivery_app_development/screens/home/home_page.dart';
import 'package:food_delivery_app_development/screens/spalsh/splash_screen.dart';
import 'package:get/get.dart';

class RouteHelper {
  static const String splashPage = '/splash-page';
  static const String signInPage = '/sign-in-page';
  static const String signUpPage = '/sign-up-page';
  static const String historyPage = '/history-page';
  static const String initial = '/';
  static const String popularFood = '/popular-food';
  static const String recommendedFood = '/recommended-food';
  static const String cart = '/cart-page';
  static String getPopularPage(int pageId, String page) =>
      "$popularFood?pageId=$pageId&page=$page";
  static String getInitialPage({int? pageId}) => initial;
  static String getCartPage() => cart;
  static String getSplashPage() => splashPage;
  static String getHistoryPage() => historyPage;
  //auth
  static String getSignInPage() => signInPage;
  static String getSignUpPage() => signUpPage;

  //address
  static const String addressPage = '/address-page';
  static const String pickPage='/pick-page';
  static String getAddressPage() => addressPage;
  static String getPickAddressPage() => addressPage;

  static String getRecommendedPage(int pageId, String item) {
    return "$recommendedFood?pageId=$pageId&item=$item";
  }

  static List<GetPage> routes = [
    GetPage(
        name: '/',
        page: () {
          return const HomePage();
        },
        transition: Transition.fade),
    GetPage(
        name: popularFood,
        page: () {
          var pageId = Get.parameters['pageId'];
          var page = Get.parameters['page'];
          return PopularFoodDetail(
            pageId: int.parse(pageId!),
            page: page!,
          );
        },
        transition: Transition.fadeIn),
    GetPage(
        name: recommendedFood,
        page: () {
          var pageId = Get.parameters['pageId'];
          var recommendedItem = Get.parameters['item'];
          return RecommendedFoodDetails(
              pageId: int.parse(pageId!), recommendedItem: recommendedItem!);
        },
        transition: Transition.fadeIn),
    GetPage(
        transition: Transition.fadeIn,
        name: cart,
        page: () {
          return CartPage();
        }),
    GetPage(name: splashPage, page:()=> SplashScreen()),
    GetPage(name: addressPage, page:()=> const AddAddressPage()),

    GetPage(name: signInPage, page:()=> SignInPage()),
    // GetPage(name: signUpPage, page:()=> SignUpModel(name: name, password: password, phone: phone, email: email)),
    GetPage(name: pickPage, page: () {
      PickAddressMap _pickAddress=Get.arguments;//passing everything not only single parameters
      return _pickAddress;
    }),
  ];
  static List<GetPage> getRoutes() => routes;
}
