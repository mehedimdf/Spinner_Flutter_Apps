// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';

import '../../view/screens/game_over_screen/game_over_screen.dart';
import '../../view/screens/gift_screen/gift_screen.dart';
import '../../view/screens/spin_screen/spin_screen.dart';
import '../../view/screens/start_screen/start_screen.dart';

class AppRoutes {
  ///=========================== Screen Routes ==========================
  static const String startScreen = "/StartScreen";
  static const String spinScreen = "/SpinScreen";
  static const String giftScreen = "/GiftScreen";
  static const String gameOverScreen = "/GameOverScreen";



  static List<GetPage> routes = [
    ///=========================== Screen Routes  ==========================
    GetPage(name: startScreen, page: () => StartScreen()),
    GetPage(name: spinScreen, page: () => SpinScreen()),
    GetPage(name: giftScreen, page: () => GiftScreen()),
    GetPage(name: gameOverScreen, page: () => GameOverScreen()),


  ];
}
