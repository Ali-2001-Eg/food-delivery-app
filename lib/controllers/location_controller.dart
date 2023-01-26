import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:food_delivery_app_development/data/api/api_checker.dart';
import 'package:food_delivery_app_development/data/repository/location_repo.dart';
import 'package:food_delivery_app_development/models/address_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import '../data/repository/response_model.dart';

class LocationController extends GetxController implements GetxService {
  LocationRepo locationRepo;
  LocationController({required this.locationRepo});
  bool _loading = false;
  late Position _position;
  late Position _pickPosition;
  Position get position => _position;
  Placemark _placemark = Placemark();
  Placemark _pickPlacemark = Placemark();
  List<AddressModel> _addressList = [];
  bool get loading => _loading;
  late List<AddressModel> _allAddressList;
  Placemark get placemark => _placemark;
  Placemark get pickPlacemark => _pickPlacemark;
  List<AddressModel> get addressList => _addressList;
  List<AddressModel> get allAddressList => _allAddressList;
  late GoogleMapController _googleMapController;
  GoogleMapController get googleMapController => _googleMapController;
  Position get pickPosition => _pickPosition;
  bool get isAddressUpdated => _isAddressUpdated;
  bool get isAddressChanged => _isAddressChanged;
  bool _isAddressUpdated = true;
  bool _isAddressChanged = false;

  // for service zone
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  //whether user is in zone or not
  bool _inZone = false;
  bool get inZone => _inZone;

  //for showing and hiding the button as the map loads
  bool _buttonDisabled = true;
  bool get buttonDisabled => _buttonDisabled;

  //saving google map suggestions
  List<Prediction> _predictionList = [];

  void setMapController(GoogleMapController mapController) {
    _googleMapController = mapController;
  }

//to update position after selecting a new pick
  void updatePosition(CameraPosition position, bool fromAddress) async {
    if (_isAddressUpdated) {
      _loading = true;
      update();
      try {
        if (fromAddress) {
          _position = Position(
              longitude: position.target.longitude,
              latitude: position.target.latitude,
              timestamp: DateTime.now(),
              accuracy: 1,
              altitude: 1,
              heading: 1,
              speed: 1,
              speedAccuracy: 1);
        } else {
          _pickPosition = Position(
              longitude: position.target.longitude,
              latitude: position.target.latitude,
              timestamp: DateTime.now(),
              accuracy: 1,
              altitude: 1,
              heading: 1,
              speed: 1,
              speedAccuracy: 1);
        }
        //to get zone and remove button after loading
        ResponseModel _responseModel = await getZone(
            position.target.latitude.toString(),
            position.target.longitude.toString(),
            false);
        _buttonDisabled = !_responseModel.isSuccess;
        //change address after picking
        if (_isAddressChanged) {
          String _address = await getAddressfromGeoCode(
              LatLng(position.target.latitude, position.target.longitude));
          fromAddress
              ? _placemark = Placemark(name: _address)
              : _pickPlacemark = Placemark(name: _address);
          // print(_placemark.name);
        }else{
          _isAddressChanged=true;
          update();
        }
      } catch (e) {
        print(e.toString());
      }
      _loading = false;
      update();
    } else {
      //very important to update address after changing it
      _isAddressUpdated = true;
      update();
    }
  }

  Future<String> getAddressfromGeoCode(LatLng latLng) async {
    String _address = 'Unknown location';
    Response response = await locationRepo.getAddressfromGeoCode(latLng);
    if (response.body['status'] == 'ok') {
      //to print position in the debug console
      _address = response.body['results'][0]['formatted_address'].toString();
      // print(_address);
    } else {
      print('Error getting google api');
    }
    update();
    return _address;
  }

  //to see if it was address in local storage or not
  late Map<String, dynamic> _getAddress;
  Map<String, dynamic> get getAddress => _getAddress;

  AddressModel getUserAddress() {
    late AddressModel _addressModel;
    //decode to convert data from String to object or map to get address from server
    _getAddress = jsonDecode(locationRepo.getUserAddress()!);
    try {
      _addressModel =
          AddressModel.fromJson(jsonDecode(locationRepo.getUserAddress()!));
    } catch (e) {
      print(e);
    }
    return _addressModel;
  }

  //to set address type
  final List<String> _addressTypeList = ['home', 'office', 'others'];
  List<String> get addressTypeList => _addressTypeList;
  int _addressTypeIndex = 0;
  int get addressTypeIndex => _addressTypeIndex;

