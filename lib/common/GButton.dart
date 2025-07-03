import 'package:flutter/material.dart';
import '../utils/constant/app_test_style.dart';
import '../utils/constant/colors.dart';
import '../utils/device/device_utility.dart';

enum AButtonType { primary, outlined, text, social }

class AButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AButtonType buttonType;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final String? prefixImagePath;
  final double? prefixImageWidth;
  final double? prefixImageHeight;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;

  const AButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonType = AButtonType.primary,
    this.width,
    this.height = 48.0,
    this.borderRadius,
    this.prefixImagePath,
    this.prefixImageWidth = 24.0,
    this.prefixImageHeight = 24.0,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.w600,
    this.padding,
  });

  bool get isDisabled => onPressed == null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final bool isDark = ADeviceUtils.isDarkMode(context);
    final radius = borderRadius ?? BorderRadius.circular(10);

    switch (buttonType) {
      case AButtonType.primary:
        return _buildPrimaryButton(context, isDark, radius);
      case AButtonType.outlined:
        return _buildOutlinedButton(context, isDark, radius);
      case AButtonType.text:
        return _buildTextButton(context, isDark, radius);
      case AButtonType.social:
        return _buildSocialButton(context, isDark, radius);
    }
  }

  Widget _buildPrimaryButton(
    BuildContext context,
    bool isDark,
    BorderRadius radius,
  ) {
    return GestureDetector(
      onTap: (isLoading || isDisabled) ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: _getPrimaryBackgroundColor(isDark),
          borderRadius: radius,
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color: (backgroundColor ?? AColors.primary).withOpacity(
                      0.3,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        child: _buildButtonContent(isDark),
      ),
    );
  }

  Widget _buildOutlinedButton(
    BuildContext context,
    bool isDark,
    BorderRadius radius,
  ) {
    return GestureDetector(
      onTap: (isLoading || isDisabled) ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: radius,
          border: Border.all(color: _getOutlinedBorderColor(isDark), width: 1),
        ),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        child: _buildButtonContent(isDark),
      ),
    );
  }

  Widget _buildTextButton(
    BuildContext context,
    bool isDark,
    BorderRadius radius,
  ) {
    return GestureDetector(
      onTap: (isLoading || isDisabled) ? null : onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 30,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: radius,
        ),
        padding: padding ?? EdgeInsets.zero,
        child: _buildButtonContent(isDark),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    bool isDark,
    BorderRadius radius,
  ) {
    return GestureDetector(
      onTap: (isLoading || isDisabled) ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: radius,
          border: Border.all(color: _getSocialBorderColor(isDark), width: 1),
        ),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 12),
        child: _buildButtonContent(isDark),
      ),
    );
  }

  Widget _buildButtonContent(bool isDark) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              textColor ??
                  (buttonType == AButtonType.primary
                      ? Colors.white
                      : AColors.primary),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (prefixImagePath != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isDisabled ? 0.5 : 1.0,
              child: Image(
                image: AssetImage(prefixImagePath!),
                width: prefixImageWidth,
                height: prefixImageHeight,
              ),
            ),
          ),
        Flexible(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: AappTextStyle.roboto(
              color: textColor ?? _getDefaultTextColor(isDark),
              fontSize: fontSize ?? 16.0,
              weight: fontWeight ?? FontWeight.w400,
            ),
            child: Text(text, textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }

  Color _getPrimaryBackgroundColor(bool isDark) {
    if (isDisabled) {
      return isDark ? Colors.grey[800]! : Colors.grey[300]!;
    }
    return backgroundColor ?? AColors.primary;
  }

  Color _getOutlinedBorderColor(bool isDark) {
    if (isDisabled) {
      return isDark ? Colors.grey[700]! : Colors.grey[400]!;
    }
    return backgroundColor ?? AColors.primary;
  }

  Color _getSocialBorderColor(bool isDark) {
    if (isDisabled) {
      return isDark ? Colors.grey[700]! : Colors.grey[400]!;
    }
    return backgroundColor ??
        (isDark ? Colors.grey.shade600 : Colors.grey.shade300);
  }

  Color _getDefaultTextColor(bool isDark) {
    if (isDisabled) {
      switch (buttonType) {
        case AButtonType.primary:
          return isDark ? Colors.grey[500]! : Colors.grey[600]!;
        case AButtonType.outlined:
        case AButtonType.text:
          return isDark ? Colors.grey[600]! : Colors.grey[500]!;
        case AButtonType.social:
          return isDark ? Colors.grey[600]! : Colors.grey[500]!;
      }
    }

    switch (buttonType) {
      case AButtonType.primary:
        return Colors.white;
      case AButtonType.outlined:
      case AButtonType.text:
        return AColors.primary;
      case AButtonType.social:
        return isDark ? AColors.lightGray100 : AColors.darkGray900;
    }
  }
}
