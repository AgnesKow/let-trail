import 'package:flutter/material.dart';
import 'package:letstrail/utils/utils_exporter.dart';

class RoundIconButton extends StatelessWidget {
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  final Color? iconColor, cardColor;
  final Widget? customChild;
  final VoidCallback? onPressed;

  const RoundIconButton({
    Key? key,
    this.icon,
    this.padding,
    this.iconColor,
    this.cardColor,
    this.customChild,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor ?? AppColors.appWhiteColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (cardColor == null)
                  ? AppColors.appGreyColor.withOpacity(0.5)
                  : cardColor!.withOpacity(0.35),
              blurRadius: 5,
              spreadRadius: 5,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        padding: padding ?? const EdgeInsets.all(10.0),
        child: customChild ??
            Icon(
              icon,
              color: iconColor ?? AppColors.appGreyColor,
            ),
      ),
    );
  }
}
