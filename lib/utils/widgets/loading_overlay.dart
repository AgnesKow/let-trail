import 'package:flutter/material.dart';

import '../utils_exporter.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Container(color: AppColors.appBlackColor.withOpacity(0.05)),
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.appBlueColor),
            ),
          ),
        ],
      ),
    );
  }
}
