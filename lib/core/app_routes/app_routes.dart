// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';

import '../../view/screens/customize_screen/customize_screen.dart';
import '../../view/screens/game_over_screen/game_over_screen.dart';
import '../../view/screens/gift_screen/gift_screen.dart';
import '../../view/screens/spin_screen/spin_screen.dart';
import '../../view/screens/splash_screen/splash_screen.dart';
import '../../view/screens/start_screen/start_screen.dart';

class AppRoutes {
  ///=========================== Screen Routes ==========================
  static const String startScreen = "/StartScreen";
  static const String spinScreen = "/SpinScreen";
  static const String giftScreen = "/GiftScreen";
  static const String gameOverScreen = "/GameOverScreen";
  static const String splashScreen = "/SplashScreen";
  static const String customizeScreen = "/CustomizeScreen";



  static List<GetPage> routes = [
    ///=========================== Screen Routes  ==========================
    GetPage(name: startScreen, page: () => StartScreen()),
    GetPage(
      name: AppRoutes.spinScreen,
      page: () {
        final args = Get.arguments as String? ?? ''; // null-safe
        return SpinScreen(backgroundImage: args);
      },
    ),
    GetPage(name: giftScreen, page: () => GiftScreen()),
    //GetPage(name: gameOverScreen, page: () => GameOverScreen(rewardPoints: null,)),
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: customizeScreen, page: () => CustomizeScreen()),


  ];
}
