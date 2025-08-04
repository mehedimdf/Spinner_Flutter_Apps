import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../custom_image/custom_image.dart';
import '../custom_text/custom_text.dart';

class CustomRoyelAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? titleName;
  final String? rightIcon;
  final void Function()? rightOnTap;
  final bool leftIcon;
  final bool? showRightIcon;
  final Color? color;

  const CustomRoyelAppbar({
    super.key,
    this.titleName,
    this.showRightIcon = false,
    this.rightOnTap,
    this.color,
    this.rightIcon,
    required this.leftIcon,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 60,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,  // ADD THIS LINE
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      actions: showRightIcon == true
          ? [
        IconButton(
          onPressed: () {
            rightOnTap?.call();
          },
          icon: rightIcon == null
              ? const SizedBox()
              : CustomImage(imageSrc: rightIcon!, height: 32, width: 32),
        ),
        SizedBox(width: 10.w),
      ]
          : null,
      leading: leftIcon == true
          ? BackButton(color: color ?? AppColors.black)
          : null,
      title: CustomText(
        text: titleName ?? "",
        fontSize: 20.w,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.black,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
