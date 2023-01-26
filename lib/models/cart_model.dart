import 'package:food_delivery_app_development/models/popular_product_model.dart';

class CartModel {
  int? id;
  String? name;
  int? price;
  String? img;
  String? time;
  bool? isExist;
  int? quantity;
  //to access products model in the cart page to get benefit with its method
  ProductsModel? product;
//required in post methods to carry the data easily
  CartModel(
      {required this.id,
      required this.name,
      required this.price,
      required this.img,
      required this.time,
      required this.isExist,
      required this.quantity,
      required this.product});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    img = json['img'];
    quantity = json['quantity'];
    isExist = json['isExist'];
    time = json['time'];
    product = ProductsModel.fromJson(json['product']);
  }
//to convert cart model to String type used in post method
  Map<String, dynamic> toJson () {
    return{
      "id": this.id,
      "name": this.name,
      "price": this.price,
      "img": this.img,
      "quantity": this.quantity,
      "isExist": this.isExist,
      "time": this.time,
      'product': this.product!.toJson(),
    };
  }


}
