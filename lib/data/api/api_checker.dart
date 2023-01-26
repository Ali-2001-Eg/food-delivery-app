import 'package:flutter/services.dart';
import 'package:food_delivery_app_development/base/show_custom_snackbar.dart';
import 'package:food_delivery_app_development/routes/route_helper.dart';
import 'package:get/get.dart';

class ApiChecker{
  static void checkApi(Response response){
    if(response.statusCode==401){
      //user didn't log in
      Get.toNamed(RouteHelper.signInPage);
    }else{
      showCustomSnackBar(response.statusText!);
    }
  }
}