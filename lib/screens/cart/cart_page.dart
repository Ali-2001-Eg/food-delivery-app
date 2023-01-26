import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/base/no_data_page.dart';
import 'package:food_delivery_app_development/controllers/cart_controller.dart';
import 'package:food_delivery_app_development/controllers/location_controller.dart';
import 'package:food_delivery_app_development/controllers/popular_prodcut_controller.dart';
import 'package:food_delivery_app_development/controllers/recommended_product_controller.dart';
import 'package:food_delivery_app_development/routes/route_helper.dart';
import 'package:food_delivery_app_development/screens/address/add_address_page.dart';
import 'package:food_delivery_app_development/screens/food/popular_food_detail.dart';
import 'package:food_delivery_app_development/screens/home/history_page.dart';
import 'package:food_delivery_app_development/screens/home/home_page.dart';
import 'package:food_delivery_app_development/screens/home/main_food_page.dart';
import 'package:food_delivery_app_development/shared/components/app_icon.dart';
import 'package:food_delivery_app_development/shared/components/big_text.dart';
import 'package:food_delivery_app_development/shared/components/small_text.dart';
import 'package:food_delivery_app_development/shared/utils/colors.dart';
import 'package:food_delivery_app_development/shared/utils/constants.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../auth/sign_in_page.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: Dimensions.width20,
            right: Dimensions.width20,
            top: Dimensions.height20 * 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: AppIcon(
                    icon: Icons.arrow_back_ios,
                    backgroundColor: AppColors.mainColor,
                    iconColor: Colors.white,
                  ),
                ),
                SizedBox(
                  width: Dimensions.width20 * 5,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(()=>HomePage());
                  },
                  child: AppIcon(
                    icon: Icons.home_outlined,
                    backgroundColor: AppColors.mainColor,
                    iconColor: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(()=>CartHistoryPage());
                  },
                  child: AppIcon(
                    icon: Icons.shopping_cart_outlined,
                    backgroundColor: AppColors.mainColor,
                    iconColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          GetBuilder<CartController>(
              builder: (_) => _.getItems.isNotEmpty
                  ? Positioned(
                      top: Dimensions.height20 * 5,
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      bottom:
                          0, //means that is positioned to the end of the screen
                      child: Container(
                        margin: EdgeInsets.only(top: Dimensions.height15),
                        // color: Colors.red,
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: GetBuilder<CartController>(
                            builder: (controller) {
                              return ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (_, index) {
                                    return Container(
                                      height: Dimensions.height20 * 5,
                                      width: double.maxFinite,
                                      margin: EdgeInsets.only(
                                          bottom: Dimensions.height10),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            //to navigate to a certain page we have to pass an index
                                            onTap: () {
                                              //we will pass the list item in the map and the position in that list
                                              var popularIndex = Get.find<
                                                      PopularProductController>()
                                                  .popularProductsList //list of pages
                                                  .indexOf(
                                                      controller //its index in the list
                                                          .getItems[index]
                                                          .product!);
                                              if (popularIndex >= 0) {
                                                Get.to(
                                                    ()=>PopularFoodDetail(
                                                      pageId:
                                                        popularIndex,
                                                        page: 'cartpage'));
                                              } else {
                                                //in case that a recommended item is in the cart
                                                var recommendedIndex = Get.find<
                                                        RecommendedProductController>()
                                                    .recommendedProductsList //list of pages
                                                    .indexOf(
                                                        controller //its index in the list
                                                            .getItems[index]
                                                            .product!);
                                                if (recommendedIndex < 0) {
                                                  Get.snackbar(
                                                    'History product',
                                                    'product review is not available for history products',
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white,
                                                  );
                                                } else {
                                                  Get.toNamed(RouteHelper
                                                      .getRecommendedPage(
                                                          recommendedIndex,
                                                          'cartpage'));
                                                }
                                              }
                                            },
                                            child: Container(
                                              height: Dimensions.height20 * 5,
                                              width: Dimensions.height20 * 5,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions.radius20),
                                                  color: Colors.white,
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        AppConstants.BASE_URL +
                                                            AppConstants
                                                                .UPLOAD +
                                                            controller
                                                                .getItems[index]
                                                                .img!),
                                                  )),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Dimensions.width10,
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: Dimensions.height20 * 5,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  BigText(
                                                    text: controller
                                                        .getItems[index].name!,
                                                    color: Colors.black54,
                                                  ),
                                                  SmallText(text: 'spicy'),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      BigText(
                                                        text:
                                                            "\$${controller.getItems[index].price!}",
                                                        color: Colors.redAccent,
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: Dimensions
                                                              .height10,
                                                          bottom: Dimensions
                                                              .height10,
                                                          right: Dimensions
                                                              .width10,
                                                          left: Dimensions
                                                              .width10,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  Dimensions
                                                                      .radius20),
                                                          color: Colors.white,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                controller.addItem(
                                                                    -1, //quantity to decrement
                                                                    controller //to effect in the storage data in that product
                                                                        .getItems[index]
                                                                        .product!);
                                                              },
                                                              child: Icon(
                                                                Icons.remove,
                                                                color: AppColors
                                                                    .signColor,
                                                                size: Dimensions
                                                                    .iconSize24,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: Dimensions
                                                                      .width10 /
                                                                  2,
                                                            ),
                                                            BigText(
                                                                text:
                                                                    '${controller.getItems[index].quantity}'),
                                                            SizedBox(
                                                              width: Dimensions
                                                                      .width10 /
                                                                  2,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                controller.addItem(
                                                                    1,
                                                                    controller
                                                                        .getItems[
                                                                            index]
                                                                        .product!);
                                                              },
                                                              child: Icon(
                                                                Icons.add,
                                                                color: AppColors
                                                                    .signColor,
                                                                size: Dimensions
                                                                    .iconSize24,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: controller.getItems.length);
                            },
                          ),
                        ),
                      ),
                    )
                  : NoDataPage(text: 'Your cart is empty!'))
        ],
      ),
      bottomNavigationBar: GetBuilder<CartController>(
        builder: (_) => Container(
          height: Dimensions.bottomHightBar,
          padding: EdgeInsets.only(
            top: Dimensions.height10,
            bottom: Dimensions.height10,
            right: Dimensions.width10,
            left: Dimensions.width10,
          ),
          decoration: BoxDecoration(
            color: AppColors.buttonBackgroundColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(
                Dimensions.radius20 * 2,
              ),
              topLeft: Radius.circular(
                Dimensions.radius20 * 2,
              ),
            ),
          ),
          child: _.getItems.isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: Dimensions.height10,
                        bottom: Dimensions.height10,
                        right: Dimensions.width10,
                        left: Dimensions.width10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius20),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: Dimensions.width10 / 2,
                          ),
                          BigText(text: '\$\t ${_.getTotalAmount}'),
                          SizedBox(
                            width: Dimensions.width10 / 2,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if(Get.find<AuthController>().userLoggedIn()){
                          //add to cart history list
                          _.addToHistory();
                          // print('logged in');
                          if(Get.find<LocationController>().addressList.isNotEmpty) {
                            Get.toNamed(RouteHelper.getAddressPage());
                          }else{
                            // print('login please');
                            Get.offNamed(RouteHelper.getInitialPage());
                          }

                        }else{
                          Get.to(()=>SignInPage(),transition: Transition.fade);
                        }

                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          top: Dimensions.height10,
                          bottom: Dimensions.height10,
                          right: Dimensions.width10,
                          left: Dimensions.width10,
                        ),
                        child: BigText(
                          text: 'Check out',
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius20,
                          ),
                          color: AppColors.mainColor,
                        ),
                      ),
                    )
                  ],
                )
              : Container(),
        ),
      ),
    );
  }
}
