import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/controllers/popular_prodcut_controller.dart';
import 'package:food_delivery_app_development/controllers/recommended_product_controller.dart';
import 'package:food_delivery_app_development/screens/auth/sign_in_page.dart';
import 'package:food_delivery_app_development/shared/utils/colors.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';
import 'package:food_delivery_app_development/shared/components/big_text.dart';
import 'package:food_delivery_app_development/screens/home/food_body_page.dart';
import 'package:food_delivery_app_development/shared/components/small_text.dart';
import 'package:get/get.dart';

class MainFoodPage extends StatefulWidget {
  @override
  State<MainFoodPage> createState() => _MainFoodPageState();
}

class _MainFoodPageState extends State<MainFoodPage> {
  //resourses loaded after refreshment
  Future<void> _loadResourses() async {
    await Get.find<PopularProductController>().getPopularProductList();
    await Get.find<RecommendedProductController>().getRecommendedProductList();
  }

  @override
  Widget build(BuildContext context) {
    // to load new resourses
    return RefreshIndicator(
      color: AppColors.mainColor,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: Dimensions.height45,
                bottom: Dimensions.height15,
              ),
              padding: EdgeInsets.only(
                left: Dimensions.width10,
                right: Dimensions.width10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BigText(
                        text: 'Bangladesh',
                        color: AppColors.mainColor,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: Row(
                          children: [
                            SmallText(
                              text: 'Cairo',
                              color: AppColors.textColor,
                              height: 1.5,
                            ),
                            Icon(
                              Icons.arrow_drop_down_outlined,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Container(
                      width: Dimensions.height45,
                      height: Dimensions.height45,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius15),
                        color: AppColors.mainColor,
                      ),
                      child: GestureDetector(
                        onTap: (){
                          Get.to(()=>SignInPage());
                        },
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: Dimensions.iconSize24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: FoodPageBody(),
              ),
            ),
          ],
        ),
        onRefresh: _loadResourses);
  }
}
