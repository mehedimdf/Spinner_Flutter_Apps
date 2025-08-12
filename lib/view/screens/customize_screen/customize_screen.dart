import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spinner_apps/utils/app_colors/app_colors.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../../utils/app_images/app_images.dart';
import '../../components/custom_image/custom_image.dart';
import '../../components/custom_text/custom_text.dart';

class CustomizeScreen extends StatefulWidget {
  const CustomizeScreen({super.key});

  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  late int rewardPoints;

  // Background data
  final List<String> backgroundImages = [
    AppImages.customizeImageOne,
    AppImages.customizeImageTwo,
    AppImages.customizeImageThree,
  ];
  final List<int> backgroundCosts = [0, 150, 300];
  List<bool> backgroundUnlocked = [true, false, false];

  // Wheel data
  final List<String> wheelImages = [
    AppImages.wheelOne,
    AppImages.wheelTwo,
    AppImages.wheelThree,
  ];
  final List<int> wheelCosts = [0, 200, 400];
  List<bool> wheelUnlocked = [true, false, false];

  int backgroundCurrentIndex = 0;
  int wheelCurrentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Arguments থেকে ডাটা নেওয়া
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    rewardPoints = args['rewardPoints'] ?? 0;
  }

  void _nextImage() {
    setState(() {
      backgroundCurrentIndex =
          (backgroundCurrentIndex + 1) % backgroundImages.length;
    });
  }

  void _previousImage() {
    setState(() {
      backgroundCurrentIndex =
          (backgroundCurrentIndex - 1 + backgroundImages.length) %
              backgroundImages.length;
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

  void _buyBackground() {
    int cost = backgroundCosts[backgroundCurrentIndex];
    if (rewardPoints >= cost) {
      setState(() {
        rewardPoints -= cost;
        backgroundUnlocked[backgroundCurrentIndex] = true;
      });
    } else {
      Get.snackbar("Error", "Not enough points to buy this background");
    }
  }

  void _buyWheel() {
    int cost = wheelCosts[wheelCurrentIndex];
    if (rewardPoints >= cost) {
      setState(() {
        rewardPoints -= cost;
        wheelUnlocked[wheelCurrentIndex] = true;
      });
    } else {
      Get.snackbar("Error", "Not enough points to buy this wheel");
    }
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
            top: 150.h,
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
                  onTap: () => Navigator.pop(context, rewardPoints),
                  child: CustomImage(imageSrc: AppImages.arrowImage),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      CustomImage(
                          imageSrc: AppImages.coinIcon, height: 20, width: 20),
                      SizedBox(width: 5.w),
                      CustomText(
                        text: "$rewardPoints",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 120.h,
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
                // Background Selection
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
                      if (!backgroundUnlocked[backgroundCurrentIndex])
                        ElevatedButton(
                          onPressed: _buyBackground,
                          child: const Text("Buy"),
                        ),
                      Row(
                        children: [
                          CustomImage(
                              imageSrc: AppImages.coinIcon,
                              height: 20,
                              width: 20),
                          SizedBox(width: 4.w),
                          CustomText(
                            text: "${backgroundCosts[backgroundCurrentIndex]}",
                            fontSize: 20.w,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xffB6480B),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: _nextImage,
                        icon: CustomImage(imageSrc: AppImages.arrowRight),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                // Wheel Selection
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
                      if (!wheelUnlocked[wheelCurrentIndex])
                        ElevatedButton(
                          onPressed: _buyWheel,
                          child: const Text("Buy"),
                        ),
                      Row(
                        children: [
                          CustomImage(
                              imageSrc: AppImages.coinIcon,
                              height: 20,
                              width: 20),
                          SizedBox(width: 4.w),
                          CustomText(
                            text: "${wheelCosts[wheelCurrentIndex]}",
                            fontSize: 20.w,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xffB6480B),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: nextWheel,
                        icon: CustomImage(imageSrc: AppImages.arrowRight),
                      ),
                    ],
                  ),
                ),
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
                    //'rewardPoints': rewardPoints,
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