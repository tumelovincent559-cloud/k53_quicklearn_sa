import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/empty_state_widget.dart';
import './widgets/recipe_card_widget.dart';
import './widgets/search_bar_widget.dart';

/// Main Recipe List Screen - Primary hub for recipe discovery and browsing
/// Features: Search, categorization, favorites toggle, theme switching
class MainRecipeListScreen extends StatefulWidget {
  const MainRecipeListScreen({super.key});

  @override
  State<MainRecipeListScreen> createState() => _MainRecipeListScreenState();
}

class _MainRecipeListScreenState extends State<MainRecipeListScreen>
    with SingleTickerProviderStateMixin {
  // Controllers
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // State variables
  RecipeCategory _currentCategory = RecipeCategory.all;
  Set<int> _favoriteRecipeIds = {};
  bool _isDarkMode = false;
  String _searchQuery = '';
  List<Map<String, dynamic>> _filteredRecipes = [];

  // Mock recipe data
  final List<Map<String, dynamic>> _allRecipes = [
    {
      "id": 1,
      "title": "Classic Pancakes",
      "description": "Fluffy buttermilk pancakes perfect for breakfast",
      "category": "breakfast",
      "image": "https://images.unsplash.com/photo-1732984901763-01cd79444ae5",
      "semanticLabel":
          "Stack of golden brown pancakes topped with butter and maple syrup on white plate",
      "ingredients": [
        "2 cups all-purpose flour",
        "2 tablespoons sugar",
        "2 teaspoons baking powder",
        "1 teaspoon salt",
        "2 eggs",
        "1.5 cups buttermilk",
        "4 tablespoons melted butter"
      ],
      "steps": [
        "Mix dry ingredients in a large bowl",
        "Whisk eggs, buttermilk, and melted butter in another bowl",
        "Combine wet and dry ingredients until just mixed",
        "Heat griddle to medium heat and lightly grease",
        "Pour 1/4 cup batter for each pancake",
        "Cook until bubbles form, then flip and cook until golden",
        "Serve hot with maple syrup and butter"
      ]
    },
    {
      "id": 2,
      "title": "Avocado Toast",
      "description": "Healthy and delicious breakfast with fresh avocado",
      "category": "breakfast",
      "image": "https://images.unsplash.com/photo-1659474687639-9572736365e4",
      "semanticLabel":
          "Toasted bread topped with mashed avocado, cherry tomatoes, and microgreens on wooden board",
      "ingredients": [
        "2 slices whole grain bread",
        "1 ripe avocado",
        "1 tablespoon lemon juice",
        "Salt and pepper to taste",
        "Red pepper flakes",
        "Cherry tomatoes",
        "Microgreens for garnish"
      ],
      "steps": [
        "Toast bread slices until golden brown",
        "Mash avocado with lemon juice, salt, and pepper",
        "Spread avocado mixture on toasted bread",
        "Top with halved cherry tomatoes",
        "Sprinkle with red pepper flakes",
        "Garnish with microgreens",
        "Serve immediately"
      ]
    },
    {
      "id": 3,
      "title": "Grilled Chicken Salad",
      "description": "Fresh and healthy lunch with grilled chicken breast",
      "category": "lunch",
      "image": "https://images.unsplash.com/photo-1582034986517-30d163aa1da9",
      "semanticLabel":
          "Bowl of fresh green salad with sliced grilled chicken, cherry tomatoes, and cucumbers",
      "ingredients": [
        "2 chicken breasts",
        "Mixed salad greens",
        "Cherry tomatoes",
        "Cucumber",
        "Red onion",
        "Olive oil",
        "Balsamic vinegar",
        "Salt and pepper"
      ],
      "steps": [
        "Season chicken breasts with salt and pepper",
        "Grill chicken for 6-7 minutes per side",
        "Let chicken rest for 5 minutes, then slice",
        "Wash and prepare salad greens",
        "Chop vegetables into bite-sized pieces",
        "Arrange greens and vegetables in bowl",
        "Top with sliced chicken",
        "Drizzle with olive oil and balsamic vinegar"
      ]
    },
    {
      "id": 4,
      "title": "Vegetable Stir Fry",
      "description": "Quick and colorful vegetable stir fry for lunch",
      "category": "lunch",
      "image": "https://images.unsplash.com/photo-1619638337289-76f700067719",
      "semanticLabel":
          "Colorful stir-fried vegetables including bell peppers, broccoli, and carrots in a wok",
      "ingredients": [
        "2 cups mixed vegetables (bell peppers, broccoli, carrots)",
        "2 tablespoons vegetable oil",
        "3 cloves garlic, minced",
        "1 tablespoon ginger, grated",
        "3 tablespoons soy sauce",
        "1 tablespoon sesame oil",
        "Sesame seeds for garnish"
      ],
      "steps": [
        "Heat oil in wok over high heat",
        "Add garlic and ginger, stir for 30 seconds",
        "Add harder vegetables first (carrots, broccoli)",
        "Stir fry for 3-4 minutes",
        "Add softer vegetables (bell peppers)",
        "Add soy sauce and sesame oil",
        "Toss everything together for 2 minutes",
        "Garnish with sesame seeds and serve"
      ]
    },
    {
      "id": 5,
      "title": "Beef Tacos",
      "description": "Flavorful beef tacos with fresh toppings",
      "category": "dinner",
      "image": "https://images.unsplash.com/photo-1674277196243-ff6fc26e837c",
      "semanticLabel":
          "Three soft tacos filled with seasoned ground beef, lettuce, tomatoes, and cheese on plate",
      "ingredients": [
        "1 lb ground beef",
        "Taco seasoning",
        "8 taco shells",
        "Shredded lettuce",
        "Diced tomatoes",
        "Shredded cheese",
        "Sour cream",
        "Salsa"
      ],
      "steps": [
        "Brown ground beef in skillet over medium heat",
        "Drain excess fat",
        "Add taco seasoning and water according to package",
        "Simmer for 5 minutes",
        "Warm taco shells in oven",
        "Fill shells with seasoned beef",
        "Top with lettuce, tomatoes, and cheese",
        "Serve with sour cream and salsa"
      ]
    },
    {
      "id": 6,
      "title": "Baked Salmon",
      "description": "Healthy baked salmon with herbs and lemon",
      "category": "dinner",
      "image": "https://images.unsplash.com/photo-1614627293113-e7e68163d958",
      "semanticLabel":
          "Baked salmon fillet with herbs and lemon slices on white plate with asparagus",
      "ingredients": [
        "4 salmon fillets",
        "2 tablespoons olive oil",
        "2 cloves garlic, minced",
        "Fresh dill",
        "Lemon slices",
        "Salt and pepper",
        "Asparagus for serving"
      ],
      "steps": [
        "Preheat oven to 400°F (200°C)",
        "Place salmon fillets on baking sheet",
        "Brush with olive oil and minced garlic",
        "Season with salt, pepper, and fresh dill",
        "Top with lemon slices",
        "Bake for 12-15 minutes until cooked through",
        "Serve with roasted asparagus"
      ]
    },
    {
      "id": 7,
      "title": "Chocolate Chip Cookies",
      "description": "Classic homemade chocolate chip cookies",
      "category": "desserts",
      "image": "https://images.unsplash.com/photo-1605243614624-277f48f46d52",
      "semanticLabel":
          "Stack of golden brown chocolate chip cookies with melted chocolate chips visible",
      "ingredients": [
        "2.25 cups all-purpose flour",
        "1 cup butter, softened",
        "0.75 cup granulated sugar",
        "0.75 cup brown sugar",
        "2 eggs",
        "2 teaspoons vanilla extract",
        "1 teaspoon baking soda",
        "2 cups chocolate chips"
      ],
      "steps": [
        "Preheat oven to 375°F (190°C)",
        "Cream butter and sugars until fluffy",
        "Beat in eggs and vanilla",
        "Mix in flour and baking soda",
        "Fold in chocolate chips",
        "Drop rounded tablespoons onto baking sheet",
        "Bake 9-11 minutes until golden",
        "Cool on baking sheet for 2 minutes"
      ]
    },
    {
      "id": 8,
      "title": "Fruit Smoothie Bowl",
      "description": "Refreshing smoothie bowl topped with fresh fruits",
      "category": "snacks",
      "image": "https://images.unsplash.com/photo-1588368254556-d491748d3414",
      "semanticLabel":
          "Purple smoothie bowl topped with sliced bananas, berries, and granola in white bowl",
      "ingredients": [
        "2 frozen bananas",
        "1 cup frozen berries",
        "0.5 cup almond milk",
        "1 tablespoon honey",
        "Fresh fruit for topping",
        "Granola",
        "Chia seeds"
      ],
      "steps": [
        "Blend frozen bananas and berries with almond milk",
        "Add honey and blend until smooth",
        "Pour into bowl",
        "Top with sliced fresh fruit",
        "Sprinkle with granola and chia seeds",
        "Serve immediately"
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: RecipeCategory.values.length,
      vsync: this,
    );
    _tabController.addListener(_handleTabChange);
    _loadPreferences();
    _filterRecipes();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentCategory = RecipeCategory.values[_tabController.index];
        _filterRecipes();
      });
    }
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      final favoriteIds = prefs.getStringList('favoriteRecipeIds') ?? [];
      _favoriteRecipeIds = favoriteIds.map((id) => int.parse(id)).toSet();
    });
  }

  Future<void> _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  Future<void> _toggleFavorite(int recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favoriteRecipeIds.contains(recipeId)) {
        _favoriteRecipeIds.remove(recipeId);
      } else {
        _favoriteRecipeIds.add(recipeId);
      }
    });
    await prefs.setStringList(
      'favoriteRecipeIds',
      _favoriteRecipeIds.map((id) => id.toString()).toList(),
    );
  }

  void _filterRecipes() {
    setState(() {
      _filteredRecipes = _allRecipes.where((recipe) {
        final matchesSearch = _searchQuery.isEmpty ||
            (recipe["title"] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
        final matchesCategory = _currentCategory == RecipeCategory.all ||
            recipe["category"] == _getCategoryString(_currentCategory);
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  String _getCategoryString(RecipeCategory category) {
    switch (category) {
      case RecipeCategory.breakfast:
        return 'breakfast';
      case RecipeCategory.lunch:
        return 'lunch';
      case RecipeCategory.dinner:
        return 'dinner';
      case RecipeCategory.snacks:
        return 'snacks';
      case RecipeCategory.desserts:
        return 'desserts';
      default:
        return '';
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterRecipes();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  Future<void> _refreshRecipes() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _clearSearch();
    setState(() {
      _currentCategory = RecipeCategory.all;
      _tabController.animateTo(0);
      _filterRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Header with search and theme toggle
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Recipe Explorer',
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      icon: CustomIconWidget(
                        iconName: _isDarkMode ? 'light_mode' : 'dark_mode',
                        color: theme.colorScheme.onSurface,
                        size: 24,
                      ),
                      onPressed: _toggleTheme,
                      tooltip: 'Toggle theme',
                    ),
                  ],
                ),
              ),
              // Search bar
              SearchBarWidget(
                controller: _searchController,
                onChanged: _onSearchChanged,
                onClear: _clearSearch,
              ),
              // Category tabs
              CustomTabBar(
                currentCategory: _currentCategory,
                onCategoryChanged: (category) {
                  setState(() {
                    _currentCategory = category;
                    _tabController.animateTo(
                      RecipeCategory.values.indexOf(category),
                    );
                    _filterRecipes();
                  });
                },
                controller: _tabController,
              ),
              // Recipe list
              Expanded(
                child: _filteredRecipes.isEmpty
                    ? EmptyStateWidget(
                        message: _searchQuery.isEmpty
                            ? 'No recipes in this category'
                            : 'No recipes found for "$_searchQuery"',
                        onAction: _searchQuery.isNotEmpty ? _clearSearch : null,
                        actionLabel: 'Clear search',
                      )
                    : RefreshIndicator(
                        onRefresh: _refreshRecipes,
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 2.h),
                          itemCount: _filteredRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = _filteredRecipes[index];
                            final recipeId = recipe["id"] as int;
                            return RecipeCardWidget(
                              recipe: recipe,
                              isFavorite: _favoriteRecipeIds.contains(recipeId),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.recipeDetail,
                                  arguments: recipe,
                                );
                              },
                              onFavoriteToggle: () => _toggleFavorite(recipeId),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomBar(
          currentItem: CustomBottomBarItem.recipes,
          onItemTapped: (item) {
            if (item == CustomBottomBarItem.favorites) {
              Navigator.pushNamed(context, '/favorites-screen');
            }
          },
          favoritesBadgeCount: _favoriteRecipeIds.length,
        ),
      ),
    );
  }
}
