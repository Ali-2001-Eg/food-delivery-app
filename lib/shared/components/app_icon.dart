import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  double? iconSize=Dimensions.iconSize16 ;
  double? size=Dimensions.height30;
  AppIcon({Key? key,
    required this.icon,
    this.backgroundColor = const Color(0xFFfcf4e4),
    this.iconColor = const Color(0xFF756d54),

  }) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.height100),
        color: backgroundColor,
      ),
      child: Icon(
        icon,
        color: iconColor,
        size:  iconSize,
      ),
    );
  }
}
