import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/base/no_data_page.dart';
import 'package:food_delivery_app_development/controllers/cart_controller.dart';
import 'package:food_delivery_app_development/models/cart_model.dart';
import 'package:food_delivery_app_development/routes/route_helper.dart';
import 'package:food_delivery_app_development/shared/components/app_icon.dart';
import 'package:food_delivery_app_development/shared/components/big_text.dart';
import 'package:food_delivery_app_development/shared/components/small_text.dart';
import 'package:food_delivery_app_development/shared/utils/colors.dart';
import 'package:food_delivery_app_development/shared/utils/constants.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../cart/cart_page.dart';

class CartHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // reversed returns object so we transform it toList to view its data with index below
    var getHistoryList =
        Get.find<CartController>().getHistoryList().reversed.toList();
    //to view cart history items according to their time
    Map<String, int> cartItemsPerOrder = {};
    for (int i = 0; i < getHistoryList.length; i++) {
      if (cartItemsPerOrder.containsKey(getHistoryList[i].time)) {
        cartItemsPerOrder.update(getHistoryList[i].time!, (value) => ++value);
      } else {
        cartItemsPerOrder.putIfAbsent(getHistoryList[i].time!, () => 1);
      }
    }
    List<int> cartItemPerOrderToList() =>
        cartItemsPerOrder.entries.map((e) => e.value).toList();
    List<int> orderTimes = cartItemPerOrderToList();
//to get the time by the key not with num of orders
    List<String> cartOrderTimeToList() =>
        cartItemsPerOrder.entries.map((e) => e.key).toList();

    int listCounter=0;

    Widget timeWidget(int index) {
      var outputDate = DateTime.now().toString();
      if (index < getHistoryList.length) {
        DateTime parsedTime = DateFormat('yyyy-MM-dd HH:mm:ss')
            .parse(getHistoryList[index].time!);
        var inputDate = DateTime.parse(parsedTime.toString());
        var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
        //returns String and take DateTime as a parameter
        outputDate = outputFormat.format(inputDate);
      }
      return BigText(text: outputDate);
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: Dimensions.height100,
            color: AppColors.mainColor,
            width: double.maxFinite,
            padding: EdgeInsets.only(top: Dimensions.height45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BigText(
                  text: 'Cart History',
                  color: Colors.white,
                ),
                Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: Dimensions.iconSize24,
                )
              ],
            ),
          ),
          Expanded(
              child: cartItemsPerOrder.isNotEmpty
                  ? Container(
                      // color: Colors.red,
                      height: Dimensions.height120,
                      margin: EdgeInsets.only(
                        top: Dimensions.height20,
                        right: Dimensions.height20,
                        left: Dimensions.height20,
                      ),
                      //list view to render all the list at one time
                      child: MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            //we can use for loop in different places
                            for (int i = 0; i < cartItemsPerOrder.length; i++)
                              Container(
                                height: Dimensions.height100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    //immediately invoked function expression IIFE
                                    //used to process the data  and in our case to edit time to ignore seconds
                                    timeWidget(listCounter),
                                    GetBuilder<CartController>(builder: (_) {
                                      return Expanded(
                                          child: _.getHistoryList().isNotEmpty
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    //gives ability to draw something
                                                    Wrap(
                                                      direction:
                                                          Axis.horizontal,
                                                      children: List.generate(
                                                          orderTimes[i],
                                                          (index) {
                                                        //to list the view horizontally according to num of orders in the time
                                                        if (listCounter <
                                                            getHistoryList
                                                                .length) {
                                                          listCounter++;
                                                        }
                                                        //number of images max = 3
                                                        return index <= 2
                                                            ? Container(
                                                                height: Dimensions
                                                                        .height20 *
                                                                    3,
                                                                width: Dimensions
                                                                        .height20 *
                                                                    3,
                                                                margin: EdgeInsets.only(
                                                                    right: Dimensions
                                                                            .width10 /
                                                                        2),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                                                                    image: DecorationImage(
                                                                        fit: BoxFit.cover,
                                                                        image: NetworkImage(
                                                                          AppConstants.BASE_URL +
                                                                              AppConstants.UPLOAD +
                                                                              getHistoryList[listCounter - 1].img!, //to prevent error in first condition that the counter will be -1
                                                                        ))),
                                                              )
                                                            : Container();
                                                      }),
                                                    ),
                                                    Container(
                                                      height:
                                                          Dimensions.height100,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SmallText(
                                                            text: 'total',
                                                            color: AppColors
                                                                .paraColor,
                                                          ),
                                                          BigText(
                                                            text:
                                                                '${orderTimes[i]} items',
                                                            color: AppColors
                                                                .titleColor,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              //to determine in which time the order was demanded
                                                              // print('Doing test to get the time ${cartOrderTimeToList()[i]}');
                                                              //we will create a map and pass it to cart controller => _items
                                                              Map<int, CartModel>moreOrder = {};
                                                              for (int j = 0; j < getHistoryList.length; j++) {
                                                                if (getHistoryList[j].time ==
                                                                    cartOrderTimeToList()[i]) {
                                                                  //to determine the time for each demand
                                                                  // print('order time is ${cartOrderTimeToList()[i]}');
                                                                  // print('product or cart id is ${getHistoryList[j].id}');
                                                                  moreOrder.putIfAbsent(
                                                                      getHistoryList[j].id!,
                                                                      () =>
                                                                          //key is the id unique
                                                                          //value is the object we made decode and encode to match the object type
                                                                          CartModel.fromJson(jsonDecode(jsonEncode(getHistoryList[j]))));
                                                                }
                                                              }
                                                              //to add certain order to the cart again
                                                              Get.find<CartController>()
                                                                      .setItems =
                                                                  moreOrder;
                                                              Get.find<
                                                                      CartController>()
                                                                  .addToCartList();
                                                              Get.to(() =>
                                                                  CartPage());
                                                            },
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            Dimensions.radius15 /
                                                                                3),
                                                                border:
                                                                    Border.all(
                                                                  width: 2,
                                                                  color: AppColors
                                                                      .mainColor,
                                                                ),
                                                              ),
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      Dimensions
                                                                          .width10,
                                                                  vertical:
                                                                      Dimensions
                                                                              .height10 /
                                                                          2),
                                                              child: SmallText(
                                                                text:
                                                                    'one more',
                                                                color: AppColors
                                                                    .mainColor,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container(
                                                  color: Colors.red,
                                                ));
                                    })
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Image(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/empty box.jpg'),
                            ),
                            Center(
                                child: BigText(
                                    text: 'Make Orders to view Cart history')),
                          ]),
                    )),
        ],
      ),
    );
  }
}
