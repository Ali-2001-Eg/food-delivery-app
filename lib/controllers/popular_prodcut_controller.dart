//repos must connect with controller to carry the data to
//show the data in the UI
import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/controllers/cart_controller.dart';
import 'package:food_delivery_app_development/data/repository/popualr_product_repo.dart';
import 'package:food_delivery_app_development/models/cart_model.dart';
import 'package:food_delivery_app_development/models/popular_product_model.dart';
import 'package:food_delivery_app_development/shared/components/small_text.dart';
import 'package:food_delivery_app_development/shared/utils/colors.dart';
import 'package:get/get.dart';
import 'dart:core';

class PopularProductController extends GetxController {
  final PopularProductRepo popularProductRepo;

  //to carry the data in
  List<dynamic> _popularProductsList = [];

  //to use the list in the UI because the _variable is private
  List<dynamic> get popularProductsList => _popularProductsList;

  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  int _quantity = 0;

  int get quantity => _quantity;

  //cart side
  var _inCartItem = 0;

  int get inCartItem => _inCartItem + _quantity;

  late CartController _cart;

  PopularProductController({required this.popularProductRepo});

  Future<void> getPopularProductList() async {
    //we must save that method in response value
    Response response = await popularProductRepo.getPopularProductList();
    if (response.statusCode == 200) {
      //we have to initialize it here to make the data unrepeatable
      _popularProductsList = [];
      //we have ton make a model to carry the data in
      //we add to a list => products which is iterable<dynamic>
      _popularProductsList
          .addAll(PopularProductModel.fromJson(response.body).products);
      // print('got products');
      // printFullText(_popularProductsList.toString());
      _isLoaded = true;
      //is like setState() method
      update();
    } else {
      print('white');
    }
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = checkQuantity(_quantity + 1);
    } else {
      _quantity = checkQuantity(_quantity - 1);
    }
    update();
  }

  //best algorithm to check the quantity
  int checkQuantity(int quantity) {
    //that if the user wanted to reduce the quantity
    //after adding to the cart
    if (_inCartItem + quantity < 0) {
      Get.snackbar(
        'Item count',
        'you can\'t reduce more',
        backgroundColor: AppColors.mainColor,
        colorText: Colors.white,
      );
      //to force decreasing cart items smaller than 0
      if(_inCartItem>0){
        _quantity= - _inCartItem;
        return _quantity;
      }
      return 0;
    } else if (_inCartItem + quantity > 20) {
      Get.snackbar(
        'Item count ',
        'you can\'t add more',
        backgroundColor: AppColors.mainColor,
        colorText: Colors.white,
      );
      return 20;
    } else {
      return quantity;
    }
  }

  //in case I ordered a dish in a popular page item
  //the other dishes would not be affected with that
  void initProduct(ProductsModel products, CartController cart) {
    _quantity = 0;
    _inCartItem = 0;
    _cart = cart;

    bool exist = false;
    exist = _cart.existInCart(products);
    // print('exist or not => $exist');
    if (exist) {
      _inCartItem = _cart.getQuantitiy(products);
    }
    // print('quantity in cart is ${_inCartItem.toString()}');
    //if exists
    //get from the storage _inCartItem =3 for example
  }

  void addItemToCart(ProductsModel product) {
    // if(_quantity>0){
    _cart.addItem(_quantity, product);
    //to add items correctly with no duplication
    _quantity = 0;
    //to set the quantity correctly to decrement it as I want
    _inCartItem = _cart.getQuantitiy(product);

    // _cart.items.forEach((key, value) {
    //   print(" key is ${value.id} " 'value is ${value.quantity}');
    // });
    update();
  }
//getters shared between cart and products model
  int get totalItems=> _cart.totalItems;
  List<CartModel> get getItems=> _cart.getItems;
  int get getTotalAmount=> _cart.getTotalAmount;
}
