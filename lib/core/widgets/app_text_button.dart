import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? buttonWidth;
  final double? buttonHeight;
  final String buttonText;
  final TextStyle textStyle;
  final VoidCallback onPressed;
  const AppTextButton({
    super.key,
    this.borderRadius,
    this.backgroundColor,
    this.horizontalPadding,
    this.verticalPadding,
    this.buttonHeight,
    this.buttonWidth,
    required this.buttonText,
    required this.textStyle,
    required this.onPressed,
    this.borderColor,
    this.icon,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 16.0),
              side: BorderSide(color: borderColor ?? Colors.white)),
        ),
        backgroundColor: WidgetStatePropertyAll(
          backgroundColor ?? Colors.white,
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 12,
            vertical: verticalPadding ?? 0,
          ),
        ),
        fixedSize: WidgetStateProperty.all(
          Size(buttonWidth ?? double.maxFinite, buttonHeight ?? 60),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center the text horizontally
        children: [
          Text(
            buttonText,
            style: textStyle,
          ),
          if (icon != null)
            Icon(
              icon,
              color: iconColor,
              size: iconSize,
            ),
        ],
      ),
    );
  }
}
