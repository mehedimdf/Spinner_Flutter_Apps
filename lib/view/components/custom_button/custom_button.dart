import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors/app_colors.dart';
import '../custom_image/custom_image.dart';
import '../custom_text/custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.height = 54,
    this.width = double.maxFinite,
    required this.onTap,
    this.title = '',
    this.marginVertical = 0,
    this.marginHorizontal = 0,
    this.fillColor = AppColors.red,
    this.textColor = AppColors.white,
    this.isBorder = false,
    this.fontSize,
    this.borderWidth,
    this.borderRadius,
    this.borderColor =AppColors.primary,
    this.showSocialButton = false,
    this.imageSrc,
    this.fontWeight,
  });

  final double height;
  final double? width;
  final Color? fillColor;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onTap;
  final String title;
  final double marginVertical;
  final double marginHorizontal;
  final bool isBorder;
  final double? fontSize;
  final double? borderWidth;
  final double? borderRadius;
  final bool showSocialButton;
  final String? imageSrc;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0.h),
        margin: EdgeInsets.symmetric(
            vertical: marginVertical, horizontal: marginHorizontal),
        alignment: Alignment.center,
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: isBorder
              ? Border.all(color: borderColor, width: borderWidth ?? .05)
              : null,
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          color: fillColor,
        ),
        child: showSocialButton ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImage(imageSrc: imageSrc ?? ""),
            CustomText(
              left: 8,
              fontSize: fontSize ?? 16.sp,
              fontWeight: fontWeight ?? FontWeight.w400,
              color: textColor,
              textAlign: TextAlign.center,
              text: title,

            ),
          ],
        ) : CustomText(
          fontSize: fontSize ?? 18.sp,
          fontWeight: FontWeight.w500,
          color: textColor,
          textAlign: TextAlign.center,
          text: title,
        ),
      ),
    );
  }
}
