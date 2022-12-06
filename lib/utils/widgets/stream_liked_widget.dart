import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letstrail/models/models_exporter.dart';
import 'package:letstrail/utils/utils_exporter.dart';

class StreamLikedWidget extends StatelessWidget {
  final PlaceModel place;
  final ThemeModel? theme;
  const StreamLikedWidget({
    Key? key,
    required this.place,
    this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
      stream: ApiRequests.isPlaceAlreadyLiked(place.id),
      builder: (context, snapshot) {
        return theme == null
            ? CupertinoActivityIndicator()
            : Tooltip(
                message: "Add to wishlist",
                child: PlaceInteractIcon(
                  icon: !snapshot.hasData
                      ? CupertinoIcons.heart
                      : (snapshot.data.docs.length == 1)
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart,
                  child:
                      !snapshot.hasData ? CupertinoActivityIndicator() : null,
                  color: !snapshot.hasData
                      ? null
                      : (snapshot.data.docs.length == 1)
                          ? AppColors.primaryColor
                          : null,
                  isLikedIcon: true,
                  heritageTrailID: place.trailId,
                  theme: theme,
                  place: place,
                  isAlreadyLiked: !snapshot.hasData
                      ? false
                      : snapshot.data.docs.length == 1,
                  likedDocID: !snapshot.hasData
                      ? ""
                      : snapshot.data.docs.length == 0
                          ? ""
                          : snapshot.data.docs[0]["id"],
                ),
              );
      },
    );
  }
}
