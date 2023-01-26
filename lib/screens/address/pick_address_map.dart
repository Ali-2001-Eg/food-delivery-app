import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/base/custom_button.dart';
import 'package:food_delivery_app_development/controllers/auth_controller.dart';
import 'package:food_delivery_app_development/controllers/location_controller.dart';
import 'package:food_delivery_app_development/routes/route_helper.dart';
import 'package:food_delivery_app_development/screens/address/search_location_dialog_widget.dart';
import 'package:food_delivery_app_development/shared/utils/colors.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickAddressMap extends StatefulWidget {
  final bool fromSignUp;
  final bool fromAddress;
  final GoogleMapController? googleMapController;

  const PickAddressMap(
      {Key? key,
      required this.fromAddress,
      required this.fromSignUp,
      this.googleMapController})
      : super(key: key);

  @override
  State<PickAddressMap> createState() => _PickAddressMapState();
}

class _PickAddressMapState extends State<PickAddressMap> {
  late LatLng _initialPosition;
  late CameraPosition _cameraPosition;
  late GoogleMapController _googleMapController;
//to initialize late variables
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //no saved addresses so give it initial position
    if (Get.find<LocationController>().addressList.isEmpty) {
      _initialPosition = const LatLng(45.521563, -122.677423);
      _cameraPosition = CameraPosition(target: _initialPosition, zoom: 17);
    } else {
      //get addresses saved from local storage
      if (Get.find<LocationController>().addressList.isNotEmpty) {
        _initialPosition = LatLng(
          double.parse(Get.find<LocationController>().getAddress['latitude']),
          double.parse(Get.find<LocationController>().getAddress['longitude']),
        );
        _cameraPosition = CameraPosition(target: _initialPosition, zoom: 17);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (locationController) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SizedBox(
                width: double.maxFinite,
                child: Stack(
                  children: [
                    GoogleMap(
                      //initial position will be dynamic
                      initialCameraPosition: CameraPosition(
                        zoom: 17,
                        target: _initialPosition,
                      ),
                      onCameraMove: (cameraPosition) {
                        _cameraPosition = cameraPosition;
                      },
                      onCameraIdle: () {
                        Get.find<LocationController>()
                            .updatePosition(_cameraPosition, false);
                      },
                      onMapCreated: (mapController){
                        _googleMapController=mapController;
                      },
                    ),
                    //asset pick marker image to be centered in the map
                    Center(
                      child: !locationController.loading
                          ? Image.asset(
                              'assets/images/pick marker.jpg',
                              height: 50,
                              width: 50,
                            )
                          : const CircularProgressIndicator(),
                    ),
                    //pick place mark address
                    GestureDetector(
                      onTap: ()=> Get.dialog(SearchLocationDialog(mapController: _googleMapController)),
                      child: Positioned(
                        top: Dimensions.height45,
                        left: Dimensions.height20,
                        right: Dimensions.height20,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width10),
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius20 / 2),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 25,
                                color: AppColors.yellowColor,
                              ),
                              Expanded(
                                  child: Text(
                                locationController.pickPlacemark.name ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimensions.fontSize16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),),
                              SizedBox(width: Dimensions.width10,),
                               Icon(
                                Icons.search,
                                size: 25,
                                color: AppColors.mainColor,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    //custom button
                    Positioned(
                      bottom: 80,
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      child: locationController.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : CustomButton(
                              buttonText: locationController.inZone
                                  ? widget.fromAddress
                                      ? 'Pick Address'
                                      : 'Pick Location'
                                  : 'service is not available in your area',
                              onPressed: (locationController.loading||locationController.buttonDisabled)
                                  ? () => null
                                  : () {
                                      if (locationController
                                                  .pickPosition.latitude !=
                                              0 &&
                                          locationController.pickPlacemark !=
                                              null) {
                                        //came from add address page
                                        if (widget.fromAddress) {
                                          //map has been created
                                          if (widget.googleMapController !=
                                              null) {
                                            // update camera position after picking an address
                                            widget.googleMapController!
                                                .moveCamera(
                                              CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                  target: LatLng(
                                                      locationController
                                                          .pickPosition
                                                          .latitude,
                                                      locationController
                                                          .pickPosition
                                                          .longitude),
                                                ),
                                              ),
                                            );
                                            //save all data
                                            locationController
                                                .setAddAddressData();
                                            Get.toNamed(
                                                RouteHelper.getAddressPage());
                                          }
                                        }
                                      }
                                    },
                            ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
