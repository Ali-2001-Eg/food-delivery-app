import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/data/repository/response_model.dart';
import 'package:food_delivery_app_development/models/signup_model.dart';
import 'package:get/get.dart';

import '../data/repository/auth_repo.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  //here we will use auth model to register

  Future<ResponseModel> registration(SignUpModel signUpModel) async {
    _isLoading = true;
    //value is edited
    update();
    //to control the request and send it to UI
    Response response = await authRepo.registration(signUpModel);
    // print(response.toString());
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      authRepo.saveUserToken(response.body['token']);
      //to receive post response correctly
      responseModel = ResponseModel(true, response.body['token']);
      // print(response.body['token'].toString());
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> login(/*String email,*/String password, String phone) async {
    // print('getting token');
    // print(jsonEncode(authRepo.getUserToken().toString()));//to get user token firstly
    _isLoading = true;
    update();

    Response response = await authRepo.login(password,phone);
    // print(response.body.toString());
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      print('backend token');
      authRepo.saveUserToken(response.body['token']);
      //to receive post response correctly
      // print(response.body['token'].toString());
      responseModel = ResponseModel(true, response.body['token']);

    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  void saveUserNumberAndPassword(String number,String password) {
    authRepo.saveUserNumberAndPassword(number, password);
  }

  bool userLoggedIn(){
    return authRepo.userLoggedIn();
  }

  bool clearSharedData(){
    return authRepo.removeSharedData();
  }

}
