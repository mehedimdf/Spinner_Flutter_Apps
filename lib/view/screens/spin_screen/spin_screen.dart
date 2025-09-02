/*
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../../utils/app_images/app_images.dart';
import '../../components/custom_image/custom_image.dart';
import '../../components/custom_text/custom_text.dart';
import '../game_over_screen/game_over_screen.dart';

class SpinScreen extends StatefulWidget {
  final String backgroundImage;
  final String wheelImage;

  const SpinScreen({
    super.key,
    required this.backgroundImage,
    required this.wheelImage,
  });

  @override
  State<SpinScreen> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinScreen> with SingleTickerProviderStateMixin {
  final selected = BehaviorSubject<int>();
  int rewards = 0;
  int totalRewards = 0;
  int remainingSpins = 3;
  int winCount = 0;

  late AnimationController _btnController;
  late Animation<double> _btnAnimation;

  final List<Map<String, dynamic>> candyItems = [
    {"image": AppImages.candy1, "point": 100},
    {"image": AppImages.candy5, "point": 200},
    {"image": AppImages.candy3, "point": 300},
    {"image": AppImages.candy4, "point": 400},
    {"image": AppImages.candy2, "point": 0},
  ];
  final String rewardsKey = 'total_rewards';

  @override
  void initState() {
    super.initState();
    _loadTotalRewards();

    // Spin button animation controller
    _btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.3,
    );
    _btnAnimation = CurvedAnimation(
      parent: _btnController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    selected.close();
    _btnController.dispose();
    super.dispose();
  }

  Future<void> _loadTotalRewards() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      totalRewards = prefs.getInt(rewardsKey) ?? 0;
    });
  }

  Future<void> _saveTotalRewards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(rewardsKey, totalRewards);
  }

  void spinWheel() {
    if (remainingSpins > 0) {
      selected.add(Fortune.randomInt(0, candyItems.length));
      setState(() {
        remainingSpins--;
      });
    } else {
      if (totalRewards >= 10) {
        setState(() {
          totalRewards -= 10;
        });
        _saveTotalRewards();
        Get.snackbar(
          "Spin Without Ticket",
          "10 points deducted from total rewards!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withValues(alpha: 0.3),
          colorText: Colors.black,
        );
      } else {
        Get.snackbar(
          "No Spins Left",
          "You don't have enough points to spin without tickets.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          colorText: Colors.black,
        );
      }
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // BG image
          Positioned.fill(
            child: loadImage(
             widget.backgroundImage,
              fit: BoxFit.cover,
              fallback: AppImages.customizeImageOne,


            ),
          ),
          // Top bar buttons
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
          // Tickets & Win Icons
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
          // Total Rewards
          Positioned(
            right: 40.w,
            top: 80.h,
            child: CustomText(
              text: "$totalRewards",
              color: const Color(0xffB6480B),
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          // Remaining spins
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
          // Current rewards
          Positioned(
            right: 70.w,
            top: 320.w,
            child: CustomText(
              text: "$rewards",
              color: const Color(0xffB6480B),
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          // Wheel & Button
          Positioned(
            top: size.height * 0.4 - 38.w,
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
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                       // bottom: 0,
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
                              totalRewards += rewards;
                              if (rewards > 0) winCount++;
                            });
                            _saveTotalRewards();

                            // Check for 3 wins
                            if (winCount >= 3) {
                              Get.to(() => GameOverScreen(rewardPoints: totalRewards));
                              return;
                            }

                            // If spins ended
                            if (remainingSpins == 0) {
                              if (rewards > 0) {
                                Get.to(() => GameOverScreen(rewardPoints: totalRewards));
                              } else {
                                Get.snackbar(
                                  "Better Luck Next Time",
                                  "You scored 0 points.",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                                  colorText: Colors.black,
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTapDown: (_) => _btnController.forward(), // press effect
                    onTapUp: (_) {
                      _btnController.reverse();
                      spinWheel();
                    },
                    child: AnimatedBuilder(
                      animation: _btnAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1 - _btnAnimation.value,
                          child: Opacity(
                            opacity: remainingSpins > 0 ? 1.0 : 0.4,
                            child: CustomImage(imageSrc: AppImages.spinButton),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Fortune Wheel

        ],
      ),

    );
  }
}

// class ImageLoader extends StatelessWidget {
//   final String? src;
//   final BoxFit fit;
//   final String? fallback;
//   final Widget? child;
//
//   // Constructor to initialize the widget with parameters
//   const ImageLoader({
//     Key? key,
//     required this.src,
//     this.fit = BoxFit.cover,
//     this.fallback,
//     this.child,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Widget image = src != null && src!.isNotEmpty
//         ? (src!.startsWith('http')
//         ? Image.network(src!, fit: fit)
//         : Image.asset(src!, fit: fit))
//         : Image.asset(fallback ?? 'assets/default_image.png', fit: fit);
//
//     // Wrap the image with the child if provided, otherwise just return the image.
//     return child != null
//         ? child! // If child is passed, apply it (like Center, Column)
//         : image;
//   }
// }*/

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../../utils/app_images/app_images.dart';
import '../../components/custom_image/custom_image.dart';
import '../../components/custom_text/custom_text.dart';
import '../game_over_screen/game_over_screen.dart';

