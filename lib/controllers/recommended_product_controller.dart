
import 'package:food_delivery_app_development/data/repository/popualr_product_repo.dart';
import 'package:food_delivery_app_development/data/repository/recommended_product_repo.dart';
import 'package:food_delivery_app_development/models/popular_product_model.dart';
import 'package:get/get.dart';
import 'dart:core';

class RecommendedProductController extends GetxController {
  final RecommendedProductRepo recommendedProductRepo;
  //to carry the data in
  List<dynamic> _recommendedProductsList = [];
  //to use the list in the UI because the _variable is private
  List<dynamic> get recommendedProductsList => _recommendedProductsList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  RecommendedProductController({required this.recommendedProductRepo});
  Future<void> getRecommendedProductList() async {
    Response response = await recommendedProductRepo.getRecommendedProductList();
    if (response.statusCode == 200) {
      _recommendedProductsList = [];
      //the same model because it's the same objects
      _recommendedProductsList
          .addAll(PopularProductModel.fromJson(response.body).products);
      // print('got products recommended');
      // printFullText(_popularProductsList.toString());
      _isLoaded=true;
      update();
    } else {
      print('white');
    }
  }
}
