import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/routes/route_helper.dart';
import 'package:food_delivery_app_development/screens/auth/sign_up_page.dart';
import 'package:food_delivery_app_development/screens/home/home_page.dart';
import 'package:food_delivery_app_development/shared/components/app_icon.dart';
import 'package:food_delivery_app_development/shared/components/app_text_field.dart';
import 'package:food_delivery_app_development/shared/components/big_text.dart';
import 'package:food_delivery_app_development/shared/utils/colors.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';
import 'package:get/get.dart';

import '../../base/show_custom_snackbar.dart';
import '../../controllers/auth_controller.dart';
import '../../models/signup_model.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var phoneController = TextEditingController();

    void _signIn(AuthController authController) {
      String password = passwordController.text.trim();
      String email = emailController.text.trim();
      String phone = phoneController.text.trim();
      //form validation
      if (!GetUtils.isEmail(email)) {
        showCustomSnackBar('Type in a valid Email address',
            title: 'valid email address');
      } else if (phone.isEmail) {
        showCustomSnackBar('Type in your phone', title: 'Phone');
      } else if (password.isEmpty) {
        showCustomSnackBar('Type in your password', title: 'Password');
      } else if (password.length < 6) {
        showCustomSnackBar('Password can\'t be less than 6 characters',
            title: 'Password');
      } else {
        authController.login(/*email, */ password, phone).then((status) {
          if (status.isSuccess) {
            showCustomSnackBar('Success Login',
                title: 'Perfect', isError: false);
            // print('success registration');
            Get.to(() => HomePage());
          } else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: GetBuilder<AuthController>(
          builder: (_controller) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: Dimensions.screenHeight * 0.03,
                  ),
                  //logo app
                  Container(
                    height: Dimensions.screenHeight * 0.2,
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: Dimensions.radius15 * 5,
                        backgroundImage:
                            AssetImage('assets/images/food logo part 1.jpg'),
                      ),
                    ),
                  ),
                  //welcome section
                  Container(
                    margin: EdgeInsets.only(left: Dimensions.width20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Hello',
                          style: TextStyle(
                              fontSize: Dimensions.fontSize26 * 2.55,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Sign into your account',
                          style: TextStyle(
                            fontSize: Dimensions.fontSize18,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.screenHeight * 0.05,
                  ),
                  //credential section
                  //email
                   AppTextField(
                      textInputType: TextInputType.emailAddress,
                      controller: emailController,
                      appIcon: AppIcon(
                        icon: Icons.email,
                        // size: Dimensions.height30,
                        backgroundColor: Colors.white,
                        // iconSize: Dimensions.iconSize16,
                        iconColor: AppColors.mainColor,
                      ),
                      hintText: 'Email Address'),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  //phone
                  AppTextField(
                    hintText: 'phone',
                    controller: phoneController,
                    appIcon: AppIcon(
                      icon: Icons.phone,
                      // size: Dimensions.height30,
                      backgroundColor: Colors.white,
                      // iconSize: Dimensions.iconSize16,
                      iconColor: AppColors.mainColor,
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  //password
                  AppTextField(
                      obscureText: true,
                      controller: passwordController,
                      appIcon: AppIcon(
                          icon: Icons.password,
                          iconColor: AppColors.mainColor,
                          backgroundColor: Colors.white),
                      hintText: 'Password'),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: 'Sign into your account',
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: Dimensions.fontSize16)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.screenHeight * 0.06,
                  ),
                  //sign in button
                  GestureDetector(
                    onTap: () {
                      _signIn(_controller);
                    },
                    child: !_controller.isLoading
                        ? Container(
                            width: Dimensions.screenWidth / 2,
                            height: Dimensions.screenHeight / 10,
                            decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius30)),
                            child: Center(
                                child: BigText(
                              text: 'Sign in',
                              // size: Dimensions.fontSize26,
                              color: Colors.white,
                            )),
                          )
                        : CircularProgressIndicator(),
                  ),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  //already have an account
                  Container(
                    margin: EdgeInsets.only(left: Dimensions.width20 * 2),
                    child: Row(
                      children: [
                        RichText(
                          text: TextSpan(
                              text: 'Don\'t have an account?',
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: Dimensions.fontSize14)),
                        ),
                        SizedBox(
                          width: Dimensions.height10,
                        ),
                        //sign in options
                        RichText(
                          text: TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.to(
                                    () => SignupPage(),
                                  ),
                            text: '  Create',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Dimensions.fontSize20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }
}
