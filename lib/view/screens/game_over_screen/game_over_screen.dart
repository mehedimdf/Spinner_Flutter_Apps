import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../../utils/app_images/app_images.dart';
import '../../components/custom_image/custom_image.dart';
import '../../components/custom_text/custom_text.dart';

class GameOverScreen extends StatefulWidget {
  final int rewardPoints;
  const GameOverScreen({super.key, required this.rewardPoints});

  /// Named route support
  static Widget fromRouteArguments() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    return GameOverScreen(
      rewardPoints: args['rewardPoints'] ?? 0,
    );
  }

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  double _arrowScale = 1.0;
  double _settingScale = 1.0;
  double _menuScale = 1.0;
  double _restartScale = 1.0;

  void _animateButton(Function onTap, String buttonType) {
    setState(() {
      if (buttonType == "arrow") _arrowScale = 0.85;
      if (buttonType == "setting") _settingScale = 0.85;
      if (buttonType == "menu") _menuScale = 0.85;
      if (buttonType == "restart") _restartScale = 0.85;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _arrowScale = 1.0;
        _settingScale = 1.0;
        _menuScale = 1.0;
        _restartScale = 1.0;
      });
      onTap();
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
            imageSrc: AppImages.gameOverImage,
            width: size.width,
            height: size.height,
            boxFit: BoxFit.cover,
            fit: BoxFit.cover,
          ),
          Positioned(
            right: 10,
            top: 60.h,
            left: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _animateButton(() => Navigator.pop(context), "arrow");
                  },
                  child: AnimatedScale(
                    scale: _arrowScale,
                    duration: const Duration(milliseconds: 100),
                    child: CustomImage(imageSrc: AppImages.arrowImage),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _animateButton(() {
                      Get.toNamed(
                        AppRoutes.customizeScreen,
                        arguments: {
                          'rewardPoints': widget.rewardPoints, // এখান দিয়ে পাঠানো হচ্ছে
                        },
                      );
                    }, "setting");
                  },
                  child: AnimatedScale(
                    scale: _settingScale,
                    duration: const Duration(milliseconds: 100),
                    child: CustomImage(
                      imageSrc: AppImages.setting,
                      height: 50.h,
                      width: 50.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0.w,
            left: 0.w,
            top: 440.h,
            child: CustomText(
              text: widget.rewardPoints.toString(),
              color: const Color(0xffB6480B),
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          Positioned(
            right: 20,
            bottom: 40.h,
            left: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _animateButton(() {
                      Get.toNamed(AppRoutes.startScreen);
                    }, "menu");
                  },
                  child: AnimatedScale(
                    scale: _menuScale,
                    duration: const Duration(milliseconds: 100),
                    child: CustomImage(imageSrc: AppImages.menuButton),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _animateButton(() {
                      Get.toNamed(AppRoutes.spinScreen);
                    }, "restart");
                  },
                  child: AnimatedScale(
                    scale: _restartScale,
                    duration: const Duration(milliseconds: 100),
                    child: CustomImage(imageSrc: AppImages.restartButton),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}