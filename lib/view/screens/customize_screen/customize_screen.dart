import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spinner_apps/utils/app_colors/app_colors.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../../utils/app_images/app_images.dart';
import '../../components/custom_image/custom_image.dart';
import '../../components/custom_text/custom_text.dart';
import '../spin_screen/spin_screen.dart';

class CustomizeScreen extends StatefulWidget {
  const CustomizeScreen({super.key});

  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  // List of background images
  final List<String> _backgroundImages = [
    AppImages.customizeImageOne,
    AppImages.customizeImageTwo,
    AppImages.customizeImageThree,
  ];

  int _currentIndex = 0;

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _backgroundImages.length;
    });
  }

  void _previousImage() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _backgroundImages.length) %
          _backgroundImages.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background image that changes
          CustomImage(
            imageSrc: _backgroundImages[_currentIndex],
            width: size.width,
            height: size.height,
            boxFit: BoxFit.cover,
            fit: BoxFit.cover,
          ),
          Positioned(
              left: 20,
              right: 0,
              top: 120,
              bottom: 0,
              child: CustomImage(imageSrc: AppImages.Wheel)),
          Positioned(
            right: 10,
            top: 60.h,
            left: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: CustomImage(imageSrc: AppImages.arrowImage),
                ),
                const SizedBox()
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 150.h,
            left: 0,
            child: CustomText(
              text: "Customize",
              fontSize: 32.w,
              fontWeight: FontWeight.w900,
              color: AppColors.white,
            ),
          ),
          Positioned(
            right: 20,
            bottom: 130.h,
            left: 20,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xffffc266),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.white, width: 5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _previousImage,
                    icon: CustomImage(imageSrc: AppImages.arrowLeft),
                  ),
                  CustomImage(imageSrc: AppImages.imageIcon),
                  CustomImage(imageSrc: AppImages.BackgroundText),
                  CustomImage(imageSrc: AppImages.coinIcon),
                  CustomText(
                    text: "150",
                    fontSize: 22.w,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xffB6480B),
                  ),
                  IconButton(
                    onPressed: _nextImage,
                    icon: CustomImage(imageSrc: AppImages.arrowRight),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 70.h,
            left: 0,
            child: GestureDetector(
              onTap: () {
                Get.toNamed(
                  AppRoutes.spinScreen,
                  arguments: _backgroundImages[_currentIndex],
                );
              },
              child: CustomImage(imageSrc: AppImages.play, height: 50),
            ),
          ),
        ],
      ),
    );
  }
}
