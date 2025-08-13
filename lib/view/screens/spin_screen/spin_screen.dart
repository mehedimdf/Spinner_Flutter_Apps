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
      selected.add(Fortune.randomInt(0,  candyItems.length));
      setState(() {
        remainingSpins--;
      });
    } else {
      // no spins left → deduct 10 points
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
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
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
            top: 320.h,
            child: CustomText(
              text: "$rewards",
              color: const Color(0xffB6480B),
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          // Wheel & Button
          Positioned(
            top: size.height * .4 - 40.h,
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
          Positioned(
            left: 0,
            right: 0,
            top: size.height * .5 - 40.h,
            child: SizedBox(
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
                      Get.to(() => GameOverScreen(rewardPoints: rewards));
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
          ),
        ],
      ),
    );
  }
}