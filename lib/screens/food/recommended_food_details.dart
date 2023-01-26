import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/controllers/cart_controller.dart';
import 'package:food_delivery_app_development/controllers/popular_prodcut_controller.dart';
import 'package:food_delivery_app_development/routes/route_helper.dart';
import 'package:food_delivery_app_development/screens/cart/cart_page.dart';
import 'package:food_delivery_app_development/screens/home/history_page.dart';
import 'package:food_delivery_app_development/screens/home/home_page.dart';
import 'package:food_delivery_app_development/screens/home/main_food_page.dart';
import 'package:food_delivery_app_development/shared/utils/colors.dart';
import 'package:food_delivery_app_development/shared/utils/constants.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';
import 'package:food_delivery_app_development/shared/components/app_icon.dart';
import 'package:food_delivery_app_development/shared/components/big_text.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';
import 'package:get/get.dart';

import '../../controllers/recommended_product_controller.dart';
import '../../shared/components/expandable_text_widget.dart';

class RecommendedFoodDetails extends StatelessWidget {
  const RecommendedFoodDetails(
      {Key? key, required this.pageId, required this.recommendedItem})
      : super(key: key);
  final int pageId;
  final String recommendedItem;

  @override
  Widget build(BuildContext context) {
    var product = Get.find<RecommendedProductController>()
        .recommendedProductsList[pageId];
    Get.find<PopularProductController>()
        .initProduct(product, Get.find<CartController>());
    // print(widget.pageId);
    // print(product.name!);
    // num _totalPrice = _counter * product.price;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 80,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (recommendedItem == 'cartpage')
                      Get.to(()=>CartPage());
                    else
                      Get.to(()=>HomePage());
                  },
                  child: AppIcon(
                      icon: Icons.clear,
                      // size: Dimensions.height30,
                      // iconSize: Dimensions.iconSize16.
                  ),
                ),
                GetBuilder<PopularProductController>(
                  builder: (popularProduct) => Stack(
                    alignment: Alignment.topRight,
                    children: [
                      GestureDetector(
                          onTap: () {
                            popularProduct.totalItems >= 1
                                ? Get.to(()=>CartPage())
                                : null;
                          },
                          child: AppIcon(
                              icon: Icons.shopping_cart_outlined,
                            // iconSize: Dimensions.iconSize16,
                            // size: Dimensions.height30,
                          )),
                      //we will make a condition
                      Get.find<PopularProductController>().totalItems >= 1
                          ? CircleAvatar(
                              radius: Dimensions.radius7,
                              backgroundColor: AppColors.mainColor,
                              child: Text(
                                popularProduct.totalItems.toString(),
                                style: TextStyle(fontSize: Dimensions.height10),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                )
              ],
            ),
            bottom: PreferredSize(
              //when the image will be covered
              preferredSize: Size.fromHeight(20),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radius20),
                      topRight: Radius.circular(Dimensions.radius20),
                    )),
                width: double.maxFinite,
                padding: EdgeInsets.only(
                  top: 5,
                  bottom: 10,
                ),
                child: Center(
                  child: BigText(
                    // size: Dimensions.fontSize20,
                    text: product.name!,
                  ),
                ),
              ),
            ),
            backgroundColor: AppColors.yellowColor,
            pinned: true,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                AppConstants.BASE_URL + AppConstants.UPLOAD + product.img!,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Column(
            children: [
              Container(
                child: ExpandableTextWidget(
                  text: product.description!,
                ),
                margin: EdgeInsets.only(
                  left: Dimensions.width10,
                  right: Dimensions.width10,
                ),
              ),
            ],
          )),
        ],
      ),
      bottomNavigationBar: GetBuilder<PopularProductController>(
        builder: (popularProduct) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.only(
                left: Dimensions.width20 * 2.5,
                right: Dimensions.width20 * 2.5,
                top: Dimensions.height10,
                bottom: Dimensions.height10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      popularProduct.setQuantity(false);
                    },
                    child: AppIcon(
                      icon: Icons.remove,
                      backgroundColor: AppColors.mainColor,
                      iconColor: Colors.white,
                      // iconSize: Dimensions.iconSize24,
                    ),
                  ),
                  BigText(
                    text: ' \$${product.price!} X ' +
                        '${popularProduct.inCartItem}',
                    color: AppColors.mainBlackColor,
                    // size: Dimensions.fontSize26,
                  ),
                  GestureDetector(
                    onTap: () {
                      //true to increment
                      popularProduct.setQuantity(true);
                    },
                    child: AppIcon(
                      icon: Icons.add,
                      backgroundColor: AppColors.mainColor,
                      iconColor: Colors.white,
                      // iconSize: Dimensions.iconSize24,
                    ),
                  ),
                ],
              ),
            ),
            Container(
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
              child: GetBuilder<PopularProductController>(
                builder: (PopularProductController popularProduct) => Row(
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
                      child: Icon(
                        Icons.favorite_outlined,
                        color: AppColors.mainColor,
                        size: Dimensions.iconSize24,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        popularProduct.addItemToCart(product);
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          top: Dimensions.height10,
                          bottom: Dimensions.height10,
                          right: Dimensions.width10,
                          left: Dimensions.width10,
                        ),
                        child: BigText(
                          text: '\$${product.price!} Add to cart ',
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
