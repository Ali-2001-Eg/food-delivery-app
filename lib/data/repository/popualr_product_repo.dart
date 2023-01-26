import 'package:food_delivery_app_development/data/api/api_client.dart';
import 'package:food_delivery_app_development/shared/utils/constants.dart';
import 'package:get/get.dart';

class PopularProductRepo extends GetxService{
  //we need to make repo for the api client
  final ApiClient apiClient;

  PopularProductRepo({required this.apiClient});
  Future <Response> getPopularProductList() async{
    //repos must call a method from the api client
  return await apiClient.getData(AppConstants.POPULAR_PRODUCT_URI,);
  }
}