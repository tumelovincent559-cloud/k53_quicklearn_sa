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

  /// Search query for filtering favorites
  String _searchQuery = '';

  /// Search controller for text input
  final TextEditingController _searchController = TextEditingController();

  /// Mock recipe data (same as main recipe list)
  final List<Map<String, dynamic>> _allRecipes = [
    // … your recipe maps (pancakes, salad, etc.)
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
    await Future.delayed(const Duration(milliseconds: 500));
    await _loadFavorites();
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

  /// Navigates to recipe detail screen
  void _navigateToRecipeDetail(Map<String, dynamic> recipe) {
    Navigator.pushNamed(
      context,
      '/recipe-detail-screen',
      arguments: recipe,
    ).then((_) {
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
        title: Text('My Favorites', style: theme.appBarTheme.titleTextStyle),
        actions: [
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
            ? EmptyFavoritesWidget(onBrowseRecipes: _navigateToRecipeList)
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
                          setState(() => _searchQuery = value);
                        },
                      ),
                    ),
                  // Favorites list with pull-to-refresh
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: filteredRecipes.isEmpty
                          ? Center(
                              child: Text(
                                'No recipes found',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
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
                                  onShare: () => _showToast(
                                      'Share functionality coming soon'),
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
