import 'package:food_delivery_app_development/data/api/api_client.dart';
import 'package:food_delivery_app_development/data/repository/response_model.dart';
import 'package:food_delivery_app_development/shared/utils/constants.dart';
import 'package:get/get.dart';

class UserRepo{
  final ApiClient apiClient;

  UserRepo({required this.apiClient});

  Future<Response>getUserInfo()async{
  return await  apiClient.getData(AppConstants.USER_INFO_URI,);
  }
}