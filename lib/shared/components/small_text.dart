import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';

class SmallText extends StatelessWidget {
  int? maxlines;
  Color? color;
  TextOverflow? overflow;
  final String text;
  double? size=Dimensions.fontSize10;
  double height;
  SmallText({
    this.overflow,
    this.maxlines,
    Key? key,
    this.color = const Color(0xFFccc7c5),
    required this.text,
    this.height = 1.2,
  }):super() ;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxlines,
      style: TextStyle(
        color: color,
        overflow: overflow,
        fontWeight: FontWeight.w300,
        fontSize: size,
        height: height,
      ),
    );
  }
}

void printFullText(String? text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text!).forEach((element) {
    print(element.group(0));
  });
}
