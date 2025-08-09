import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../../utils/app_images/app_images.dart';
import '../../components/custom_image/custom_image.dart';
import '../../components/custom_text/custom_text.dart';
class GameOverScreen extends StatelessWidget {
  final int rewardPoints;
  const GameOverScreen({super.key, required this.rewardPoints, });

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
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: CustomImage(imageSrc: AppImages.arrowImage),
                ),
                GestureDetector(
                    onTap: (){
                      Get.toNamed(AppRoutes.customizeScreen);
                    },
                    child: CustomImage(imageSrc: AppImages.setting, height: 50.h, width: 50.w)),
              ],
            ),
          ),
          Positioned(
            right: 0.w,
            left: 0.w,
            top: 440.h,
            child: CustomText(
              text: "300",
             // text:  "You won $rewardPoints points!",
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
                InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.startScreen);
                  },
                  child: CustomImage(imageSrc: AppImages.menuButton),
                ),
                GestureDetector(
                    onTap: (){
                      Get.toNamed(AppRoutes.spinScreen);
                    },
                    child: CustomImage(imageSrc: AppImages.restartButton)),
              ],
            ),
          ),
        ],
       ),


    );
  }
}
