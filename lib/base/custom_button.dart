import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fonSize;
  final double? radius;
  final IconData? icon;

  const CustomButton(
      {Key? key,
      this.onPressed,
      required this.buttonText,
      this.transparent = false,
      this.margin,
      this.height,
      this.width,
      this.fonSize,
      this.radius = 5,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //to create an instance to be used later
    final ButtonStyle _flatButton = TextButton.styleFrom(
        backgroundColor: onPressed == null
            ? Theme.of(context).disabledColor
            : transparent
                ? Colors.transparent
                : Theme.of(context).primaryColor,
        minimumSize:
            Size(width == null ? Dimensions.screenWidth : width!, height ?? 50),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius!),
        ));
    return Center(
      child: SizedBox(
        width: width ?? Dimensions.screenWidth,
        height: height ?? 50,
        child: TextButton(
          onPressed: onPressed,
          style: _flatButton,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon != null
                  ? Padding(
                      padding: EdgeInsets.only(right: Dimensions.width10 / 2),
                      child: Icon(
                        icon,
                        color: transparent
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).cardColor,
                      ),
                    )
                  : SizedBox(),
              Text(
                buttonText,
                style: TextStyle(
                  fontSize: fonSize ?? Dimensions.fontSize16,
                  color: transparent
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).cardColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
