import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app_development/controllers/auth_controller.dart';
import 'package:food_delivery_app_development/controllers/popular_prodcut_controller.dart';
import 'package:food_delivery_app_development/controllers/recommended_product_controller.dart';
import 'package:food_delivery_app_development/models/popular_product_model.dart';
import 'package:food_delivery_app_development/routes/route_helper.dart';
import 'package:food_delivery_app_development/screens/food/popular_food_detail.dart';
import 'package:food_delivery_app_development/screens/food/recommended_food_details.dart';
import 'package:food_delivery_app_development/shared/utils/colors.dart';
import 'package:food_delivery_app_development/shared/utils/constants.dart';
import 'package:food_delivery_app_development/shared/utils/constants.dart';
import 'package:food_delivery_app_development/shared/utils/dimensions.dart';
import 'package:food_delivery_app_development/shared/components/app_column.dart';
import 'package:food_delivery_app_development/shared/components/big_text.dart';
import 'package:food_delivery_app_development/shared/components/icon_and_text.dart';
import 'package:food_delivery_app_development/shared/components/small_text.dart';
import 'package:get/get.dart';

class FoodPageBody extends StatefulWidget {
  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  //a fraction to style the layout of sliding
  PageController pageController = PageController(
    viewportFraction: 0.85,
  );
  var _currentPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _height = Dimensions.pageViewContainer;
  //to emit state and rebuild the new state

  @override
  void initState() {
    super.initState();
    //to zoom-in and -out during sliding
    pageController.addListener(() {
      setState(() {
        _currentPageValue = pageController.page!;
        // print('Current value is$_currentPageValue');
      });
    });
  }

  @override
  //when leaving the page make it inactive to decrease the memory for the device
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //to get our device screen dimensions which is
    //height is 592
    // print(MediaQuery.of(context).size.height.toString());
    //our width is 360
    // print(MediaQuery.of(context).size.width.toString());
    return Column(
      children: [
        GetBuilder<PopularProductController>(
          builder: (popularProducts) => popularProducts.isLoaded
              ? Container(
                  height: Dimensions.pageView,
                  child: PageView.builder(
                    controller: pageController,
                    physics: BouncingScrollPhysics(),
                    itemCount: popularProducts.popularProductsList.length,
                    itemBuilder: (context, index) => _buildPageItem(
                        index, popularProducts.popularProductsList[index]),
                  ),
                )
              : CircularProgressIndicator(
                  color: AppColors.mainColor,
                ),
        ),

        GetBuilder<PopularProductController>(
          builder: (popularProducts) => DotsIndicator(
            dotsCount: (popularProducts.popularProductsList.isNotEmpty
                ? popularProducts.popularProductsList.length
                : 1),
            position: _currentPageValue,
            decorator: DotsDecorator(
              activeColor: AppColors.mainColor,
              size: const Size.square(7.0),
              activeSize: const Size(12.0, 7.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),

        SizedBox(
          height: Dimensions.height30,
        ),

        Container(
          margin: EdgeInsets.only(
            left: Dimensions.width30,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BigText(
                text: 'Recommended',
              ),
              SizedBox(
                width: Dimensions.width10,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 3),
                child: BigText(
                  text: ' ',
                  color: Colors.black26,
                ),
              ),
              SizedBox(
                width: Dimensions.width10,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 2),
                child: SmallText(
                  text: 'Food pairing',
                ),
              )
            ],
          ),
        ),
        //List of food and images
        GetBuilder<RecommendedProductController>(
          builder: (recommendedProducts) {
            return recommendedProducts.isLoaded
                ? ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => _buildFoodItem(index,
                        recommendedProducts.recommendedProductsList[index]),
                    separatorBuilder: (context, index) => SizedBox(
                          height: Dimensions.height10,
                        ),
                    itemCount:
                        recommendedProducts.recommendedProductsList.length)
                : Center(
                    child: CircularProgressIndicator(
                      color: AppColors.mainColor,
                    ),
                  );
          },
        ),
      ],
    );
  }

