import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/empty_favorites_widget.dart';
import './widgets/favorite_recipe_card_widget.dart';

/// Favorites Screen displays user's saved recipes with management functionality
/// Accessible via bottom tab bar navigation as secondary tab
/// Supports swipe-to-delete, long-press context menu, and pull-to-refresh
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  /// List of favorite recipe IDs stored in SharedPreferences
  List<int> _favoriteIds = [];

  /// List of favorite recipes with full data
  List<Map<String, dynamic>> _favoriteRecipes = [];

  /// Loading state for pull-to-refresh
  bool _isRefreshing = false;

  /// Search query for filtering favorites
  String _searchQuery = '';

  /// Search controller for text input
  final TextEditingController _searchController = TextEditingController();

  /// Mock recipe data (same as main recipe list)
  final List<Map<String, dynamic>> _allRecipes = [
    {
      "id": 1,
      "title": "Classic Pancakes",
      "description":
          "Fluffy homemade pancakes perfect for weekend breakfast with maple syrup",
      "category": "breakfast",
      "prepTime": "15 min",
      "servings": 4,
      "image": "https://images.unsplash.com/photo-1732984901763-01cd79444ae5",
      "semanticLabel":
          "Stack of golden brown fluffy pancakes topped with butter and maple syrup on white plate",
      "ingredients": [
        "2 cups all-purpose flour",
        "2 tablespoons sugar",
        "2 teaspoons baking powder",
        "1 teaspoon salt",
        "2 eggs",
        "1.5 cups milk",
        "4 tablespoons melted butter"
      ],
      "steps": [
        "Mix dry ingredients in a large bowl",
        "Whisk eggs, milk, and melted butter in separate bowl",
        "Combine wet and dry ingredients until just mixed",
        "Heat griddle to medium-high heat",
        "Pour 1/4 cup batter for each pancake",
        "Cook until bubbles form, then flip",
        "Cook until golden brown on both sides"
      ]
    },
    {
      "id": 2,
      "title": "Grilled Chicken Salad",
      "description":
          "Healthy grilled chicken breast over mixed greens with balsamic vinaigrette",
      "category": "lunch",
      "prepTime": "25 min",
      "servings": 2,
      "image": "https://images.unsplash.com/photo-1654216548994-eefcba14db5c",
      "semanticLabel":
          "Fresh garden salad with grilled chicken strips, cherry tomatoes, cucumbers, and mixed greens in white bowl",
      "ingredients": [
        "2 chicken breasts",
        "6 cups mixed greens",
        "1 cup cherry tomatoes",
        "1 cucumber, sliced",
        "1/4 red onion, sliced",
        "1/4 cup balsamic vinaigrette",
        "Salt and pepper to taste"
      ],
      "steps": [
        "Season chicken breasts with salt and pepper",
        "Grill chicken for 6-7 minutes per side",
        "Let chicken rest for 5 minutes, then slice",
        "Arrange mixed greens in bowls",
        "Top with tomatoes, cucumber, and onion",
        "Add sliced chicken",
        "Drizzle with balsamic vinaigrette"
      ]
    },
    {
      "id": 3,
      "title": "Spaghetti Carbonara",
      "description":
          "Creamy Italian pasta with bacon, eggs, and parmesan cheese",
      "category": "dinner",
      "prepTime": "20 min",
      "servings": 4,
      "image": "https://images.unsplash.com/photo-1591972774172-084d6be1b72c",
      "semanticLabel":
          "Plate of creamy spaghetti carbonara with bacon pieces, black pepper, and grated parmesan cheese",
      "ingredients": [
        "1 pound spaghetti",
        "8 oz bacon, diced",
        "4 eggs",
        "1 cup grated parmesan",
        "2 cloves garlic, minced",
        "Black pepper to taste",
        "Salt for pasta water"
      ],
      "steps": [
        "Cook spaghetti according to package directions",
        "Cook bacon until crispy, add garlic",
        "Whisk eggs and parmesan in a bowl",
        "Drain pasta, reserving 1 cup pasta water",
        "Add hot pasta to bacon pan",
        "Remove from heat, add egg mixture",
        "Toss quickly, adding pasta water as needed",
        "Season with black pepper and serve"
      ]
    },
    {
      "id": 4,
      "title": "Avocado Toast",
      "description":
          "Simple and nutritious breakfast with mashed avocado on toasted bread",
      "category": "breakfast",
      "prepTime": "10 min",
      "servings": 2,
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1b107396e-1765247750854.png",
      "semanticLabel":
          "Toasted sourdough bread topped with mashed avocado, cherry tomatoes, and sesame seeds on wooden board",
      "ingredients": [
        "2 slices whole grain bread",
        "1 ripe avocado",
        "1 tablespoon lemon juice",
        "Salt and pepper to taste",
        "Red pepper flakes (optional)",
        "Cherry tomatoes for garnish"
      ],
      "steps": [
        "Toast bread until golden brown",
        "Mash avocado with lemon juice",
        "Season with salt and pepper",
        "Spread avocado on toast",
        "Top with red pepper flakes if desired",
        "Garnish with cherry tomatoes"
      ]
    },
    {
      "id": 5,
      "title": "Beef Tacos",
      "description":
          "Seasoned ground beef tacos with fresh toppings and crispy shells",
      "category": "dinner",
      "prepTime": "30 min",
      "servings": 4,
      "image": "https://images.unsplash.com/photo-1595084439852-f1c63790a7b6",
      "semanticLabel":
          "Three crispy taco shells filled with seasoned ground beef, lettuce, tomatoes, cheese, and sour cream on plate",
      "ingredients": [
        "1 pound ground beef",
        "1 packet taco seasoning",
        "8 taco shells",
        "1 cup shredded lettuce",
        "1 cup diced tomatoes",
        "1 cup shredded cheese",
        "Sour cream and salsa"
      ],
      "steps": [
        "Brown ground beef in skillet",
        "Add taco seasoning and water",
        "Simmer for 10 minutes",
        "Warm taco shells in oven",
        "Fill shells with beef",
        "Top with lettuce, tomatoes, and cheese",
        "Serve with sour cream and salsa"
      ]
    },
    {
      "id": 6,
      "title": "Chocolate Chip Cookies",
      "description":
          "Classic homemade cookies with gooey chocolate chips, perfect for dessert",
      "category": "desserts",
      "prepTime": "35 min",
      "servings": 24,
      "image": "https://images.unsplash.com/photo-1633104061671-334b7ebf853b",
      "semanticLabel":
          "Stack of golden brown chocolate chip cookies with melted chocolate chips visible on cooling rack",
      "ingredients": [
        "2.25 cups all-purpose flour",
        "1 teaspoon baking soda",
        "1 cup butter, softened",
        "0.75 cup sugar",
        "0.75 cup brown sugar",
        "2 eggs",
        "2 teaspoons vanilla extract",
        "2 cups chocolate chips"
      ],
      "steps": [
        "Preheat oven to 375°F",
        "Mix flour and baking soda",
        "Cream butter and sugars",
        "Beat in eggs and vanilla",
        "Gradually blend in flour mixture",
        "Stir in chocolate chips",
        "Drop rounded tablespoons onto baking sheets",
        "Bake 9-11 minutes until golden brown"
      ]
    },
    {
      "id": 7,
      "title": "Greek Yogurt Parfait",
      "description":
          "Layered breakfast parfait with yogurt, granola, and fresh berries",
      "category": "breakfast",
      "prepTime": "5 min",
      "servings": 1,
      "image": "https://images.unsplash.com/photo-1461716030737-1db7da8e616f",
      "semanticLabel":
          "Glass jar filled with layers of white Greek yogurt, granola, fresh strawberries, and blueberries",
      "ingredients": [
        "1 cup Greek yogurt",
        "0.5 cup granola",
        "0.5 cup mixed berries",
        "1 tablespoon honey",
        "Fresh mint for garnish"
      ],
      "steps": [
        "Layer half the yogurt in a glass",
        "Add half the granola and berries",
        "Repeat layers",
        "Drizzle with honey",
        "Garnish with fresh mint"
      ]
    },
    {
      "id": 8,
      "title": "Caesar Salad Wrap",
      "description":
          "Crispy romaine lettuce with Caesar dressing wrapped in tortilla",
      "category": "lunch",
      "prepTime": "15 min",
      "servings": 2,
      "image": "https://images.unsplash.com/photo-1666819476628-2f3afb0ca147",
      "semanticLabel":
          "Flour tortilla wrap filled with romaine lettuce, grilled chicken, parmesan cheese, and Caesar dressing cut in half",
      "ingredients": [
        "2 large flour tortillas",
        "2 cups romaine lettuce",
        "1 grilled chicken breast",
        "0.25 cup Caesar dressing",
        "0.25 cup parmesan cheese",
        "Croutons (optional)"
      ],
      "steps": [
        "Warm tortillas slightly",
        "Slice grilled chicken",
        "Toss lettuce with Caesar dressing",
        "Place lettuce mixture on tortilla",
        "Add chicken and parmesan",
        "Add croutons if desired",
        "Roll tightly and cut in half"
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Loads favorite recipe IDs from SharedPreferences
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIdsString = prefs.getStringList('favorite_recipes') ?? [];
      setState(() {
        _favoriteIds = favoriteIdsString.map((id) => int.parse(id)).toList();
        _updateFavoriteRecipes();
      });
    } catch (e) {
      _showToast('Failed to load favorites');
    }
  }

  /// Updates the list of favorite recipes based on favorite IDs
  void _updateFavoriteRecipes() {
    _favoriteRecipes = _allRecipes
        .where((recipe) => _favoriteIds.contains(recipe['id'] as int))
        .toList();
  }

  /// Saves favorite recipe IDs to SharedPreferences
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        'favorite_recipes',
        _favoriteIds.map((id) => id.toString()).toList(),
      );
    } catch (e) {
      _showToast('Failed to save favorites');
    }
  }

  /// Removes recipe from favorites with animation
  Future<void> _removeFromFavorites(int recipeId) async {
    setState(() {
      _favoriteIds.remove(recipeId);
      _updateFavoriteRecipes();
    });
    await _saveFavorites();
    _showToast('Removed from favorites');
  }

  /// Handles pull-to-refresh functionality
  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(milliseconds: 500));

    await _loadFavorites();

    setState(() {
      _isRefreshing = false;
    });
  }

  /// Filters favorite recipes based on search query
  List<Map<String, dynamic>> _getFilteredRecipes() {
    if (_searchQuery.isEmpty) {
      return _favoriteRecipes;
    }

    return _favoriteRecipes.where((recipe) {
      final title = (recipe['title'] as String).toLowerCase();
      final query = _searchQuery.toLowerCase();
      return title.contains(query);
    }).toList();
  }

  /// Shows toast message
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  /// Handles share functionality
  void _shareRecipe(Map<String, dynamic> recipe) {
    _showToast('Share functionality coming soon');
  }

  /// Navigates to recipe detail screen
  void _navigateToRecipeDetail(Map<String, dynamic> recipe) {
    Navigator.pushNamed(
      context,
      '/recipe-detail-screen',
      arguments: recipe,
    ).then((_) {
      // Reload favorites when returning from detail screen
      _loadFavorites();
    });
  }

  /// Navigates to main recipe list screen
  void _navigateToRecipeList() {
    Navigator.pushReplacementNamed(context, '/main-recipe-list-screen');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredRecipes = _getFilteredRecipes();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'My Favorites',
              style: theme.appBarTheme.titleTextStyle,
            ),
            if (_favoriteRecipes.isNotEmpty) ...[
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_favoriteRecipes.length}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          // Theme toggle button
          IconButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final currentTheme = prefs.getBool('isDarkMode') ?? false;
              await prefs.setBool('isDarkMode', !currentTheme);
              _showToast(
                  currentTheme ? 'Light mode enabled' : 'Dark mode enabled');
            },
            icon: CustomIconWidget(
              iconName: 'brightness_6',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Toggle theme',
          ),
        ],
      ),
      body: SafeArea(
        child: _favoriteRecipes.isEmpty
            ? EmptyFavoritesWidget(
                onBrowseRecipes: _navigateToRecipeList,
              )
            : Column(
                children: [
                  // Search bar (optional for large collections)
                  if (_favoriteRecipes.length > 5)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search favorites...',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'search',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _searchQuery = '';
                                    });
                                  },
                                  icon: CustomIconWidget(
                                    iconName: 'clear',
                                    color: theme.colorScheme.onSurfaceVariant,
                                    size: 20,
                                  ),
                                )
                              : null,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.5.h,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),

                  // Favorites list with pull-to-refresh
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: filteredRecipes.isEmpty
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.all(4.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'search_off',
                                      size: 48,
                                      color: theme.colorScheme.onSurfaceVariant
                                          .withValues(alpha: 0.5),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      'No recipes found',
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      'Try a different search term',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              itemCount: filteredRecipes.length,
                              itemBuilder: (context, index) {
                                final recipe = filteredRecipes[index];
                                return FavoriteRecipeCardWidget(
                                  recipe: recipe,
                                  onTap: () => _navigateToRecipeDetail(recipe),
                                  onRemoveFavorite: () =>
                                      _removeFromFavorites(recipe['id'] as int),
                                  onDelete: () =>
                                      _removeFromFavorites(recipe['id'] as int),
                                  onShare: () => _shareRecipe(recipe),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentItem: CustomBottomBarItem.favorites,
        onItemTapped: (item) {
          if (item == CustomBottomBarItem.recipes) {
            _navigateToRecipeList();
          }
        },
        favoritesBadgeCount: _favoriteRecipes.length,
      ),
    );
  }
}
