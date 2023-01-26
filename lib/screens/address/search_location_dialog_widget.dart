import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:food_delivery_app_development/controllers/location_controller.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/places.dart';

class SearchLocationDialog extends StatelessWidget {
  final GoogleMapController mapController;
  const SearchLocationDialog({Key? key, required this.mapController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Container(
      padding: EdgeInsets.all(Dimensions.width10),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius20 / 2),
        ),
        child: SizedBox(
          width: Dimensions.screenWidth,
          child: Container(
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _controller,
                textInputAction: TextInputAction.search,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                    hintText: 'search location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        style: BorderStyle.none,
                        width: 0,
                      ),
                    ),
                    hintStyle: Theme.of(context).textTheme.headline2?.copyWith(
                          color: Theme.of(context).disabledColor,
                          fontSize: Dimensions.fontSize16,
                        )),
              ),

              //after tapping click stream consequences => go to destination
              onSuggestionSelected: (Prediction suggestion)  {

                 Get.find<LocationController>().setSuggestedLocation(suggestion.placeId!, suggestion.description!, mapController);
                 Get.back();
              },
              //to give us suggestions called back from the server
              suggestionsCallback: (pattern) async {
                return await Get.find<LocationController>()
                    .getSuggestions(pattern, context);
              },
              itemBuilder: (context, Prediction itemData) {
                return Padding(
                  padding: EdgeInsets.all(Dimensions.width10),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on),
                      Expanded(
                        child: Text(
                          //Prediction object returned from the server
                          itemData.description!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                              Theme.of(context).textTheme.headline2?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color,
                                    fontSize: Dimensions.fontSize16,
                                  ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
