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
  final String backgroundImage; // background image from CustomizeScreen

  const SpinScreen({Key? key, required this.backgroundImage}) : super(key: key);

  @override
  State<SpinScreen> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinScreen> {
  final selected = BehaviorSubject<int>();
  int rewards = 0;
  int remainingSpins = 3;

  final List<Map<String, dynamic>> candyItems = [
    {"image": AppImages.candy1, "point": 100},
    {"image": AppImages.candy5, "point": 0},
    {"image": AppImages.candy3, "point": 300},
    {"image": AppImages.candy4, "point": 400},
    {"image": AppImages.candy2, "point": 200},
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
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: CustomImage(
              imageSrc: widget.backgroundImage, // Set selected background
              width: size.width,
              height: size.height,
              boxFit: BoxFit.cover,
              fit: BoxFit.cover,
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
            bottom: 40.h,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffb40e6a), width: 10),
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                      height: 240,
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
                                  Color(0xffff6646),
                                  Color(0xff006cb4),
                                  Color(0xff01b78f),
                                  Color(0xffffec83),
                                  Color(0xff4a4a4a),
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
                    ),
                  ),
                  SizedBox(height: 120.h),
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
        ],
      ),
    );
  }
}