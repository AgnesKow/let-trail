import 'package:flutter/material.dart';
import 'package:letstrail/utils/utils_exporter.dart';
import 'package:shimmer/shimmer.dart';

class PlaceCardShimmer extends StatelessWidget {
  const PlaceCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(
        right: 10.0,
      ),
      child: SizedBox(
        width: 360.0,
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
              top: 20.0,
              left: 20.0,
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
            Positioned(
              right: 20.0,
              top: 10.0,
              child: Column(
                children: [
                  GlassmorphismedWidget(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.info,
                      color: AppColors.appWhiteColor,
                      size: 24.0,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  GlassmorphismedWidget(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.directions,
                      color: AppColors.appWhiteColor,
                      size: 24.0,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  GlassmorphismedWidget(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.pin_drop,
                      color: AppColors.appWhiteColor,
                      size: 24.0,
                    ),
                  ),
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
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: AppColors.appWhiteColor,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade200,
                      highlightColor: AppColors.appWhiteColor,
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 5),
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
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: AppColors.appWhiteColor,
                          child: Container(
                            width: 90,
                            height: 10,
                            decoration: BoxDecoration(color: Colors.white),
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
    );
  }
}
