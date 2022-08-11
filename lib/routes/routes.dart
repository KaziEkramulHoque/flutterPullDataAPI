import 'package:get/get.dart';
import 'package:pillar_test/pages/pageOne.dart';
import 'package:pillar_test/pages/pageTwo.dart';

class RoutesClass {
  static String pageOne = "/pages/pageOne";
  static String pageTwo = "/pages/pageTwo";

  static String getPageOneRoute() => pageOne;
  static String getPageTwoRoute() => pageTwo;

  static List<GetPage> routes = [
    GetPage(
        name: pageOne,
        page: () => PageOne(),
        transition: Transition.fade,
        transitionDuration: const Duration(seconds: 1)),
    GetPage(
        name: pageTwo,
        page: () => PageTwo(),
        transition: Transition.fade,
        transitionDuration: const Duration(seconds: 1)),
  ];
}
