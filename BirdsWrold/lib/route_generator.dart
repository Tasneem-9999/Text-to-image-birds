import 'package:flutter/material.dart';

import 'Screens/DetailsScreen.dart';
import 'Screens/Home.dart';
import 'Screens/OnboardingScreen.dart';
import 'Screens/SignUp.dart';
import 'Screens/SplashScreen.dart';
import 'Screens/LoginPage.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.MAIN_SCREEN:
        return MaterialPageRoute(builder: (_) => Home());
      case RouteNames.SPLASH_SCREEN:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case RouteNames.LOG_IN:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case RouteNames.SIGN_UP:
        return MaterialPageRoute(builder: (_) => SignUp());
      case RouteNames.DETAILS_SCREEN:
        return MaterialPageRoute(builder: (_) => DetailsScreen());
      case RouteNames.ON_BOARDING_SCREEN:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      default:
        return MaterialPageRoute(builder: (_) => Home());
    }
  }

}

class RouteNames {
  static const SPLASH_SCREEN = '/';
  static const MAIN_SCREEN = '/main';
  static const ON_BOARDING_SCREEN = '/OnboardingScreen';
  static const SIGN_UP = '/SignUp/main';
  static const LOG_IN = '/Login/main';
  static const DETAILS_SCREEN = '/main/DetailsScreen';

}
