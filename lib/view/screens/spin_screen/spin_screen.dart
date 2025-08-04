import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core/app_routes/app_routes.dart';
import '../../../utils/app_images/app_images.dart';
import '../../components/custom_image/custom_image.dart';
import '../../components/custom_text/custom_text.dart';

class SpinScreen extends StatefulWidget {
  const SpinScreen({Key? key}) : super(key: key);

  @override
  State<SpinScreen> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinScreen> {
  final selected = BehaviorSubject<int>();
  int rewards = 0;

  List<int> items = [
    100, 200, 300, 400, 500, 600, 700, 800, 1000, 2000
  ];

  @override
  void dispose() {
    selected.close();
    super.dispose();
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
              imageSrc: AppImages.spinImage2,
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
                  onTap: (){
                    Get.toNamed(AppRoutes.gameOverScreen);
                  },
                    child: CustomImage(imageSrc: AppImages.ticketsImage)),
              ],
            ),
          ),
          Positioned(
            right: 10,
            top: 150.h,
            child: CustomImage(imageSrc: AppImages.winImage),
          ),
          Positioned(
            right: 70.w,
            top: 270.h,
            child: CustomText(
              text: "\$ : $rewards",
              color: const Color(0xff208A9B),
              fontSize: 20.sp,
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
                      height: 260,
                      child: FortuneWheel(
                        selected: selected.stream,
                        animateFirst: false,
                        items: [
                          for (int i = 0; i < items.length; i++)
                            FortuneItem(
                              child: Text(
                                items[i].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                        ],
                        onAnimationEnd: () {
                          setState(() {
                            rewards = items[selected.value];
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 120.h),
                  GestureDetector(
                    onTap: () {
                      selected.add(Fortune.randomInt(0, items.length));
                    },
                    child: CustomImage(imageSrc: AppImages.spinButton),
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