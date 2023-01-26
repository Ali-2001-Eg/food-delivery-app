import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/controllers/cart_controller.dart';
import 'package:food_delivery_app_development/controllers/popular_prodcut_controller.dart';
import 'package:food_delivery_app_development/models/cart_model.dart';
import 'package:food_delivery_app_development/routes/route_helper.dart';
import 'package:food_delivery_app_development/screens/cart/cart_page.dart';
import 'package:food_delivery_app_development/screens/home/food_body_page.dart';
import 'package:food_delivery_app_development/screens/home/home_page.dart';
import 'package:food_delivery_app_development/screens/home/main_food_page.dart';
import 'package:food_delivery_app_development/shared/components/small_text.dart';
import 'package:food_delivery_app_development/shared/utils/colors.dart';
import 'package:food_delivery_app_development/shared/utils/constants.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';
import 'package:food_delivery_app_development/shared/components/app_column.dart';
import 'package:food_delivery_app_development/shared/components/app_icon.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';
import 'package:food_delivery_app_development/shared/components/expandable_text_widget.dart';
import 'package:get/get.dart';

import '../../shared/components/big_text.dart';

class PopularFoodDetail extends StatelessWidget {
  final int pageId;
  final String page;
  PopularFoodDetail({Key? key, required this.pageId, required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var product =
        Get.find<PopularProductController>().popularProductsList[pageId];
    // print(pageId.toString());
    // print(product.name.toString());
    Get.find<PopularProductController>()
        .initProduct(product, Get.find<CartController>()); //very important
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            //background image
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                height: Dimensions.popularFoodImageSize,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      AppConstants.BASE_URL +
                          AppConstants.UPLOAD +
                          product.img!,
                    ),
                  ),
                ),
              ),
            ),
            //icon widgets
            Positioned(
              top: Dimensions.height45,
              left: Dimensions.width20,
              right: Dimensions.width20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (page == 'cartpage') {
                        Get.to(()=>CartPage());
                      } else {
                        Get.to(()=>HomePage());
                      }
                    },
                    child: AppIcon(
                      icon: Icons.arrow_back_ios,
                      // size: Dimensions.height30,
                      // iconSize: Dimensions.iconSize16,
                    ),
                  ),
                  GetBuilder<PopularProductController>(
                    builder: (popularProduct) => GestureDetector(
                      onTap: () {
                        popularProduct.totalItems >= 1
                            ? Get.to(()=>CartPage())
                            : null;
                      },
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          AppIcon(
                            icon: Icons.shopping_cart_outlined
                            // ,size: Dimensions.height30,
                            //   iconSize: Dimensions.iconSize16,
                          ),
                          //we will make a condition
                          popularProduct.totalItems >= 1
                              ? CircleAvatar(
                                  radius: Dimensions.radius7,
                                  backgroundColor: AppColors.mainColor,
                                  child: Text(
                                    popularProduct.totalItems.toString(),
                                    style: TextStyle(
                                        fontSize: Dimensions.height10),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            //introduction of food
            Positioned(
              top: Dimensions.popularFoodImageSize - 20,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  top: Dimensions.height20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Dimensions.radius20),
                    topLeft: Radius.circular(Dimensions.radius20),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppColumn(
                      text: product.name,
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    BigText(
                      text: 'Introduce',
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    //expandable text widget
                    //expanded and single side scroll view in column widget is required
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: ExpandableTextWidget(
                          text: product.description!,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        //instance of the controller
        bottomNavigationBar: GetBuilder<PopularProductController>(
          builder: (popularProduct) => Container(
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
            child: Row(
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
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => popularProduct.setQuantity(false),
                        child: Icon(
                          Icons.remove,
                          color: AppColors.signColor,
                          size: Dimensions.iconSize24,

                        ),
                      ),
                      SizedBox(
                        width: Dimensions.width10 / 2,
                      ),
                      BigText(text: popularProduct.inCartItem.toString()),
                      SizedBox(
                        width: Dimensions.width10 / 2,
                      ),
                      GestureDetector(
                        onTap: () {
                          popularProduct.setQuantity(true);
                        },
                        child: Icon(
                          Icons.add,
                          color: AppColors.signColor,
                          size: Dimensions.iconSize24,
                        ),
                      ),
                    ],
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
                      text: '\$${(product.price!)} | Add to cart ',
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
        ));
  }
}
