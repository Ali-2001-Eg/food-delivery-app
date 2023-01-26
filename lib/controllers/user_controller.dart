
import 'package:food_delivery_app_development/data/repository/response_model.dart';
import 'package:food_delivery_app_development/models/signup_model.dart';
import 'package:food_delivery_app_development/models/user_model.dart';
import 'package:get/get.dart';

import '../data/repository/user_repo.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;

  UserController({required this.userRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  late UserModel userModel;

  Future<ResponseModel> getUserInfo() async {

    Response response = await userRepo.getUserInfo();
    print(response.body.toString());
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      userModel = UserModel.fromJson(response.body);
      _isLoading=true;

      responseModel = ResponseModel(true, 'successfully');

    } else {
      print('didn\'t get user model');
      responseModel = ResponseModel(false, response.statusText!);
    }

    update();
    return responseModel;
  }


}
