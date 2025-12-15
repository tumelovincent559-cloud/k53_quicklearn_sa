import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Recipe card widget for favorites list with swipe-to-delete functionality
/// Displays recipe image, title, description, and filled heart icon
/// Supports swipe gestures and long-press context menu
class FavoriteRecipeCardWidget extends StatelessWidget {
  /// Recipe data map containing id, title, description, image, etc.
  final Map<String, dynamic> recipe;

  /// Callback when card is tapped to view recipe details
  final VoidCallback onTap;

  /// Callback when heart icon is tapped to remove from favorites
  final VoidCallback onRemoveFavorite;

  /// Callback when delete action is triggered via swipe
  final VoidCallback onDelete;

  /// Callback when share option is selected from context menu
  final VoidCallback onShare;

  const FavoriteRecipeCardWidget({
    super.key,
    required this.recipe,
    required this.onTap,
    required this.onRemoveFavorite,
    required this.onDelete,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Slidable(
      key: ValueKey(recipe['id']),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (context) => _showDeleteConfirmation(context),
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
            icon: Icons.delete_rounded,
            label: 'Delete',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: GestureDetector(
        onLongPress: () => _showContextMenu(context),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe image with hero animation support
                  Hero(
                    tag: 'recipe_${recipe['id']}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: recipe['image'] as String,
                        width: 25.w,
                        height: 12.h,
                        fit: BoxFit.cover,
                        semanticLabel: recipe['semanticLabel'] as String,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),

                  // Recipe details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Recipe title
                        Text(
                          recipe['title'] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),

                        // Recipe description
                        Text(
                          recipe['description'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),

                        // Recipe metadata (prep time, servings)
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'schedule',
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              recipe['prepTime'] as String,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            CustomIconWidget(
                              iconName: 'people',
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '${recipe['servings']} servings',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Filled heart icon for favorites
                  IconButton(
                    onPressed: onRemoveFavorite,
                    icon: CustomIconWidget(
                      iconName: 'favorite',
                      color: theme.colorScheme.tertiary,
                      size: 24,
                    ),
                    padding: EdgeInsets.all(2.w),
                    constraints: BoxConstraints(
                      minWidth: 10.w,
                      minHeight: 6.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Shows confirmation dialog before deleting recipe from favorites
  void _showDeleteConfirmation(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Remove from Favorites?',
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to remove "${recipe['title']}" from your favorites?',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }

  /// Shows context menu with options: Remove, View Recipe, Share
  void _showContextMenu(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Recipe title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Text(
                recipe['title'] as String,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Divider(),

            // Remove from Favorites option
            ListTile(
              leading: CustomIconWidget(
                iconName: 'favorite_border',
                color: theme.colorScheme.error,
                size: 24,
              ),
              title: Text(
                'Remove from Favorites',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context);
              },
            ),

            // View Recipe option
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'View Recipe',
                style: theme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onTap();
              },
            ),

            // Share option
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Share',
                style: theme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onShare();
              },
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