  void setAddressTypeIndex(int index) {
    _addressTypeIndex = index;
    update();
  }

  Future<ResponseModel> addUserAddress(AddressModel addressModel) async {
    _loading = true;
    update();
    Response response = await locationRepo.addAddress(addressModel);
    ResponseModel responseModel;

    if (response.statusCode == 200) {
      // to get the list that the new address will be saved in
      await getAddressList();
      String message = response.body['message'];
      responseModel = ResponseModel(true, message);
      update();
      await saveUserAddress(addressModel); //future return
    } else {
      print('could\'t save this address');
      responseModel = ResponseModel(false, response.statusText!);
    }
    update();

    return responseModel;
  }

  Future<void> getAddressList() async {
    Response response = await locationRepo.getAllAddress();
    if (response.statusCode == 200) {
      //ensure that it is empty because it is unique for each user
      _addressList = [];
      _allAddressList = [];
      //foreach in body map
      response.body.forEach((address) {
        _addressList.add(AddressModel.fromJson(address));
        _allAddressList.add(AddressModel.fromJson(address));
      });
    } else {
      _addressList = [];
      _allAddressList = [];
    }
    update();
  }

  //will be saved in local storage
  Future<bool> saveUserAddress(AddressModel addressModel) async {
    String userAddress = jsonEncode(addressModel.toJson());
    return await locationRepo.saveUserAddress(userAddress);
  }

  //to remove all local storage after logging out
  void clearAddressList() {
    _addressList = [];
    _allAddressList = [];
    update();
  }

  String getUserAddressFromLocalStorage() {
    return locationRepo.getUserAddress()!;
  }

  //save all data to ve changed after camera move
  void setAddAddressData() {
    _position = _pickPosition;
    _placemark = _pickPlacemark;
    _isAddressUpdated = false;
    update();
  }

  Future<ResponseModel> getZone(String lat, String lng, bool markedLoad) async {
    late ResponseModel _responseModel;
    if (markedLoad) {
      _loading = true;
    } else {
      _isLoading = true;
    }
    update();
    /*
    dummy network request
    await Future.delayed(const Duration(seconds: 2), () {
      _responseModel = ResponseModel(true,'success');
      if (markedLoad) {
        _loading = true;
      } else {
        _isLoading = true;
      }
      //to view the button
      _inZone=true;
    });*/
    Response response = await locationRepo.getZone(lat, lng);
    if (response.statusCode == 200) {
      _inZone = true;
      _responseModel = ResponseModel(true, response.body['zone_id'].toString());
    } else {
      _inZone = false;
      _responseModel = ResponseModel(false, response.statusText.toString());
    }
    //to trigger our button
    if (markedLoad) {
      _loading = false;
    } else {
      _isLoading = false;
    }
    update();
    return _responseModel;
  }

  Future<List<Prediction>> getSuggestions(
      String locationDialog, BuildContext context) async {
    if (locationDialog.isNotEmpty) {
      Response response = await locationRepo.getSuggestions(locationDialog);
      if (response.statusCode == 200 && response.body['status'] == 'OK') {
        _predictionList = [];
        //add json values returned from the server
        response.body['predictions'].forEach((prediction) =>
            _predictionList.add(Prediction.fromJson(prediction)));
      } else {
        ApiChecker.checkApi(response);
      }
    }
    return _predictionList;
  }

//address is description property on map api
  setSuggestedLocation(
      String placeId, String address, GoogleMapController mapController) async {
    _loading = true;
    update();
    PlacesDetailsResponse detail;
    Response response = await locationRepo.setLocation(placeId);
    detail = PlacesDetailsResponse.fromJson(response.body);
    //to go to selected location
    _pickPosition = Position(
        longitude: detail.result.geometry!.location.lng,
        latitude: detail.result.geometry!.location.lat,
        timestamp: DateTime.now(),
        accuracy: 1,
        altitude: 1,
        heading: 1,
        speed: 1,
        speedAccuracy: 1);
    _pickPlacemark = Placemark(
      name: address,
    );
    _isAddressChanged = false;
    //to move to suggested map
    if (!mapController.isNull) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              detail.result.geometry!.location.lat,
              detail.result.geometry!.location.lng,
            ),
            zoom: 17
          ),
        ),
      );
    }
    _loading = false;
    update();
  }
}
