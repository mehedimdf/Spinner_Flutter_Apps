import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spinner_apps/core/app_routes/app_routes.dart';
import '../../../utils/app_images/app_images.dart';
import '../../components/custom_image/custom_image.dart';
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomImage(
            imageSrc: AppImages.startImage,
            width: size.width,
            height: size.height,
            boxFit: BoxFit.cover,
            fit: BoxFit.cover,
          ),
         Positioned(
             bottom: 20.h,
             left: 0,
             right: 0,
             child: InkWell(
               onTap: (){
                 Get.toNamed(AppRoutes.spinScreen);
               },
                 child: CustomImage(imageSrc: AppImages.startButton)),
         )
        ],
      ),
      

    );
  }
}
