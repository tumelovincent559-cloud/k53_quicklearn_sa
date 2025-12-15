import 'package:flutter/material.dart';

/// Category types for recipe organization by meal time
enum RecipeCategory {
  all,
  breakfast,
  lunch,
  dinner,
  snacks,
  desserts,
}

/// Custom tab bar widget for meal-time recipe organization
/// Implements smooth category switching with swipe gesture support
/// Optimized for quick browsing during meal planning
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// Current selected category
  final RecipeCategory currentCategory;

  /// Callback when category is changed
  final Function(RecipeCategory) onCategoryChanged;

  /// Tab controller for managing tab state
  final TabController? controller;

  /// Whether to show the tab bar with scrollable behavior
  final bool isScrollable;

  const CustomTabBar({
    super.key,
    required this.currentCategory,
    required this.onCategoryChanged,
    this.controller,
    this.isScrollable = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: isScrollable,
        tabAlignment: isScrollable ? TabAlignment.start : TabAlignment.fill,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: theme.tabBarTheme.indicatorColor ?? colorScheme.primary,
            width: 3,
          ),
          insets: const EdgeInsets.symmetric(horizontal: 16),
        ),
        labelColor: theme.tabBarTheme.labelColor ?? colorScheme.primary,
        unselectedLabelColor: theme.tabBarTheme.unselectedLabelColor ??
            colorScheme.onSurface.withValues(alpha: 0.6),
        labelStyle: theme.tabBarTheme.labelStyle,
        unselectedLabelStyle: theme.tabBarTheme.unselectedLabelStyle,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        onTap: (index) {
          onCategoryChanged(RecipeCategory.values[index]);
        },
        tabs: RecipeCategory.values.map((category) {
          return Tab(
            height: 48,
            child: _buildTabContent(
              context: context,
              category: category,
              isSelected: currentCategory == category,
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Builds tab content with icon and label
  Widget _buildTabContent({
    required BuildContext context,
    required RecipeCategory category,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getCategoryIcon(category),
            size: 20,
            color: isSelected
                ? (theme.tabBarTheme.labelColor ?? colorScheme.primary)
                : (theme.tabBarTheme.unselectedLabelColor ??
                    colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
          const SizedBox(width: 8),
          Text(
            _getCategoryLabel(category),
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  /// Returns appropriate icon for each category
  IconData _getCategoryIcon(RecipeCategory category) {
    switch (category) {
      case RecipeCategory.all:
        return Icons.grid_view_rounded;
      case RecipeCategory.breakfast:
        return Icons.free_breakfast_rounded;
      case RecipeCategory.lunch:
        return Icons.lunch_dining_rounded;
      case RecipeCategory.dinner:
        return Icons.dinner_dining_rounded;
      case RecipeCategory.snacks:
        return Icons.fastfood_rounded;
      case RecipeCategory.desserts:
        return Icons.cake_rounded;
    }
  }

  /// Returns display label for each category
  String _getCategoryLabel(RecipeCategory category) {
    switch (category) {
      case RecipeCategory.all:
        return 'All';
      case RecipeCategory.breakfast:
        return 'Breakfast';
      case RecipeCategory.lunch:
        return 'Lunch';
      case RecipeCategory.dinner:
        return 'Dinner';
      case RecipeCategory.snacks:
        return 'Snacks';
      case RecipeCategory.desserts:
        return 'Desserts';
    }
  }
}

/// Wrapper widget that combines TabBar with TabBarView for complete category navigation
class CustomTabBarView extends StatefulWidget {
  /// Initial category to display
  final RecipeCategory initialCategory;

  /// Callback when category changes
  final Function(RecipeCategory)? onCategoryChanged;

  /// Builder function for each category's content
  final Widget Function(BuildContext context, RecipeCategory category)
      categoryBuilder;

  const CustomTabBarView({
    super.key,
    this.initialCategory = RecipeCategory.all,
    this.onCategoryChanged,
    required this.categoryBuilder,
  });

  @override
  State<CustomTabBarView> createState() => _CustomTabBarViewState();
}

class _CustomTabBarViewState extends State<CustomTabBarView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late RecipeCategory _currentCategory;

  @override
  void initState() {
    super.initState();
    _currentCategory = widget.initialCategory;
    _tabController = TabController(
      length: RecipeCategory.values.length,
      vsync: this,
      initialIndex: RecipeCategory.values.indexOf(widget.initialCategory),
    );

    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentCategory = RecipeCategory.values[_tabController.index];
      });
      widget.onCategoryChanged?.call(_currentCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTabBar(
          currentCategory: _currentCategory,
          onCategoryChanged: (category) {
            setState(() {
              _currentCategory = category;
              _tabController.animateTo(
                RecipeCategory.values.indexOf(category),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            });
            widget.onCategoryChanged?.call(category);
          },
          controller: _tabController,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: RecipeCategory.values.map((category) {
              return widget.categoryBuilder(context, category);
            }).toList(),
          ),
        ),
      ],
    );
  }
}
