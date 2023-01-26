import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/models/cart_model.dart';
import 'package:food_delivery_app_development/shared/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepo {
  CartRepo({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  List<String> cart = [];

  List<String> cartHistory = [];


  void addToCartList(List<CartModel> cartList) {
    // sharedPreferences.remove(AppConstants.Cart_list);//just gor debugging issues
    // sharedPreferences.remove(AppConstants.Cart_history_list);//just gor debugging issues
    cart = [];
    var time=DateTime.now().toString();
    //to convert List of object to a list of string
    //because shared pref only accepts string
    cartList.forEach((element) {
      //just to save the time for each transaction not for certain order
     element.time=time;//very important
      return cart.add(jsonEncode(element));
    });

    sharedPreferences.setStringList(AppConstants.Cart_list, cart);
    // print('Item saved');
    // print(sharedPreferences.getStringList(AppConstants.Cart_list));
    // getCartList();
  }

//after adding we shall get the data from the storage
  //for any get method the data shall be retrieved from the server in json format
  //to deal with it we shall use the model.fromJson constructor to carry the data and view it in UI
  List<CartModel> getCartList() {
    List<String> carts = [];
    if (sharedPreferences.containsKey(AppConstants.Cart_list)) {
      carts = sharedPreferences.getStringList(AppConstants.Cart_list)!;
      print(carts.toString());
    }
    List<CartModel> cartList = [];
    //to convert list of string to a list of object cart model to view it in the UI
    //constructor that carry all fields to be decoded
    carts.forEach(
        (element) => cartList.add(CartModel.fromJson(jsonDecode(element))));

    return cartList;
  }

  void addToCartHistoryList() {
    //for previously saved data to get the data first and after that we can get data
    if(sharedPreferences.containsKey(AppConstants.Cart_history_list)){
      cartHistory=sharedPreferences.getStringList(AppConstants.Cart_history_list)!;
    }
    for (int i = 0; i < cart.length; i++) {
      print(cart[i]);
      cartHistory.add(cart[i]);
    }
    //to convert cached data to persistent data
    removeCart();
    sharedPreferences.setStringList(
        AppConstants.Cart_history_list, cartHistory);
    print('length of persistent data is ${getHistoryList().length}');
  }



  List<CartModel> getHistoryList() {
    List<String> cart = [];
    if (sharedPreferences.containsKey(AppConstants.Cart_history_list)) {
      cart = sharedPreferences.getStringList(AppConstants.Cart_history_list)!;
    }
    List<CartModel> cartHistory = [];
    cart.forEach(
        (element) => cartHistory.add(CartModel.fromJson(jsonDecode(element))));
    return cartHistory;
  }

  void removeCart() {
    cart=[];
    sharedPreferences.remove(AppConstants.Cart_list);
  }

  void clearCartHistory(){
    removeCart();
    cartHistory=[];
    sharedPreferences.remove(AppConstants.Cart_history_list);
  }
}
