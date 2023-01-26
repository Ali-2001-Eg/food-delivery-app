import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/data/repository/cart_repo.dart';
import 'package:food_delivery_app_development/models/cart_model.dart';
import 'package:food_delivery_app_development/models/popular_product_model.dart';
import 'package:food_delivery_app_development/shared/utils/colors.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final CartRepo cartRepo;

  CartController({required this.cartRepo});

  //map to post our data {id and the cart model}
  Map<int, CartModel> _items = {};

  Map<int, CartModel> get items => _items;

  //only for storage and shared preferences
  List<CartModel> storageItems = [];

  //to add quantity to the cart model
  void addItem(int quantity, ProductsModel product) {
    // print('product id is ${product.id} , quanitiy is ${quantity}');
    //to know how many dishes in the cart
// print('list of cart items is ${_items.length}');
    //required to make the user able to add or reduce the quantity of orders
    // more than once
    var totalQuantitiy = 0;
    if (_items.containsKey(product.id!)) {
      _items.update(product.id!,
          //for the updated I will not change the id I will change the id for the cart object
          (value) {
        totalQuantitiy = value.quantity! + quantity;
        return CartModel(
            id: value.id,
            name: value.name,
            price: value.price,
            img: value.img,
            time: DateTime.now().toString(),
            isExist: true,
            //to update to the new quantity
            quantity: value.quantity! + quantity,
            product: value.product);
      });
      //when cart items count is 0 remove it from the map
      if (totalQuantitiy <= 0) {
        print('item removed');
        _items.remove(product.id);
      }
    } else {
      if (quantity > 0) {
        _items.putIfAbsent(product.id!, () {
          // print('added to the cart');
          //each object in the map in a separated lines
          /*_items.forEach((key, value) {
            print('quantity is ${value.quantity.toString()}');
          });*/
          return CartModel(
              id: product.id,
              name: product.name,
              price: product.price,
              img: product.img,
              time: DateTime.now().toString(),
              isExist: true,
              quantity: quantity,
              product: product);
        });
      } else {
        Get.snackbar(
          'Item count ',
          'you can\'t add 0 items',
          backgroundColor: AppColors.mainColor,
          colorText: Colors.white,
        );
      }
    }
    //we will add as like getItem method
    cartRepo.addToCartList(getItems);
    update();
  }

  bool existInCart(ProductsModel products) {
    if (_items.containsKey(products.id))
      return true;
    else
      return false;
  }

  int getQuantitiy(ProductsModel products) {
    var quantity = 0;
    if (_items.containsKey(products.id)) {
      _items.forEach((key, value) {
        if (key == products.id) {
          quantity = value.quantity!;
        }
      });
    }
    return quantity;
  }

//to show total number of items in the cart above the icon
  int get totalItems {
    var totalQuantity = 0;
    _items.forEach((key, value) {
      totalQuantity += value.quantity!;
    });
    return totalQuantity;
  }

//for the cart page to show all products
  List<CartModel> get getItems {
    //entries to go inside it with a key or value not indexing it
    return _items.entries.map((e) => e.value).toList();
  }

  //to get total amount of products for payment
  int get getTotalAmount {
    var totalAmount = 0;
    _items.forEach((key, value) {
      totalAmount += value.quantity! * value.price!;
    });
    return totalAmount;
  }

//will only be called when launching and killing the app
  List<CartModel> getCartData() {
    /*
  we will assign our setter to a list that carries our data
   */
    setCart = cartRepo.getCartList();
    return storageItems;
  }

   set setCart(List<CartModel> items) {
    storageItems = items;
    // print(
    //     'storage of the in cart list in the history is ${storageItems.length}');
    for (int i = 0; i < storageItems.length; i++) {
      //to access list of cart and assign to it to save in the storage
      _items.putIfAbsent(
        storageItems[i].product!.id!,
        () => storageItems[i],
        /*CartModel(
              id: storageItems[i].id,
              name: storageItems[i].name,
              price: storageItems[i].price,
              img: storageItems[i].img,
              time: storageItems[i].time,
              isExist: storageItems[i].isExist,
              quantity: storageItems[i].quantity,
              product: storageItems[i].product),*/
      );
    }
  }
  void addToHistory(){
    cartRepo.addToCartHistoryList();
    //to clear data after checking out in the UI
    clear();
  }
//to delete cached data
  void clear() {
    _items={};
    update();
  }

  List<CartModel>getHistoryList(){
    return cartRepo.getHistoryList();
  }
  //we will set the items in the cart after adding to the storage to access one more
  set setItems(Map<int,CartModel> items){
        _items={};
        _items=items;
  }
  //invoked again that the last one it's only called when adding to cart
  //and we need to call it after adding to add to another list that carries the time
void addToCartList(){
    cartRepo.addToCartList(getItems);
    update();
}

void clearCartHistory(){
    cartRepo.clearCartHistory();
    update();
}
}
