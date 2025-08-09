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
  final List<String> backgroundImages = [
    AppImages.customizeImageOne,
    AppImages.customizeImageTwo,
    AppImages.customizeImageThree,
  ];

  final List<String> wheelImages = [
    AppImages.wheelOne,
    AppImages.wheelTwo,
    AppImages.wheelThree,
  ];

  int backgroundCurrentIndex = 0;
  int wheelCurrentIndex = 0;

  void _nextImage() {
    setState(() {
      backgroundCurrentIndex = (backgroundCurrentIndex + 1) % backgroundImages.length;
    });
  }

  void _previousImage() {
    setState(() {
      backgroundCurrentIndex =
          (backgroundCurrentIndex - 1 + backgroundImages.length) % backgroundImages.length;
    });
  }

  void nextWheel() {
    setState(() {
      wheelCurrentIndex = (wheelCurrentIndex + 1) % wheelImages.length;
    });
  }

  void previousWheel() {
    setState(() {
      wheelCurrentIndex =
          (wheelCurrentIndex - 1 + wheelImages.length) % wheelImages.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomImage(
            imageSrc: backgroundImages[backgroundCurrentIndex],
            width: size.width,
            height: size.height,
            boxFit: BoxFit.cover,
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 180.h,
            child: CustomImage(imageSrc: wheelImages[wheelCurrentIndex]),
          ),
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomImage(imageSrc: AppImages.customizeText),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 110.h,
            left: 20,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
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
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xffffc266),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.white, width: 5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: previousWheel,
                        icon: CustomImage(imageSrc: AppImages.arrowLeft),
                      ),
                      CustomImage(imageSrc: AppImages.wheelIcon),
                      CustomImage(imageSrc: AppImages.wheelText),
                      CustomImage(imageSrc: AppImages.coinIcon),
                      CustomText(
                        text: "150",
                        fontSize: 22.w,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xffB6480B),
                      ),
                      IconButton(
                        onPressed: nextWheel,
                        icon: CustomImage(imageSrc: AppImages.arrowRight),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 50.h,
            left: 0,
            child: GestureDetector(
              onTap: () {
                Get.toNamed(
                  AppRoutes.spinScreen,
                  arguments: {
                    'backgroundImage': backgroundImages[backgroundCurrentIndex],
                    'wheelImage': wheelImages[wheelCurrentIndex],
                  },
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

