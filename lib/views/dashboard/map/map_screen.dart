import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letstrail/models/place_model.dart';
import 'package:letstrail/models/places_colors_model.dart';
import 'package:letstrail/models/theme_model.dart';
import 'package:letstrail/utils/utils_exporter.dart';
import 'package:letstrail/views/views_exporter.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:shimmer/shimmer.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  ScrollController _scrollController = new ScrollController();
  late PolylineResult result;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: Common.mapDefaultZoom,
  );

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  LatLng? _currentLocation;

  List<PlaceModel> nearbyPlaces = [];

  final Marker _polyLineOrigin = Marker(
    markerId: const MarkerId("polyLineOrigin"),
    position: const LatLng(37.42796133580664, -122.085749655962),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    infoWindow: const InfoWindow(
      title: "Royal Thai Embassy",
      snippet:
          "It is a long established fact that a reader will be distracted by the readable",
    ),
  );

  final Marker _polyLineDestination = Marker(
    markerId: const MarkerId("polyLineDestination"),
    position: const LatLng(37.4221516, -122.1082121),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    infoWindow: const InfoWindow(
      title: "Royal Thai Embassy",
      snippet:
          "It is a long established fact that a reader will be distracted by the readable",
    ),
  );

  bool _isLoading = true;

  @override
  void initState() {
    // get user current location
    getCurrentLocation();
    // get places near user location in radius of kilometers
    super.initState();
  }

  void getCurrentLocationAndReArrangeMarkerPosition() async {
    await ApiRequests.determinePosition(context).then((value) async {
      // get all places and then filter the places which are in range and show it to user.
      await animateToPointer(LatLng(value.latitude, value.longitude));
    });
  }

  Future<void> animateToPointer(
    LatLng latLng, {
    bool displayMarker = true,
    String markerID = "current_location",
    String markerTitle = "My Location",
  }) async {
    print(latLng);
    _currentLocation = latLng;
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: Common.mapDefaultZoom,
        ),
      ),
    );

    nearbyPlaces = await ApiRequests.getNearbyPlaces(_currentLocation!);
    nearbyPlaces.forEach((place) {
      LatLng _latLng =
          LatLng(place.coordinate.latitude, place.coordinate.longitude);
      Common.placesAndColors.forEach((placeAndColor) {
        if (placeAndColor.themeId == place.themeId) {
          addMarker(
            place.id,
            _latLng,
            place.name,
            placeAndColor.markerColor,
            description: place.description,
          );
        }
      });
    });

    // code for displaying poly-lines for different themes
    // List<PlacesAndColorsModel> _markersAddedPlaces = [];
    // Common.placesAndColors.forEach((placeAndColor) {
    //   if (!_markersAddedPlaces.contains(placeAndColor)) {
    //     List<PlaceModel> placesOfTheme = [];
    //     _markersAddedPlaces.add(placeAndColor);
    //     print("Adding $placeAndColor");
    //
    //     nearbyPlaces.forEach((place) {
    //       if (!placesOfTheme.contains(place)) {
    //         // adding this place to theme route
    //         if (place.themeId == placeAndColor.themeId) {
    //           placesOfTheme.add(place);
    //         }
    //       }
    //     });
    //
    //     // List<PolylineWayPoint> polylinesWayPoints = [];
    //     // placesOfTheme.forEach((place) {
    //     //   polylinesWayPoints.add(PolylineWayPoint(
    //     //       location:
    //     //           "${place.coordinate.latitude}%2${place.coordinate.longitude},"));
    //     // });
    //     // print(placesOfTheme.length);
    //     _displayPolyline(
    //       PointLatLng(
    //         placesOfTheme.first.coordinate.latitude,
    //         placesOfTheme.first.coordinate.longitude,
    //       ),
    //       PointLatLng(
    //         placesOfTheme.last.coordinate.latitude,
    //         placesOfTheme.last.coordinate.longitude,
    //       ),
    //       placeAndColor,
    //     );
    //   }
    // });

    if (displayMarker) {
      addMarker(markerID, latLng, markerTitle, BitmapDescriptor.hueGreen);
    }

    _isLoading = false;
    setState(() {});
  }

  void addMarker(
      String markerID, LatLng latLng, String markerTitle, double markerColor,
      {String? description}) {
    _markers[MarkerId(markerID)] = Marker(
      markerId: MarkerId(markerID),
      position: latLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(markerColor),
      infoWindow: InfoWindow(title: markerTitle, snippet: description),
    );
  }

  void getCurrentLocation() async {
    await ApiRequests.determinePosition(context).then((value) async {
      await animateToPointer(LatLng(value.latitude, value.longitude));
    });
  }

  void _displayPolyline(
      PointLatLng origin,
      PointLatLng destination,
      // List<PolylineWayPoint> points,
      PlacesAndColorsModel placesAndColors) async {
    print("---  DRAWING POLYLINE  ---");
    PolylinePoints polylinePoints = PolylinePoints();
    result = await polylinePoints.getRouteBetweenCoordinates(
      Common.googleMapAPIKey,
      origin,
      destination,
      // wayPoints: points,
    );
    for (var point in result.points) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    }
    _addPolyLine(polylineCoordinates, placesAndColors);
  }

  void _addPolyLine(
      List<LatLng> polyLineCoOrdinates, PlacesAndColorsModel placesAndColors) {
    Polyline polyline = Polyline(
      consumeTapEvents: true,
      onTap: () {
        print("${placesAndColors.themeId} tapped");
      },
      polylineId: PolylineId(placesAndColors.themeId),
      color: placesAndColors.polylineColor,
      points: polylineCoordinates,
      width: 6,
    );
    polylines[PolylineId(placesAndColors.themeId)] = polyline;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            markers: _markers.values.toSet(),
            zoomControlsEnabled: false,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            polylines: Set<Polyline>.of(polylines.values),
            initialCameraPosition: _cameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            top: 20.0,
            right: 20.0,
            child: SafeArea(
              child: Column(
                children: [
                  RoundIconButton(
                    icon: CupertinoIcons.bell_slash_fill,
                    iconColor: AppColors.appWhiteColor,
                    cardColor: Colors.orange[700],
                    onPressed: () => Common.showTwoButtonDialog(
                      context: context,
                      dialogMessage:
                          "Do you want to allow notification when you are near a heritage trail or route?",
                      primaryButtonText: "Yes",
                      secondaryButtonText: "Not now",
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  RoundIconButton(
                    icon: CupertinoIcons.location_fill,
                    cardColor: AppColors.appBlueColor,
                    iconColor: AppColors.appWhiteColor,
                    onPressed: () =>
                        getCurrentLocationAndReArrangeMarkerPosition(),
                  ),
                  const SizedBox(height: 20.0),
                  RoundIconButton(
                    icon: CupertinoIcons.info,
                    cardColor: AppColors.appGreyColor.withOpacity(0.56),
                    iconColor: AppColors.appWhiteColor,
                    onPressed: () => Common.showOnePrimaryButtonDialog(
                      title: "How to use icons",
                      context: context,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          infoPromptItem(
                            icon: CupertinoIcons.info,
                            header: "Instructions",
                            description: "Explain how the application works.",
                          ),
                          infoPromptItem(
                            icon: CupertinoIcons.location_fill,
                            iconColor: AppColors.appBlueColor,
                            header: "Locate",
                            description:
                                "Locate yourself and look around for nearest heritage spots.",
                          ),
                          infoPromptItem(
                            icon: CupertinoIcons.bell_fill,
                            iconColor: Colors.orange,
                            header: "Notification",
                            description:
                                "A notification will pop-up when you are near a heritage spot.",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 20.0,
            left: 20.0,
            child: SafeArea(
              child: Row(
                children: [
                  // todo: add journal button here
                  RoundIconButton(
                    icon: Icons.menu_sharp,
                    onPressed: () =>
                        Common.drawerScaffoldKey.currentState!.openDrawer(),
                  ),
                  _isLoading
                      ? const SizedBox(width: 20.0)
                      : const SizedBox.shrink(),
                  _isLoading
                      ? RoundIconButton(
                          customChild: lottie.Lottie.asset(
                            "${Common.assetsAnimations}loading.json",
                            width: 60.0,
                          ),
                          padding: EdgeInsets.zero,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 80.0,
            left: 0.0,
            right: 0.0,
            child: _currentLocation == null
                ? const SizedBox.shrink()
                : SafeArea(
                    child: SizedBox(
                      height: 230.0,
                      child: (nearbyPlaces.isEmpty && _isLoading)
                          ? ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(
                                  left: 8.0, top: 10.0, bottom: 10.0),
                              physics: const BouncingScrollPhysics(),
                              itemCount: 5,
                              itemBuilder: (BuildContext context, int index) {
                                return TrailShimmer(
                                  isFirstOfList: (index == 0),
                                );
                              },
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                top: 10.0,
                                bottom: 10.0,
                              ),
                              physics: const BouncingScrollPhysics(),
                              itemCount: nearbyPlaces.length,
                              itemBuilder: (BuildContext context, int index) {
                                PlaceModel _place = nearbyPlaces[index];
                                return TrailCard(
                                  isFirstOfList: (index == 0),
                                  place: _place,
                                );
                              },
                            ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget infoPromptItem({
    required IconData icon,
    required String header,
    required String description,
    Color? iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                header,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5.0),
        Text(
          description,
          style: const TextStyle(
            color: AppColors.textColor,
            fontSize: 13.0,
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}

class TrailShimmer extends StatelessWidget {
  final bool isFirstOfList;
  const TrailShimmer({
    Key? key,
    required this.isFirstOfList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.only(
        right: 10.0,
        left: isFirstOfList ? 15.0 : 0.0,
      ),
      width: 185,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: AppColors.appWhiteColor,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(15.0),
                          topLeft: Radius.circular(15.0),
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 15.0,
                  right: 15.0,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade400,
                    highlightColor: AppColors.appWhiteColor,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                left: 10.0,
                right: 10.0,
                bottom: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: AppColors.appWhiteColor,
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: AppColors.appWhiteColor,
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: AppColors.appWhiteColor,
                        child: Container(
                          width: 90,
                          height: 10,
                          decoration: BoxDecoration(color: Colors.white),
                        ),
                      ),
                      Spacer(),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: AppColors.appWhiteColor,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: AppColors.appWhiteColor,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: AppColors.appWhiteColor,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrailCard extends StatefulWidget {
  final bool isFirstOfList;
  final PlaceModel place;

  const TrailCard({
    Key? key,
    required this.place,
    required this.isFirstOfList,
  }) : super(key: key);

  @override
  State<TrailCard> createState() => _TrailCardState();
}

class _TrailCardState extends State<TrailCard> {
  ThemeModel? theme;

  @override
  void initState() {
    getTheme();
    super.initState();
  }

  void getTheme() async {
    theme = await ApiRequests.getThemeByID(widget.place.themeId);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => theme == null
          ? null
          : Common.push(
              context,
              PlaceDetailScreen(
                place: widget.place,
                theme: theme!,
              ),
            ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.appWhiteColor,
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.6),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.appGreyColor.withOpacity(0.45),
              blurRadius: 6,
              spreadRadius: 6,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        margin: EdgeInsets.only(
          right: 10.0,
          left: widget.isFirstOfList ? 15.0 : 0.0,
        ),
        width: 185,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        topLeft: Radius.circular(15.0),
                      ),
                      child: Image.network(
                        widget.place.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15.0,
                    right: 15.0,
                    child: StreamLikedWidget(
                      place: widget.place,
                      theme: theme,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                  left: 5.0,
                  right: 2.0,
                  bottom: 5.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.place.name,
                      style: TextStyle(
                        color: AppColors.appBlackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    theme == null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                              vertical: 5.0,
                            ),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: AppColors.appWhiteColor,
                              child: Container(
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : Text(
                            theme!.travelInformation,
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 12.0,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: theme == null
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: AppColors.appWhiteColor,
                                  child: Container(
                                    width: 90,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  theme!.title,
                                  style: TextStyle(
                                    color: AppColors.appBlueColor,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        PlaceInteractIcon(
                          icon: Icons.info_outline,
                          isWebsiteIcon: true,
                          url: widget.place.website,
                          color: AppColors.appGreyColor,
                          isGlassTheme: false,
                        ),
                        const SizedBox(width: 5.0),
                        PlaceInteractIcon(
                          icon: Icons.directions_outlined,
                          isDirectionsIcon: true,
                          color: AppColors.appGreyColor,
                          lat: widget.place.coordinate.latitude,
                          lang: widget.place.coordinate.longitude,
                          isGlassTheme: false,
                        ),
                        const SizedBox(width: 5.0),
                        FutureBuilder<bool>(
                          future: ApiRequests.isPlaceAlreadyVisited(
                              widget.place.id),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return CupertinoActivityIndicator();
                            return (snapshot.data!)
                                ? const SizedBox.shrink()
                                : PlaceInteractIcon(
                                    icon: Icons.pin_drop_outlined,
                                    isVisitedIcon: true,
                                    color: AppColors.appGreyColor,
                                    heritageTrailID: widget.place.trailId,
                                    theme: theme,
                                    place: widget.place,
                                  );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
