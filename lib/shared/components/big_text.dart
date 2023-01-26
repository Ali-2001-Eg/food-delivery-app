import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/shared/utils/colors.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';

class BigText extends StatelessWidget {
  Color? color = AppColors.mainBlackColor;
  final String text;
   double? size=Dimensions.fontSize20;
  TextOverflow overflow;
  //values in the constructor overrides main values in the class
  BigText({
    this.color,
    required this.text,
    this.overflow = TextOverflow.ellipsis,

  }):super();

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w400,
        fontSize: size ,
      ),
    );
  }
}
