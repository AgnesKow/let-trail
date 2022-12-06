import 'package:flutter/material.dart';
import 'package:letstrail/models/models_exporter.dart';
import 'package:letstrail/utils/utils_exporter.dart';

class PlaceInteractIcon extends StatefulWidget {
  final String? url, heritageTrailID, likedDocID;
  final PlaceModel? place;
  final ThemeModel? theme;
  final IconData icon;
  final Widget? child;
  final Color? color;
  final bool isWebsiteIcon,
      isDirectionsIcon,
      isVisitedIcon,
      isLikedIcon,
      isGlassTheme,
      isAlreadyLiked;
  final double? lat, lang;

  const PlaceInteractIcon({
    Key? key,
    required this.icon,
    this.color,
    this.url,
    this.heritageTrailID,
    this.likedDocID,
    this.lat,
    this.lang,
    this.child,
    this.place,
    this.theme,
    this.isWebsiteIcon = false,
    this.isDirectionsIcon = false,
    this.isVisitedIcon = false,
    this.isLikedIcon = false,
    this.isGlassTheme = true,
    this.isAlreadyLiked = false,
  }) : super(key: key);

  @override
  State<PlaceInteractIcon> createState() => _PlaceInteractIconState();
}

class _PlaceInteractIconState extends State<PlaceInteractIcon> {
  bool isPlaceMarkedVisited = false;
  @override
  Widget build(BuildContext context) {
    return (widget.isVisitedIcon && isPlaceMarkedVisited)
        ? const SizedBox.shrink()
        : InkWell(
            onTap: () => widget.isWebsiteIcon
                ? Common.launchURL(widget.url!)
                : widget.isDirectionsIcon
                    ? Common.openMap(context, widget.lat!, widget.lang!)
                    : widget.isVisitedIcon
                        ? markPlaceVisited()
                        : widget.isLikedIcon
                            ? widget.isAlreadyLiked
                                ? markPlaceUnLiked()
                                : markPlaceLiked()
                            : null,
            child: widget.isGlassTheme
                ? GlassmorphismedWidget(
                    padding: EdgeInsets.all(10.0),
                    child: widget.child ??
                        Icon(
                          widget.icon,
                          color: widget.color ?? AppColors.appWhiteColor,
                          size: 24.0,
                        ),
                  )
                : widget.child ??
                    Icon(
                      widget.icon,
                      color: widget.color ?? AppColors.appWhiteColor,
                      size: 20.0,
                    ),
          );
  }

  void markPlaceVisited() async {
    await ApiRequests.markPlaceAsVisited(
      widget.heritageTrailID!,
      widget.theme!.id,
      widget.place!.imageUrl,
      widget.place!.id,
      "Visited ${widget.place!.name}",
      "Part of ${widget.theme!.title} theme having culture of ${widget.place!.cultureStyle}",
      context,
    );
    isPlaceMarkedVisited = true;
    setState(() {});
  }

  void markPlaceLiked() async {
    await ApiRequests.markPlaceAsLiked(
      widget.heritageTrailID!,
      widget.theme!.id,
      widget.place!.id,
      context,
    );
  }

  void markPlaceUnLiked() async {
    await ApiRequests.markPlaceAsUnLiked(
      widget.heritageTrailID!,
      widget.theme!.id,
      widget.place!.id,
      widget.likedDocID!,
      context,
    );
  }
}
