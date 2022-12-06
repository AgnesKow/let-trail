import 'package:flutter/material.dart';

class CustomBottomCard extends StatelessWidget {
  final Widget child;
  final double? maximumHeight;
  final BorderRadiusGeometry? borderRadius;

  const CustomBottomCard({
    Key? key,
    required this.child,
    this.maximumHeight,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: maximumHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F6FA),
        borderRadius: borderRadius ??
            const BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: child,
    );
  }
}
