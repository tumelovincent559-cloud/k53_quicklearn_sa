import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Individual recipe card widget displaying recipe information
/// Implements 3:2 aspect ratio image with title, description, and favorite toggle
class RecipeCardWidget extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const RecipeCardWidget({
    super.key,
    required this.recipe,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe image with 3:2 aspect ratio
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: AspectRatio(
                    aspectRatio: 3 / 2,
                    child: CustomImageWidget(
                      imageUrl: recipe["image"] as String? ?? "",
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel:
                          recipe["semanticLabel"] as String? ?? "Recipe image",
                    ),
                  ),
                ),
                // Favorite heart icon overlay
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onFavoriteToggle,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor
                              .withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: isFavorite ? 'favorite' : 'favorite_border',
                          color: isFavorite
                              ? colorScheme.tertiary
                              : colorScheme.onSurface,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Recipe details
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe title (max 2 lines)
                  Text(
                    recipe["title"] as String? ?? "",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  // Recipe description
                  Text(
                    recipe["description"] as String? ?? "",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
