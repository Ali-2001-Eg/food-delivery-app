import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/shared/components/big_text.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';
import 'app_icon.dart';

class AppTextField extends StatelessWidget {
  var authController=Get.find<AuthController>();
final TextEditingController controller;
final AppIcon appIcon;
final String hintText;
late bool obscureText;
late TextInputType textInputType;


   AppTextField({
     Key? key,
     required this.controller,
     required this.appIcon,
     required this.hintText,
     this.obscureText:false,
     this.textInputType:TextInputType.text,

   })
       : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Container(
      height: Dimensions.height20*2.5,
      margin: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              spreadRadius: 1,
              offset: const Offset(1,1),
              color: Colors.grey.withOpacity(0.2),
            )
          ]
      ),
      child: TextField(
        style: TextStyle(
          fontSize: Dimensions.fontSize16
        ),
        keyboardType: textInputType,
        obscureText: obscureText?true:false,
        controller: controller,
        decoration: InputDecoration(

          hintText: hintText ,
          hintStyle: TextStyle(
            fontSize: Dimensions.fontSize16
          ),
          prefixIcon: appIcon,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.white,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
          ),
        ),
      ),
    );
  }
}
