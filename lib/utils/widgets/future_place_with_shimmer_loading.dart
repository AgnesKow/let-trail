import 'package:flutter/material.dart';
import 'package:letstrail/models/models_exporter.dart';

import '../utils_exporter.dart';

class FuturePlaceWithShimmerLoading extends StatelessWidget {
  final Future<List<PlaceModel>>? future;
  final String? themeID;

  const FuturePlaceWithShimmerLoading({
    Key? key,
    this.themeID,
    this.future,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlaceModel>>(
      future: future ?? ApiRequests.getPlacesOfTheme(themeID!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return PlaceCardShimmer();
        if (snapshot.data!.length == 0)
          return NoRecordsAvailable(
            title: "No records available",
            description:
                "Start interacting with application to get things going",
          );
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data?.length,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            PlaceModel place = snapshot.data![index];
            return FutureBuilder<ThemeModel>(
                future: ApiRequests.getThemeByID(place.themeId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return PlaceCardShimmer();
                  ThemeModel theme = snapshot.data!;
                  return PlaceCard(
                    place: place,
                    theme: theme,
                  );
                });
          },
        );
      },
    );
  }
}
