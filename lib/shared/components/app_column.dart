import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/shared/components/small_text.dart';

import 'package:food_delivery_app_development/shared/utils/colors.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';
import 'big_text.dart';
import '../utils/dimensions.dart';
import 'icon_and_text.dart';

class AppColumn extends StatelessWidget {
  final String text;
  const AppColumn({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BigText(
          text: text,
        ),
        SizedBox(
          //to keep responsive
          height: Dimensions.height10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              //without '[]' that we will make a list
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  size: 15,
                  color: AppColors.mainColor,
                ),
              ),
            ),
            SizedBox(
              width: Dimensions.width5,
            ),
            SmallText(
              text: '4.5',
              color: AppColors.textColor,
            ),
            SizedBox(
              width: Dimensions.width5,
            ),
            SmallText(
              text: '125 comments',
              color: AppColors.textColor,
            ),
          ],
        ),
        SizedBox(
          height: Dimensions.height10/2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconAndText(
              icon: Icons.circle_sharp,
              text: 'Normal',
              iconColor: AppColors.iconColor1,
            ),
            IconAndText(
              icon: Icons.location_on,
              text: '1.7km',
              iconColor: AppColors.mainColor,
            ),
            IconAndText(
              icon: Icons.access_time_sharp,
              text: '32min',
              iconColor: AppColors.iconColor2,
            ),
          ],
        )
      ],
    );
  }
}
