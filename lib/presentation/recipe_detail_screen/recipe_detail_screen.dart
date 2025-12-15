import 'widgets/recipe_header_widget.dart';
import 'widgets/recipe_metadata_widget.dart';
import 'widgets/ingredients_section_widget.dart';
import 'widgets/instructions_section_widget.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';

/// Recipe Detail Screen - Comprehensive recipe information with cooking reference
/// Displays full recipe details with ingredients checklist and step-by-step instructions
class RecipeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool _isFavorite = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  /// Load favorite status from SharedPreferences
  Future<void> _loadFavoriteStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString('favorites') ?? '[]';
      final List<dynamic> favorites = json.decode(favoritesJson);

      final isFav = favorites.any((fav) {
        if (fav is Map && fav.containsKey('id')) {
          return fav['id'] == widget.recipe['id'];
        }
        return false;
      });

      if (mounted) {
        setState(() {
          _isFavorite = isFav;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Toggle favorite status and persist to SharedPreferences
  Future<void> _toggleFavorite() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString('favorites') ?? '[]';
      final List<dynamic> favorites = json.decode(favoritesJson);

      if (_isFavorite) {
        favorites.removeWhere((fav) {
          if (fav is Map && fav.containsKey('id')) {
            return fav['id'] == widget.recipe['id'];
          }
          return false;
        });
      } else {
        favorites.add(widget.recipe);
      }

      await prefs.setString('favorites', json.encode(favorites));

      if (mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFavorite ? 'Added to favorites' : 'Removed from favorites',
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update favorites'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // App bar with back button and favorite toggle
          SliverAppBar(
            expandedHeight: kToolbarHeight, // fixed height to avoid flicker
            pinned: true,
            backgroundColor: colorScheme.surface,
            leading: IconButton(
              icon: CustomIconWidget(
                iconName: 'arrow_back',
                size: 24,
                color: colorScheme.onSurface,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: CustomIconWidget(
                  iconName: _isFavorite ? 'favorite' : 'favorite_border',
                  size: 24,
                  color: _isFavorite
                      ? colorScheme.tertiary
                      : colorScheme.onSurface,
                ),
                onPressed: _isLoading ? null : _toggleFavorite,
              ),
              const SizedBox(width: 8),
            ],
          ),
          // Scrollable content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe header with image and title
                RecipeHeaderWidget(
                  recipe: widget.recipe,
                  isFavorite: _isFavorite,
                  onFavoriteToggle: _toggleFavorite,
                ),
                const SizedBox(height: 8),
                // Recipe description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.recipe['description'] as String,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Recipe metadata (prep time, cook time, servings, difficulty)
                RecipeMetadataWidget(recipe: widget.recipe),
                const SizedBox(height: 16),
                // Ingredients section with checkboxes
                IngredientsSectionWidget(
                  ingredients: widget.recipe['ingredients'] as List<dynamic>,
                ),
                const SizedBox(height: 16),
                // Instructions section with numbered steps
                InstructionsSectionWidget(
                  instructions: widget.recipe['instructions'] as List<dynamic>,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
