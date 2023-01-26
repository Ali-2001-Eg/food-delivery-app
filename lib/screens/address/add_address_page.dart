import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/controllers/auth_controller.dart';
import 'package:food_delivery_app_development/controllers/location_controller.dart';
import 'package:food_delivery_app_development/controllers/user_controller.dart';
import 'package:food_delivery_app_development/routes/route_helper.dart';
import 'package:food_delivery_app_development/screens/address/pick_address_map.dart';
import 'package:food_delivery_app_development/shared/components/app_icon.dart';
import 'package:food_delivery_app_development/shared/components/app_text_field.dart';
import 'package:food_delivery_app_development/shared/components/big_text.dart';
import 'package:food_delivery_app_development/shared/utils/colors.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/address_model.dart';
import '../../models/user_model.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({Key? key}) : super(key: key);

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonName = TextEditingController();
  final TextEditingController _contactPersonNumber = TextEditingController();
  late bool _isLogged;
  CameraPosition _cameraPosition =
      const CameraPosition(target: LatLng(45.51563, -122.677433), zoom: 17);
  late LatLng _initialPosition = const LatLng(45.51563, -122.677433);

  @override
  void initState() {
    super.initState();
    _isLogged = Get.find<AuthController>().userLoggedIn();
    if (_isLogged && Get.find<UserController>().userModel == null) {
      Get.find<UserController>().getUserInfo();
    }
    if (Get.find<LocationController>().addressList.isNotEmpty) {
      if (Get.find<LocationController>().getUserAddressFromLocalStorage() ==
          '') {
        Get.find<LocationController>()
            .saveUserAddress(Get.find<LocationController>().addressList.last);
      }
      Get.find<LocationController>()
          .getUserAddress(); //to initialize getAddress
      _cameraPosition = CameraPosition(
          target: LatLng(
        double.parse(Get.find<LocationController>().getAddress['latitude']),
        double.parse(Get.find<LocationController>().getAddress['longitude']),
      ));
      _initialPosition = LatLng(
        double.parse(Get.find<LocationController>().getAddress['latitude']),
        double.parse(Get.find<LocationController>().getAddress['longitude']),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Address Page'),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
      ),
      //to access location controller
      body: GetBuilder<UserController>(
        builder: (userController) {
          //for first user logged in
          if (userController.userModel.name != null &&
              _contactPersonName.text.isEmpty) {
            _contactPersonName.text = userController.userModel.name;
            _contactPersonNumber.text = userController.userModel.phone;
          } //for user previously logged in (local storage)
          if (Get.find<LocationController>().addressList.isNotEmpty) {
            //to save address
            _addressController.text =
                Get.find<LocationController>().getUserAddress().address;
          } else {}

          {
            return GetBuilder<LocationController>(
              builder: (locationController) {
                _addressController.text = '${locationController.placemark.name}'
                    '${locationController.placemark.country}'
                    '${locationController.placemark.locality}'
                    '${locationController.placemark.postalCode}';

                // print(_addressController.text);
                _contactPersonName.text = userController.userModel.name;
                _contactPersonNumber.text = userController.userModel.phone;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //map section
                      Container(
                        height: Dimensions.height20 * 7,
                        width: MediaQuery.of(context).size.width,
                        margin:
                            const EdgeInsets.only(left: 5, top: 5, right: 5),
                        decoration: BoxDecoration(
                            border: Border.all(
                          width: 3,
                          color: AppColors.mainColor,
                        )),
                        child: Stack(
                          children: [
                            GoogleMap(
                              onTap: (latlng) {
                                Get.toNamed(RouteHelper.getPickAddressPage(),
                                    arguments: PickAddressMap(
                                      fromSignUp: false,
                                      fromAddress: true,
                                      googleMapController: locationController.googleMapController,
                                    ));
                              },
                              initialCameraPosition: CameraPosition(
                                  target: _initialPosition, zoom: 17),
                              compassEnabled: false,
                              indoorViewEnabled: true,
                              mapToolbarEnabled: false,
                              myLocationEnabled: true,
                              onCameraIdle: () {
                                locationController.updatePosition(
                                    _cameraPosition,
                                    true); //true means it's updated
                              },
                              onCameraMove: ((position) =>
                                  _cameraPosition = position),
                              onMapCreated:
                                  (GoogleMapController googleMapController) {
                                locationController
                                    .setMapController(googleMapController);
                              },
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: Dimensions.width10, top: Dimensions.height20),
                        child: SizedBox(
                          height: 50,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                locationController.addressTypeList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () => locationController
                                    .setAddressTypeIndex(index),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.width20,
                                      vertical: Dimensions.height10),
                                  margin: EdgeInsets.only(
                                      right: Dimensions.width10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radius15 / 3),
                                      color: Theme.of(context).cardColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey[200]!,
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                        )
                                      ]),
                                  //it can work without Row
                                  child: Icon(
                                    index == 0
                                        ? Icons.home_filled
                                        : index == 1
                                            ? Icons.work
                                            : Icons.location_on,
                                    color:
                                        locationController.addressTypeIndex ==
                                                index
                                            ? AppColors.mainColor
                                            : Theme.of(context).disabledColor,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: Dimensions.width20),
                        child: BigText(text: 'Delivery address'),
                      ),
                      SizedBox(
                        height: Dimensions.height10,
                      ),
                      //Delivery address where the map is marked ->changes automatically
                      AppTextField(
                          controller: _addressController,
                          appIcon: AppIcon(icon: Icons.map),
                          hintText: 'Your address'),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: Dimensions.width20),
                        child: BigText(text: 'contact name'),
                      ),
                      SizedBox(
                        height: Dimensions.height10,
                      ),
                      //name section
                      AppTextField(
                          controller: _contactPersonName,
                          appIcon: AppIcon(icon: Icons.person),
                          hintText: 'Your name'),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: Dimensions.width20),
                        child: BigText(text: 'Your number'),
                      ),
                      SizedBox(
                        height: Dimensions.height10,
                      ),
                      //number section
                      AppTextField(
                          controller: _contactPersonNumber,
                          appIcon: AppIcon(icon: Icons.smartphone_outlined),
                          hintText: 'Your number'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),

      bottomNavigationBar: GetBuilder<LocationController>(
        builder: (locationController) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: Dimensions.height20 * 8,
                padding: EdgeInsets.only(
                  top: Dimensions.height10,
                  bottom: Dimensions.height10,
                  right: Dimensions.width10,
                  left: Dimensions.width10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.buttonBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(
                      Dimensions.radius20 * 2,
                    ),
                    topLeft: Radius.circular(
                      Dimensions.radius20 * 2,
                    ),
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    //make instance of address model
                    AddressModel _addressModel = AddressModel(
                      addressType: locationController
                          .addressTypeList[locationController.addressTypeIndex],
                      contactPersonName: _contactPersonName.text,
                      contactPersonNumber: _contactPersonNumber.text,
                      address: _addressController.text,
                      latitude: locationController.position.latitude.toString(),
                      longitude:
                          locationController.position.longitude.toString(),
                    );

                    locationController
                        .addUserAddress(_addressModel)
                        .then((value) {
                      if (value.isSuccess) {
                        Get.toNamed(RouteHelper.getInitialPage());
                        Get.snackbar('Address', 'Added successfully');
                      } else {
                        Get.snackbar('Address', 'Could\'t save address');
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      top: Dimensions.height10,
                      bottom: Dimensions.height10,
                      right: Dimensions.width10,
                      left: Dimensions.width10,
                    ),
                    child: BigText(
                      text: 'Save Address',
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Dimensions.radius20,
                      ),
                      color: AppColors.mainColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
