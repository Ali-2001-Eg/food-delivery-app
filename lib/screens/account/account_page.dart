import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/controllers/auth_controller.dart';
import 'package:food_delivery_app_development/controllers/cart_controller.dart';
import 'package:food_delivery_app_development/controllers/location_controller.dart';
import 'package:food_delivery_app_development/routes/route_helper.dart';
import 'package:food_delivery_app_development/screens/auth/sign_in_page.dart';
import 'package:food_delivery_app_development/shared/components/account_widget.dart';
import 'package:food_delivery_app_development/shared/components/app_icon.dart';
import 'package:food_delivery_app_development/shared/components/big_text.dart';
import 'package:food_delivery_app_development/shared/utils/colors.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/user_controller.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_userLoggedIn) {
      Get.find<UserController>().getUserInfo();
      print('user logged in');
      print(Get.find<UserController>().getUserInfo().toString());
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: BigText(text: 'Profile'),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
      ),
      body: GetBuilder<UserController>(builder: (_controller) {
        return _userLoggedIn
            ? (_controller.isLoading
                ? SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      margin: EdgeInsets.only(top: Dimensions.height20),
                      width: double.maxFinite, //to center the column
                      child: Column(
                        children: [
                          //profile icon
                          CircleAvatar(
                            backgroundColor: AppColors.mainColor,
                            radius: 100,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: Dimensions.iconSize24 * 3,
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.height20,
                          ),
                          //name icon
                          AccountWidget(
                            appIcon: AppIcon(
                              icon: Icons.person,
                              iconColor: Colors.white,
                              backgroundColor: AppColors.mainColor,
                            ),
                            bigText: BigText(
                              text: _controller.userModel.name,
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.height10 * 0.5,
                          ),
                          //phone icon
                          AccountWidget(
                            appIcon: AppIcon(
                              icon: Icons.phone,
                              iconColor: Colors.white,
                              backgroundColor: AppColors.yellowColor,
                              // size: Dimensions.height10 * 5,
                              // iconSize: Dimensions.height10 * 5 / 2,
                            ),
                            bigText: BigText(
                              text: _controller.userModel.phone,
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.height10 * 0.5,
                          ),
                          //email icon
                          AccountWidget(
                            appIcon: AppIcon(
                              icon: Icons.email,
                              iconColor: Colors.white,
                              backgroundColor: AppColors.yellowColor,
                              // size: Dimensions.height10 * 5,
                              // iconSize: Dimensions.height10 * 5 / 2,
                            ),
                            bigText: BigText(
                              text: _controller.userModel.email,
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.height10 * 0.5,
                          ),
                          //address
                          GetBuilder<LocationController>(
                              builder: (locationController) {
                            if (_userLoggedIn &&
                                locationController.addressList.isEmpty) {
                              return GestureDetector(
                                onTap: () {
                                  Get.offNamed(RouteHelper.getAddressPage());
                                },
                                child: AccountWidget(
                                  appIcon: AppIcon(
                                    icon: Icons.location_on,
                                    iconColor: Colors.white,
                                    backgroundColor: AppColors.yellowColor,
                                    // size: Dimensions.height10 * 5,
                                    // iconSize: Dimensions.height10 * 5 / 2,
                                  ),
                                  bigText: BigText(
                                    text: 'Fill in your address',
                                  ),
                                ),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  Get.offNamed(RouteHelper.getAddressPage());
                                },
                                child: AccountWidget(
                                  appIcon: AppIcon(
                                    icon: Icons.location_on,
                                    iconColor: Colors.white,
                                    backgroundColor: AppColors.yellowColor,
                                    // size: Dimensions.height10 * 5,
                                    // iconSize: Dimensions.height10 * 5 / 2,
                                  ),
                                  bigText: BigText(
                                    text: 'Your address',
                                  ),
                                ),
                              );
                            }
                          }),
                          SizedBox(
                            height: Dimensions.height10 * 0.5,
                          ),
                          //message
                          AccountWidget(
                            appIcon: AppIcon(
                              icon: Icons.message,
                              iconColor: Colors.white,
                              backgroundColor: Colors.redAccent,
                              // size: Dimensions.height10 * 5,
                              // iconSize: Dimensions.height10 * 5 / 2,
                            ),
                            bigText: BigText(
                              text: 'Messages',
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.height10 * 0.5,
                          ),
                          GestureDetector(
                            onTap: () {
                              //removing all cached data
                              if (Get.find<AuthController>().userLoggedIn()) {
                                Get.find<AuthController>().clearSharedData();
                                Get.find<CartController>().clearCartHistory();
                                Get.find<CartController>().clear();
                                Get.find<LocationController>().clearAddressList();
                                Get.off(() => SignInPage());
                              }

                              Get.off(() => SignInPage());
                            },
                            child: AccountWidget(
                              appIcon: AppIcon(
                                icon: Icons.logout,
                                iconColor: Colors.white,
                                backgroundColor: Colors.redAccent,
                                // size: Dimensions.height10 * 5,
                                // iconSize: Dimensions.height10 * 5 / 2,
                              ),
                              bigText: BigText(
                                text: 'Log out',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ))
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Center(
                  child: BigText(text: 'You don\'t have account'),
                ),
                SizedBox(
                  height: Dimensions.height30,
                ),
                Center(
                  child: GestureDetector(
                      onTap: () {
                        Get.to(() => SignInPage());
                      },
                      child: BigText(
                        text: 'click here to login',
                        color: AppColors.mainColor,
                      )),
                ),
              ]);
      }),
    );
  }
}
