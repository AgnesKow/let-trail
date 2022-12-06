import 'package:flutter/material.dart';
import 'package:letstrail/models/models_exporter.dart';
import 'package:letstrail/utils/utils_exporter.dart';
import 'package:letstrail/views/views_exporter.dart';

class PlaceCard extends StatelessWidget {
  final PlaceModel place;
  final ThemeModel theme;
  const PlaceCard({
    Key? key,
    required this.place,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Common.push(
        context,
        PlaceDetailScreen(
          place: place,
          theme: theme,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(right: 10.0),
        child: SizedBox(
          width: 360.0,
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                  child: Image.network(
                    place.imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                top: 20.0,
                left: 20.0,
                child: TileCard(
                  title: place.category,
                ),
              ),
              Positioned(
                right: 20.0,
                top: 10.0,
                child: Column(
                  children: [
                    PlaceInteractIcon(
                      url: place.website,
                      icon: Icons.info,
                      isWebsiteIcon: true,
                    ),
                    SizedBox(height: 5.0),
                    PlaceInteractIcon(
                      icon: Icons.directions,
                      isDirectionsIcon: true,
                      lat: place.coordinate.latitude,
                      lang: place.coordinate.longitude,
                    ),
                    const SizedBox(height: 5.0),
                    FutureCheckPlaceVisited(place: place, theme: theme),
                  ],
                ),
              ),
              Positioned(
                right: 10,
                left: 10,
                bottom: 10,
                child: GlassmorphismedWidget(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        place.name,
                        style: TextStyle(
                          color: AppColors.appWhiteColor,
                          fontSize: 16.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1.5),
                      Text(
                        place.description,
                        style: TextStyle(
                          color: AppColors.appWhiteColor.withOpacity(0.85),
                          fontSize: 13.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Cultural Style:",
                            style: TextStyle(
                              color: AppColors.appWhiteColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            "${place.cultureStyle} " +
                                Common.getEmojiFromCountryName(
                                    "${place.cultureStyle.toLowerCase()}"),
                            style: TextStyle(
                              color: AppColors.appWhiteColor.withOpacity(0.85),
                              fontSize: 14.0,
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
        ),
      ),
    );
  }
}
