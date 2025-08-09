import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../../utils/app_images/app_images.dart';
import '../../components/custom_image/custom_image.dart';
import '../../components/custom_text/custom_text.dart';
import '../game_over_screen/game_over_screen.dart';

class SpinScreen extends StatefulWidget {
  final String backgroundImage; // path or url
  final String wheelImage; // path or url

  const SpinScreen({
    super.key,
    required this.backgroundImage,
    required this.wheelImage,
  });

  @override
  State<SpinScreen> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinScreen> {
  final selected = BehaviorSubject<int>();
  int rewards = 0;
  int remainingSpins = 3;

  final List<Map<String, dynamic>> candyItems = [
    {"image": AppImages.candy1, "point": 100},
    {"image": AppImages.candy5, "point": 200},
    {"image": AppImages.candy3, "point": 300},
    {"image": AppImages.candy4, "point": 400},
    {"image": AppImages.candy2, "point": 0},
  ];

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  void spinWheel() {
    if (remainingSpins > 0) {
      selected.add(Fortune.randomInt(0, candyItems.length));
      setState(() {
        remainingSpins--;
      });
    } else {
      Get.snackbar(
        "No Spins Left",
        "You have used all your spins.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white.withValues(alpha: 0.2),
        colorText: Colors.black,
      );
    }
  }

  Widget loadImage(String? src, {BoxFit fit = BoxFit.cover, String? fallback}) {
    if (src != null && src.isNotEmpty) {
      if (src.startsWith('http')) {
        return Image.network(src, fit: fit);
      } else {
        return Image.asset(src, fit: fit);
      }
    }
    return Image.asset(fallback ?? AppImages.customizeImageOne, fit: fit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: loadImage(
              widget.backgroundImage,
              fit: BoxFit.cover,
              fallback: AppImages.customizeImageOne,
            ),
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
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.gameOverScreen);
                  },
                  child: CustomImage(imageSrc: AppImages.coins),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            top: 120.h,
            child: Column(
              children: [
                CustomImage(imageSrc: AppImages.ticketsImage),
                CustomImage(imageSrc: AppImages.winImage),
              ],
            ),
          ),
          Positioned(
            right: 80.w,
            top: 160.h,
            child: CustomText(
              text: "${remainingSpins}X",
              color: const Color(0xffB6480B),
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          Positioned(
            right: 70.w,
            top: 316.h,
            child: CustomText(
              text: "$rewards",
              color: const Color(0xffB6480B),
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          Positioned(
            top: 300.h,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClipOval(
                          child: loadImage(
                            widget.wheelImage,
                            fit: BoxFit.cover,
                            fallback: AppImages.wheelOne,
                          ),
                        ),
                      ),

                    ],
                  ),

                 // SizedBox(height: 50.h),
                  GestureDetector(
                    onTap: spinWheel,
                    child: Opacity(
                      opacity: remainingSpins > 0 ? 1.0 : 0.4,
                      child: CustomImage(imageSrc: AppImages.spinButton),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 380.h,
            child:  SizedBox(
              height: 240.h,
              child: FortuneWheel(
                selected: selected.stream,
                animateFirst: false,
                items: [
                  for (int i = 0; i < candyItems.length; i++)
                    FortuneItem(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomImage(
                            imageSrc: candyItems[i]["image"],
                            width: 50.w,
                            height: 50.w,
                          ),
                        ],
                      ),
                      style: FortuneItemStyle(
                        color: [
                          const Color(0xffff6646),
                          const Color(0xff006cb4),
                          const Color(0xff01b78f),
                          const Color(0xffffec83),
                          const Color(0xff4a4a4a),
                        ][i],
                        borderColor: Colors.transparent,
                      ),
                    ),
                ],
                onAnimationEnd: () {
                  setState(() {
                    rewards = candyItems[selected.value]["point"];
                  });

                  if (remainingSpins == 0) {
                    if (rewards > 0) {
                      Get.to(() => GameOverScreen(rewardPoints: rewards));
                    } else {
                      Get.snackbar(
                        "Better Luck Next Time",
                        "You scored 0 points.",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.orangeAccent,
                        colorText: Colors.white,
                      );
                    }
                  }
                },
              ),
            ),),
        ],
      ),
    );
  }
}
