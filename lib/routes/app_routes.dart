import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/road_signs_screen/road_signs_screen.dart';
import '../presentation/study_screen/study_screen.dart';
import '../presentation/quiz_screen/quiz_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String home = '/home-screen';
  static const String roadSigns = '/road-signs-screen';
  static const String study = '/study-screen';
  static const String quiz = '/quiz-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomeScreen(),
    splash: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    roadSigns: (context) => const RoadSignsScreen(),
    study: (context) => const StudyScreen(),
    quiz: (context) => const QuizScreen(),
  };
}
