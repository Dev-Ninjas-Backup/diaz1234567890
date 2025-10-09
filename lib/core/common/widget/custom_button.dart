import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double? width;
  final double? height;
  final FontWeight fontWeight;
  final double fontSize;
  final IconData? icon;
  final double iconSize;
  final Color? iconColor;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF006EF0),
    this.textColor = Colors.white,
    this.borderRadius = 10,
    this.width,
    this.height = 60,
    this.fontWeight = FontWeight.w600,
    this.fontSize = 16,
    this.icon,
    this.iconSize = 30,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width ?? 320,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: iconSize, color: iconColor ?? textColor),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
