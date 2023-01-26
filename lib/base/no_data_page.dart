import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

//global class not for certain page
class NoDataPage extends StatelessWidget {
  final String text;
  const NoDataPage({
    Key? key,
    required this.text,
    this.imgPath = 'assets/images/empty cart.png',
  }) : super(key: key);
  final String imgPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          imgPath,
          height: MediaQuery.of(context).size.height*.4,
          width: MediaQuery.of(context).size.height * 0.22,
          fit: BoxFit.cover,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height*0.0175,
            color: Theme.of(context).disabledColor,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
