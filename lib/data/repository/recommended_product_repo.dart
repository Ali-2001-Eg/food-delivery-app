import 'package:food_delivery_app_development/data/api/api_client.dart';
import 'package:food_delivery_app_development/shared/utils/constants.dart';
import 'package:get/get.dart';

class RecommendedProductRepo {
  final ApiClient apiClient;

  RecommendedProductRepo({required this.apiClient});
  Future<Response> getRecommendedProductList() async{
    return await apiClient.getData(AppConstants.RECOMMENDED_PRODUCT_URI,);
  }
}
