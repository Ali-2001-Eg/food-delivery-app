//this class aims to get all getx package

import 'package:get/get.dart';

class Dimensions {
  //to make a responsive design we get our dimensions of our screen
  static double screenHeight = Get.context!.height;
  static double screenWidth = Get.context!.width;
  /*height is 592
  width is 360 */
// factor => we will divide our screen height by our container's height
  static double pageViewContainer = screenHeight / 3.01;
  //this container height = 120
  static double pageViewTextContainer = screenHeight / 5.69;
//for the parent container height 320 => 2.14
  static double pageView = screenHeight / 2.14;
  //this for the sized boxes those height 10
  //592/10
  static double height10 = screenHeight / 59.2;
  static double height20 = screenHeight / 29.6;
  static double height15 = screenHeight / 39.47;
  static double height30 = screenHeight / 19.73;
  static double height45 = screenHeight / 13.15;
  static double height120 = screenHeight / 4.93;
  static double height100 = screenHeight / 5.92;
  static double height350 = screenHeight / 1.7;
  //responsive paddings and margins
  // 360/x
  static double width10 = screenWidth / 36;
  static double width20 = screenWidth / 18;
  static double width15 = screenWidth / 24;
  static double width30 = screenWidth / 12;
  static double width5 = screenWidth / 75;
  //responsive font size
  static double fontSize20 = screenHeight / 29.6;
  static double fontSize18 = screenHeight / 32.9;
  static double fontSize16 = screenHeight / 37;
  static double fontSize14 = screenHeight / 42.29;
  static double fontSize10 = screenHeight / 59.2;
  static double fontSize26 = screenHeight / 22.77;
  // responsive angels
  static double radius20 = screenHeight / 29.6;
  static double radius30 = screenHeight / 19.73;
  static double radius15 = screenHeight / 39.5;
  static double radius7 = screenHeight / 84.57;

  //responsive icon size
  static double iconSize24 = screenHeight / 24.67;
  static double iconSize16 = screenHeight / 37;
  static double iconSize10 = screenHeight / 59.2;
  static double iconSize13 = screenHeight / 45.54;

  //responsive list view
  static double listViewImgSize = screenWidth / 3.4;
  static double listViewTextContSize = screenHeight / 5.38;

  //bottom hight
  static double bottomHightBar = screenHeight / 7;

  //popular food

  static double popularFoodImageSize = screenHeight / 2.3;

  //splash screen

  static double spalshImg = screenHeight / 2.96;
}
