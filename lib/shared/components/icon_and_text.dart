import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/shared/utils/colors.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';
import 'package:food_delivery_app_development/shared/components/small_text.dart';

class IconAndText extends StatelessWidget {
  IconAndText({
    Key? key,
    required this.icon,
    required this.text,
    required this.iconColor,
    this.color,
  }) ;

  late final IconData icon;
  late final String text;
  Color? color;
  late final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: Dimensions.iconSize24,
        ),
        SmallText(
          text: text,
          color: AppColors.textColor,
        ),
      ],
    );
  }
}
