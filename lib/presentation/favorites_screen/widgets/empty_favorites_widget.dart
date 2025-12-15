import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Empty state widget displayed when user has no saved recipes
/// Shows cooking-themed illustration with call-to-action to browse recipes
class EmptyFavoritesWidget extends StatelessWidget {
  /// Callback when user taps "Browse Recipes" button
  final VoidCallback onBrowseRecipes;

  const EmptyFavoritesWidget({
    super.key,
    required this.onBrowseRecipes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Cooking-themed illustration
            Container(
              width: 60.w,
              height: 30.h,
              constraints: BoxConstraints(
                maxWidth: 300,
                maxHeight: 300,
              ),
              child: CustomImageWidget(
                imageUrl:
                    'https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=800&q=80',
                fit: BoxFit.contain,
                semanticLabel:
                    'Empty cookbook illustration with open recipe book and cooking utensils on wooden table',
              ),
            ),
            SizedBox(height: 4.h),

            // Empty state title
            Text(
              'No favorites yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),

            // Empty state description
            Text(
              'Start saving your favorite recipes\nto access them quickly anytime',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),

            // Browse Recipes call-to-action button
            ElevatedButton.icon(
              onPressed: onBrowseRecipes,
              icon: CustomIconWidget(
                iconName: 'restaurant_menu',
                color: theme.colorScheme.onPrimary,
                size: 20,
              ),
              label: Text('Browse Recipes'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                minimumSize: Size(40.w, 6.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
