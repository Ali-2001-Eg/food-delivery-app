import 'package:food_delivery_app_development/data/api/api_client.dart';
import 'package:food_delivery_app_development/models/signup_model.dart';
import 'package:food_delivery_app_development/shared/utils/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> registration(SignUpModel signUpModel) async {
    //to post to the server our auth data in json format
    return await apiClient.postData(
        AppConstants.REGISTERATION_URI, signUpModel.toJson());
  }

  Future<Response> login(/*String email,*/ String password, String phone) async {
    //to post to the server our auth data in json format
    return await apiClient.postData(AppConstants.LOGIN_URI,
        {/*'email': email, */'password': password, 'phone': phone});
  }

  //user will get a token in registration and will be saved in local storage
  //to ensure authentication method and when logging in server will use that token
  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  Future<void> saveUserNumberAndPassword(String number, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.PASSWORD, password);
      await sharedPreferences.setString(AppConstants.NUMBER, number);
    } catch (e) {
      throw e;
    }
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? 'none';
  }

  bool userLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

   bool removeSharedData(){
    sharedPreferences.remove(AppConstants.TOKEN);
    sharedPreferences.remove(AppConstants.PASSWORD);
    sharedPreferences.remove(AppConstants.NUMBER);
    apiClient.token='';
    apiClient.updateHeader('');
    return true;
   }
}
