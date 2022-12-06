import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letstrail/models/models_exporter.dart';
import 'package:letstrail/utils/utils_exporter.dart';

class PlaceDetailScreen extends StatefulWidget {
  final PlaceModel place;
  final ThemeModel theme;

  const PlaceDetailScreen({
    Key? key,
    required this.place,
    required this.theme,
  }) : super(key: key);

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  // flag to determine if the view is map enabled or image of location
  bool _isImageMode = true;

  CameraPosition? _kMap;
  final Completer<GoogleMapController> _controller = Completer();

  List<LocationInsights> locationInsights = [];

  @override
  void initState() {
    addMapLocation();
    addLocationInsights();
    super.initState();
  }

  void addMapLocation() {
    _kMap = CameraPosition(
      target: LatLng(
        widget.place.coordinate.latitude,
        widget.place.coordinate.longitude,
      ),
      zoom: Common.mapDefaultZoom,
    );
  }

  void addLocationInsights() {
    locationInsights = [
      LocationInsights(
        title: widget.theme.travelInformation,
        color: Colors.green,
        image: "${Common.assetsIcons}distance.png",
      ),
      LocationInsights(
        title: "Present in community of ${widget.place.cultureStyle}",
        color: Colors.red,
        image: "${Common.assetsIcons}community.png",
      ),
      LocationInsights(
        title:
            "Checkout the official website with the details of the location and history",
        color: const Color(0XFF57CEFB),
        image: "${Common.assetsIcons}web.png",
      ),
      LocationInsights(
        title:
            "Was discovered & Renovated in the year ${widget.place.year} and open for public",
        color: const Color(0XFFE6497E),
        image: "${Common.assetsIcons}year.png",
      ),
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.appWhiteColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: _orientation == Orientation.portrait ? 400.0 : 200.0,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: _isImageMode
                            ? Image.network(
                                widget.place.imageUrl,
                                height: 400,
                                width: _size.width,
                                fit: BoxFit.fill,
                              )
                            : SizedBox(
                                height: 400.0,
                                width: _size.width,
                                child: _kMap == null
                                    ? const SizedBox.shrink()
                                    : GoogleMap(
                                        mapType: MapType.normal,
                                        zoomControlsEnabled: false,
                                        myLocationButtonEnabled: false,
                                        myLocationEnabled: false,
                                        initialCameraPosition: _kMap!,
                                        onMapCreated:
                                            (GoogleMapController controller) {
                                          _controller.complete(controller);
                                        },
                                      ),
                              ),
                      ),
                      Positioned(
                        top: 50.0,
                        left: 25.0,
                        child: Tooltip(
                          message: "Go back",
                          child: InkWell(
                            onTap: () => Common.pop(context),
                            child: const GlassmorphismedWidget(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 12.0,
                              ),
                              child: Icon(
                                CupertinoIcons.chevron_back,
                                size: 24.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50.0,
                        right: 15.0,
                        child: Column(
                          children: [
                            StreamLikedWidget(
                              place: widget.place,
                              theme: widget.theme,
                            ),
                            const SizedBox(height: 5.0),
                            PlaceInteractIcon(
                              icon: Icons.info,
                              isWebsiteIcon: true,
                              url: widget.place.website,
                              color: _isImageMode
                                  ? AppColors.appWhiteColor
                                  : AppColors.appBlackColor,
                            ),
                            const SizedBox(height: 5.0),
                            PlaceInteractIcon(
                              icon: Icons.directions,
                              isDirectionsIcon: true,
                              color: _isImageMode
                                  ? AppColors.appWhiteColor
                                  : AppColors.appBlackColor,
                              lat: widget.place.coordinate.latitude,
                              lang: widget.place.coordinate.longitude,
                            ),
                            const SizedBox(height: 5.0),
                            FutureCheckPlaceVisited(
                              place: widget.place,
                              theme: widget.theme,
                              color: _isImageMode
                                  ? AppColors.appWhiteColor
                                  : AppColors.appBlackColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      margin: const EdgeInsets.only(bottom: 110.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              TileCard(
                                title: widget.place.category,
                                textColor: AppColors.appBlueColor,
                                borderRadius: 15.0,
                                bgColor:
                                    AppColors.appBlueColor.withOpacity(0.2),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            widget.place.name,
                            style: TextStyle(
                              color: AppColors.appBlackColor,
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2.5),
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.location,
                                color: AppColors.appGreyColor,
                                size: 16.0,
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                widget.place.address,
                                style: TextStyle(
                                  color: AppColors.appGreyColor,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15.0),
                          Text(
                            widget.place.description,
                            style: TextStyle(
                              color: AppColors.appGreyColor,
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          const Text(
                            "Location Insights",
                            style: TextStyle(
                              color: AppColors.appBlackColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          SizedBox(
                            height: MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? 180.0
                                : 120.0,
                            child: GridView.builder(
                              padding: EdgeInsets.zero,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                LocationInsights _locationInsight =
                                    locationInsights[index];
                                return TileCard(
                                  onPressed: () => _locationInsight.title
                                          .contains("website")
                                      ? Common.launchURL(widget.place.website)
                                      : null,
                                  bgColor:
                                      _locationInsight.color.withOpacity(0.1),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6.0,
                                    horizontal: 10.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        _locationInsight.image,
                                        width: 30.0,
                                        height: 30.0,
                                      ),
                                      const SizedBox(width: 20.0),
                                      Expanded(
                                        child: Text(
                                          _locationInsight.title,
                                          style: TextStyle(
                                            color: _locationInsight.color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    (MediaQuery.of(context).orientation ==
                                            Orientation.portrait)
                                        ? 2
                                        : 3,
                                childAspectRatio:
                                    _orientation == Orientation.portrait
                                        ? 2.3
                                        : 5.0,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 4.0,
                              ),
                              itemCount: locationInsights.length,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          const Text(
                            "Related Locations",
                            style: TextStyle(
                              color: AppColors.appBlackColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          SizedBox(
                            height: 350.0,
                            child: FuturePlaceWithShimmerLoading(
                                themeID: widget.theme.id),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 15,
            left: 15,
            right: 15,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.ashWhiteColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.only(
                bottom: 10.0,
                left: 15.0,
                right: 15.0,
                top: 15.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _isImageMode
                          ? "Image mode enabled. You can toggle between Image and Map mode."
                          : "Map mode enabled, You can toggle between Image and Map mode.",
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  PrimaryButton(
                    onPressed: () => _toggleMode(),
                    buttonText:
                        _isImageMode ? "View Map Mode" : "View Image Mode",
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 10.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleMode() {
    _isImageMode = !_isImageMode;
    setState(() {});
  }
}
