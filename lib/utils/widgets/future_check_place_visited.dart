import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letstrail/models/models_exporter.dart';
import 'package:letstrail/utils/api_service/api_service_exporter.dart';
import 'package:letstrail/utils/widgets/widgets_exporter.dart';

import '../app_colors.dart';

class FutureCheckPlaceVisited extends StatelessWidget {
  final PlaceModel place;
  final ThemeModel theme;
  final Color? color;

  const FutureCheckPlaceVisited({
    Key? key,
    required this.place,
    required this.theme,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: ApiRequests.isPlaceAlreadyVisited(place.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return PlaceInteractIcon(
            child: CupertinoActivityIndicator(),
            icon: Icons.circle,
            isVisitedIcon: true,
            color: color ?? AppColors.appWhiteColor,
          );
        return (snapshot.data!)
            ? const SizedBox.shrink()
            : PlaceInteractIcon(
                icon: Icons.pin_drop,
                isVisitedIcon: true,
                color: AppColors.appWhiteColor,
                heritageTrailID: place.trailId,
                theme: theme,
                place: place,
              );
      },
    );
  }
}
