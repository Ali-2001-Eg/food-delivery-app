import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/models/address_model.dart';
import 'package:food_delivery_app_development/shared/utils/constants.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_client.dart';

class LocationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  LocationRepo({required this.sharedPreferences, required this.apiClient});

  Future<Response> getAddressfromGeoCode(LatLng latLng) async {
    return await apiClient.getData('${AppConstants.GEOCODE_URI}'
        '?lat=${latLng.latitude}'
        '&lng=${latLng.longitude}');
  }

  String? getUserAddress() {
    return sharedPreferences.getString(AppConstants.USER_ADDRESS) ?? '';
  }

  Future<Response> addAddress(AddressModel addressModel) async {
    return await apiClient.postData(
        AppConstants.ADD_USER_ADDRESS, addressModel.toJson());
  }

  Future<Response> getAllAddress() async {
    return await apiClient.getData(AppConstants.ADDRESS_LIST_URI);
  }

  Future<bool> saveUserAddress(String userAddress) {
    //to save address related to specific user
    apiClient.updateHeader(sharedPreferences.getString(AppConstants.TOKEN)!);
    return sharedPreferences.setString(AppConstants.USER_ADDRESS, userAddress);
  }


  Future<Response>getZone(String lat, String lng) async{
    return await apiClient.getData(AppConstants.ZONE_URI);
  }
  //for autocomplete
  Future<Response>getSuggestions(String text) async{
    //response will get data according to text given
    return await apiClient.getData('${AppConstants.SEARCH_LOCATION_URI}?search_text=$text');
  }

  Future<Response>setLocation(String placeId)async{
    return await apiClient.getData('${AppConstants.PLACE_DETAILS_URI}?search_text=$placeId');

  }
}
