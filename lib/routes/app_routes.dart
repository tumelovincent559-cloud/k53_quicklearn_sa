import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/main_recipe_list_screen/main_recipe_list_screen.dart';
import '../presentation/recipe_detail_screen/recipe_detail_screen.dart';
import '../presentation/favorites_screen/favorites_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String mainRecipeList = '/main-recipe-list-screen';
  static const String recipeDetail = '/recipe-detail-screen';
  static const String favorites = '/favorites-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    mainRecipeList: (context) => const MainRecipeListScreen(),
    recipeDetail: (context) {
      final recipe =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return RecipeDetailScreen(recipe: recipe);
    },
    favorites: (context) => const FavoritesScreen(),
  };
}
