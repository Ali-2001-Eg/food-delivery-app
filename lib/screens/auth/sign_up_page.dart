import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/base/show_custom_snackbar.dart';
import 'package:food_delivery_app_development/controllers/auth_controller.dart';
import 'package:food_delivery_app_development/models/signup_model.dart';
import 'package:food_delivery_app_development/routes/route_helper.dart';
import 'package:food_delivery_app_development/screens/auth/sign_in_page.dart';
import 'package:food_delivery_app_development/shared/components/app_icon.dart';
import 'package:food_delivery_app_development/shared/components/app_text_field.dart';
import 'package:food_delivery_app_development/shared/components/big_text.dart';
import 'package:food_delivery_app_development/shared/utils/colors.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';
import 'package:get/get.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    var signUpImages = [
      'facebook.jpg',
      'google.jpg',
      'twitter.jpg',
    ];

    void _signUp(AuthController authController) {
      //we passed this var as param
      // var authController = Get.find<AuthController>();
      String name = nameController.text.trim();
      String phone = phoneController.text.trim();
      String password = passwordController.text.trim();
      String email = emailController.text.trim();
      //form validation
      if (name.isEmpty) {
        showCustomSnackBar('Type in your name', title: 'Name');
      } else if (!GetUtils.isEmail(email)) {
        showCustomSnackBar('Type in a valid Email address',
            title: 'valid email address');
      } else if (password.isEmpty) {
        showCustomSnackBar('Type in your password', title: 'Password');
      } else if (password.length < 6) {
        showCustomSnackBar('Password can\'t be less than 6 characters',
            title: 'Password');
      } else if (phone.isEmpty) {
        showCustomSnackBar('Type in your phone number', title: 'Phone number');
      } else {
        //we have to make model to make controller send to repo to convert
        //credentials to json format to send to api client to connect to server
        // and finally the server will send its response to api client
        // after that we will show it in UI client side
        SignUpModel signUpModel = SignUpModel(
            name: name,
            password: password,
            phone: phone,
            email: email); //object model
        // print(signUpModel.email.toString());

        authController.registration(signUpModel).then((status) {
          if (status.isSuccess) {
            showCustomSnackBar('Success Registration', title: 'Perfect',isError: false);
            // print('success registration');
            Get.to(()=>SignInPage());

          } else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(builder: (_controller) {
        return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: Dimensions.screenHeight * 0.03,
                    ),
                    Container(
                      height: Dimensions.screenHeight * 0.2,
                      child: Center(
                        child: CircleAvatar(
                          child: Image(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/food logo part 1.jpg'),
                          ),
                          backgroundColor: Colors.white,
                          radius: Dimensions.radius15*5,
                        ),
                      ),
                    ),
                    //credential section
                    AppTextField(
                        controller: nameController,
                        appIcon: AppIcon(
                            iconColor: AppColors.yellowColor,
                            icon: Icons.person,
                            // size: Dimensions.height30,
                            backgroundColor: Colors.white,
                            // iconSize: Dimensions.iconSize24
                            ),
                        hintText: 'Username'),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    AppTextField(
                        textInputType: TextInputType.emailAddress,
                        controller: emailController,
                        appIcon: AppIcon(
                            icon: Icons.email,
                            iconColor: AppColors.yellowColor,
                            // size: Dimensions.height30,
                            backgroundColor: Colors.white,
                            // iconSize: Dimensions.iconSize24,
                        ),
                        hintText: 'Email Address'),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    AppTextField(obscureText: true,controller: passwordController, appIcon: AppIcon(icon: Icons.password,iconColor:AppColors.yellowColor,backgroundColor: Colors.white), hintText: 'Password'),

                    SizedBox(
                      height: Dimensions.height20,
                    ),

                    AppTextField(
                        textInputType: TextInputType.number,
                        controller: phoneController,
                        appIcon: AppIcon(
                            icon: Icons.phone,
                            iconColor: AppColors.yellowColor,
                            // size: Dimensions.height30,
                            backgroundColor: Colors.white,
                            // iconSize: Dimensions.iconSize24,
                        ),
                        hintText: 'Phone'),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    //sign up button
                    !_controller.isLoading
                        ?GestureDetector(
                      onTap: () {
                        _signUp(_controller);
                      },
                      child: Container(
                        width: Dimensions.screenWidth / 2,
                        height: Dimensions.screenHeight / 14,
                        decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius30)),
                        child: Center(
                            child: BigText(
                          text: 'Sign up',
                          // size: Dimensions.fontSize20,
                          color: Colors.white,
                        )),
                      ),
                    ):
                    const Center(child: CircularProgressIndicator()),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    //already have an account
                    RichText(
                      text: TextSpan(
                          //like gesture detector and instantiate object from TapGestureRecognizer and use its functions
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.to(() => SignInPage()),
                          text: 'Have an account already?',
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: Dimensions.fontSize18)),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    //sign in options
                    RichText(
                      text: TextSpan(
                          text: 'Sign up with the following methods',
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: Dimensions.fontSize16)),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),

                    Wrap(
                      children: List.generate(
                          3,
                          (index) => Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: Dimensions.radius20,
                                  child: Image.asset(
                                    'assets/images/' + signUpImages[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )),
                    )
                  ],
                ),
              );

      }),
    );
  }
}
