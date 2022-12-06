import 'package:flutter/material.dart';
import 'package:letstrail/utils/utils_exporter.dart';
import 'package:lottie/lottie.dart';

class NoRecordsAvailable extends StatelessWidget {
  final String title, description;
  const NoRecordsAvailable({
    Key? key,
    this.title = "No publications available.",
    this.description =
        "Take first step and post journal for public to read and interact with",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            "${Common.assetsAnimations}explore.json",
            width: 120.0,
          ),
          Text(
            title,
            style: TextStyle(
              color: AppColors.appBlackColor,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            description,
            style: TextStyle(
              color: AppColors.appGreyColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
