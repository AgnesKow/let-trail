import 'package:flutter/material.dart';
import 'package:letstrail/utils/utils_exporter.dart';

class GlassmorphicBGImageCard extends StatelessWidget {
  final String imageURL, cardTitle, cardDescription;
  final Widget? belowChild, childOnly;
  final bool isAssetImage;
  final double titleSize, descriptionSize;
  final VoidCallback? onPressed;

  const GlassmorphicBGImageCard({
    Key? key,
    required this.imageURL,
    this.cardTitle = "Use `cardTitle` to set the title",
    this.cardDescription = "Use `cardDescription` to set the title",
    this.belowChild,
    this.childOnly,
    this.isAssetImage = true,
    this.titleSize = 18.0,
    this.descriptionSize = 14.0,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: isAssetImage
                  ? Image.asset(
                      imageURL,
                      fit: BoxFit.fill,
                    )
                  : Image.network(
                      imageURL,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            left: 10,
            child: GlassmorphismedWidget(
              padding: const EdgeInsets.all(10.0),
              child: childOnly ??
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        cardTitle,
                        style: TextStyle(
                          color: AppColors.appBlackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: titleSize,
                        ),
                      ),
                      const SizedBox(height: 2.5),
                      Text(
                        cardDescription,
                        style: TextStyle(
                          color: AppColors.appBlackColor,
                          fontSize: descriptionSize,
                        ),
                      ),
                      belowChild != null
                          ? belowChild!
                          : const SizedBox.shrink(),
                    ],
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
