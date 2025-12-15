import 'package:flutter/material.dart';

/// Navigation item configuration for bottom navigation bar
enum CustomBottomBarItem {
  recipes,
  favorites,
}

/// Custom bottom navigation bar widget optimized for cooking context
/// Implements cooking-optimized 60dp height with large touch targets
/// Positioned in natural thumb zone for one-handed operation
class CustomBottomBar extends StatelessWidget {
  /// Current selected navigation item
  final CustomBottomBarItem currentItem;

  /// Callback when navigation item is tapped
  final Function(CustomBottomBarItem) onItemTapped;

  /// Optional badge count for favorites (shows number of saved recipes)
  final int? favoritesBadgeCount;

  const CustomBottomBar({
    super.key,
    required this.currentItem,
    required this.onItemTapped,
    this.favoritesBadgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              item: CustomBottomBarItem.recipes,
              icon: Icons.restaurant_menu_rounded,
              label: 'Recipes',
              isSelected: currentItem == CustomBottomBarItem.recipes,
            ),
            _buildNavItem(
              context: context,
              item: CustomBottomBarItem.favorites,
              icon: Icons.favorite_rounded,
              label: 'Favorites',
              isSelected: currentItem == CustomBottomBarItem.favorites,
              badgeCount: favoritesBadgeCount,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds individual navigation item with large touch target (minimum 48dp)
  Widget _buildNavItem({
    required BuildContext context,
    required CustomBottomBarItem item,
    required IconData icon,
    required String label,
    required bool isSelected,
    int? badgeCount,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedColor =
        theme.bottomNavigationBarTheme.selectedItemColor ?? colorScheme.primary;
    final unselectedColor =
        theme.bottomNavigationBarTheme.unselectedItemColor ??
            colorScheme.onSurface.withValues(alpha: 0.6);

    return Expanded(
      child: InkWell(
        onTap: () => onItemTapped(item),
        splashColor: selectedColor.withValues(alpha: 0.1),
        highlightColor: selectedColor.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with badge support
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    child: Icon(
                      icon,
                      size: 28,
                      color: isSelected ? selectedColor : unselectedColor,
                    ),
                  ),
                  // Badge indicator for favorites count
                  if (badgeCount != null && badgeCount > 0)
                    Positioned(
                      right: -8,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          badgeCount > 99 ? '99+' : badgeCount.toString(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onTertiary,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              // Label with animation
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                style: (isSelected
                        ? theme.bottomNavigationBarTheme.selectedLabelStyle
                        : theme
                            .bottomNavigationBarTheme.unselectedLabelStyle) ??
                    theme.textTheme.labelSmall!,
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? selectedColor : unselectedColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to navigate to the appropriate screen based on selected item
  static void navigateToItem(BuildContext context, CustomBottomBarItem item) {
    switch (item) {
      case CustomBottomBarItem.recipes:
        Navigator.pushReplacementNamed(context, '/main-recipe-list-screen');
        break;
      case CustomBottomBarItem.favorites:
        Navigator.pushReplacementNamed(context, '/favorites-screen');
        break;
    }
  }
}