//we give here list of objects that carry the data
  Widget _buildPageItem(int index, ProductsModel popularProducts) {
    //to draw api in a matrix
    Matrix4 matrix = Matrix4.identity();
    if (index == _currentPageValue.floor()) {
      //when the screen stops in the index the our current scale will be 1
      //and that means we will dominate the scale
      var currScale = 1 - (_currentPageValue - index) * (1 - _scaleFactor);
      //to put the api in a matrix to control zooming
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      var currTrans = _height * (1 - currScale) / 2;
    } else if (index == _currentPageValue.floor() + 1) {
      //here we made our current scale 0.8
      // for the other pages when the screen stops in the index
      var currScale =
          _scaleFactor + (_currentPageValue - index + 1) * (1 - _scaleFactor);
      //220*(1-.08)/2=22
      //the height will decrease to be 22
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currentPageValue.floor() - 1) {
      //here we made our current scale 0.8
      // for the other pages when the screen stops in the index
      var currScale = 1 - (_currentPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 0);
    }
    return Transform(
      //to convert our logic into a shown actions
      transform: matrix,
      child: Stack(
        children: [
          //we will send a parameter to be as an id number for the product
          GestureDetector(
            onTap: () {
              // print(Get.find<AuthController>().authRepo.getUserToken());
              Get.to(()=>PopularFoodDetail(pageId: index,page: 'home'));
            },
            child: Container(
              height: Dimensions.pageViewContainer,
              margin: EdgeInsets.only(
                left: 0,
                right: Dimensions.width20 / 2,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  Dimensions.radius20,
                ),
                // color: index.isEven ? Color(0xFF69c5df) : Color(0xFF9294cc),
                image: DecorationImage(
                  image: NetworkImage(
                    AppConstants.BASE_URL +
                        AppConstants.UPLOAD +
                        popularProducts.img!,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Dimensions.pageViewTextContainer,
              margin: EdgeInsets.only(
                left: Dimensions.width30,
                right: Dimensions.width30,
                bottom: Dimensions.height30,
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFe8e8e8),
                    blurRadius: 5.0,
                    offset: Offset(0, 5),
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-5, 0),
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(5, 0),
                  ),
                ],
                borderRadius: BorderRadius.circular(
                  Dimensions.radius30,
                ),
                color: Colors.white,
              ),
              child: Container(
                padding: EdgeInsets.only(
                  top: Dimensions.height15,
                  left: Dimensions.width15,
                  right: Dimensions.width15,
                ),
                child: AppColumn(
                  text: popularProducts.name!,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildFoodItem(int index, ProductsModel products) =>
    GetBuilder<RecommendedProductController>(
      builder: (recommendedProducts) => GestureDetector(
        onTap: () {
          Get.to(()=>RecommendedFoodDetails(pageId: index,recommendedItem: 'home'));
        },
        child: Container(
          margin: EdgeInsets.only(
            left: Dimensions.width20 / 2,
            right: Dimensions.width20 / 2,
          ),
          child: Row(
            children: [
              //image section
              Container(
                height: Dimensions.listViewImgSize,
                width: Dimensions.listViewImgSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Colors.white,
                  image: DecorationImage(
                    image: NetworkImage(
                      AppConstants.BASE_URL +
                          AppConstants.UPLOAD +
                          products.img!,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              //text container
              Expanded(
                child: Container(
                  height: Dimensions.listViewTextContSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(Dimensions.radius20),
                      bottomRight: Radius.circular(Dimensions.radius20),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: Dimensions.width10,
                      left: Dimensions.width10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BigText(text: products.name!),
                        SizedBox(height: Dimensions.height10),
                        SmallText(
                          text: products.description!,
                          maxlines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: Dimensions.height10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconAndText(
                              icon: Icons.circle_sharp,
                              text: 'Normal',
                              iconColor: AppColors.iconColor1,
                            ),
                            IconAndText(
                              icon: Icons.location_on,
                              text: '1.7km',
                              iconColor: AppColors.mainColor,
                            ),
                            IconAndText(
                              icon: Icons.access_time_sharp,
                              text: '32min',
                              iconColor: AppColors.iconColor2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