class SpinScreen extends StatefulWidget {
  final String backgroundImage;
  final String wheelImage;

  const SpinScreen({
    super.key,
    required this.backgroundImage,
    required this.wheelImage,
  });

  @override
  State<SpinScreen> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinScreen> with SingleTickerProviderStateMixin {
  final selected = BehaviorSubject<int>();
  int rewards = 0;
  int totalRewards = 0;
  int remainingSpins = 3;
  int winCount = 0;

  late AnimationController _btnController;
  late Animation<double> _btnAnimation;

  final List<Map<String, dynamic>> candyItems = [
    {"image": AppImages.candy1, "point": 100},
    {"image": AppImages.candy5, "point": 200},
    {"image": AppImages.candy3, "point": 300},
    {"image": AppImages.candy4, "point": 400},
    {"image": AppImages.candy2, "point": 0},
  ];
  final String rewardsKey = 'total_rewards';

  @override
  void initState() {
    super.initState();
    _loadTotalRewards();

    _btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.3,
    );
    _btnAnimation = CurvedAnimation(
      parent: _btnController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    selected.close();
    _btnController.dispose();
    super.dispose();
  }

  Future<void> _loadTotalRewards() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      totalRewards = prefs.getInt(rewardsKey) ?? 0;
    });
  }

  Future<void> _saveTotalRewards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(rewardsKey, totalRewards);
  }

  void spinWheel() {
    if (remainingSpins > 0) {
      selected.add(Fortune.randomInt(0, candyItems.length));
      setState(() {
        remainingSpins--;
      });
    } else {
      if (totalRewards >= 10) {
        setState(() {
          totalRewards -= 10;
        });
        _saveTotalRewards();
        Get.snackbar(
          "Spin Without Ticket",
          "10 points deducted from total rewards!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.3),
          colorText: Colors.black,
        );
      } else {
        Get.snackbar(
          "No Spins Left",
          "You don't have enough points to spin without tickets.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white.withOpacity(0.2),
          colorText: Colors.black,
        );
      }
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          /// BG image
          Positioned.fill(
            child: loadImage(
              widget.backgroundImage,
              fit: BoxFit.cover,
              fallback: AppImages.customizeImageOne,
            ),
          ),

          /// Top bar
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

          /// Tickets & Win
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

          /// Total Rewards
          Positioned(
            right: 40.w,
            top: 80.h,
            child: CustomText(
              text: "$totalRewards",
              color: const Color(0xffB6480B),
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
            ),
          ),

          /// Remaining spins
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

          /// Current rewards
          Positioned(
            right: 70.w,
            top: 320.w,
            child: CustomText(
              text: "$rewards",
              color: const Color(0xffB6480B),
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),

          /// Wheel + Button
          Positioned(
            top: size.height * 0.44,
            left: 0,
            right: 0,
            child: Column(
              children: [
                /// Wheel
                SizedBox(
                  width: 300.w,
                  height: 300.w,
                  child: FortuneWheel(
                    selected: selected.stream,
                    animateFirst: false,
                    items: [
                      for (int i = 0; i < candyItems.length; i++)
                        FortuneItem(
                          child: CustomImage(
                            imageSrc: candyItems[i]["image"],
                            width: 50.w,
                            height: 50.w,
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
                        totalRewards += rewards;
                        if (rewards > 0) winCount++;
                      });
                      _saveTotalRewards();

                      if (winCount >= 3) {
                        Get.to(() => GameOverScreen(rewardPoints: totalRewards));
                        return;
                      }

                      if (remainingSpins == 0) {
                        if (rewards > 0) {
                          Get.to(() => GameOverScreen(rewardPoints: totalRewards));
                        } else {
                          Get.snackbar(
                            "Better Luck Next Time",
                            "You scored 0 points.",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            colorText: Colors.black,
                          );
                        }
                      }
                    },
                  ),
                ),

                const SizedBox(height: 20),

                /// Spin button
                GestureDetector(
                  onTapDown: (_) => _btnController.forward(),
                  onTapUp: (_) {
                    _btnController.reverse();
                    spinWheel();
                  },
                  child: AnimatedBuilder(
                    animation: _btnAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1 - _btnAnimation.value,
                        child: Opacity(
                          opacity: remainingSpins > 0 ? 1.0 : 0.4,
                          child: CustomImage(imageSrc: AppImages.spinButton),
                        ),
                      );
                    },
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
