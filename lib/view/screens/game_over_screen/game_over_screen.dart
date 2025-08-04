import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../../utils/app_images/app_images.dart';
import '../../components/custom_image/custom_image.dart';
import '../../components/custom_text/custom_text.dart';
class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

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
                      //Get.toNamed(AppRoutes.gameOverScreen);
                    },
                    child: CustomImage(imageSrc: AppImages.ticketsImage)),
              ],
            ),
          ),
          Positioned(
            right: 0.w,
            left: 0.w,
            top: 440.h,
            child: CustomText(
              text: "\$ : 200",
              color: const Color(0xff208A9B),
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
