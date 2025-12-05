import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom Bottom Navigation Bar for K53 Learner application
/// Implements bottom-heavy architecture for thumb-friendly navigation
///
/// Features:
/// - Hub-and-spoke navigation model
/// - South African color scheme
/// - Clear visual hierarchy
/// - Touch-optimized targets (48dp minimum)
/// - Consistent with educational minimalism design
enum CustomBottomBarVariant {
  /// Standard bottom bar with all navigation items
  standard,

  /// Compact bottom bar with icons only
  compact,

  /// Bottom bar with labels always visible
  labeled,
}

class CustomBottomBar extends StatelessWidget {
  /// The currently selected index
  final int currentIndex;

  /// Callback when a navigation item is tapped
  final ValueChanged<int> onTap;

  /// The variant of the bottom bar
  final CustomBottomBarVariant variant;

  /// Custom background color (overrides theme)
  final Color? backgroundColor;

  /// Custom selected item color (overrides theme)
  final Color? selectedItemColor;

  /// Custom unselected item color (overrides theme)
  final Color? unselectedItemColor;

  /// Elevation of the bottom bar
  final double elevation;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.variant = CustomBottomBarVariant.standard,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors
    final bgColor = backgroundColor ?? colorScheme.surface;
    final selectedColor = selectedItemColor ?? colorScheme.primary;
    final unselectedColor =
        unselectedItemColor ??
        (theme.brightness == Brightness.light
            ? const Color(0xFF757575)
            : const Color(0xFFB0B0B0));

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _handleNavigation(context, index),
          type: variant == CustomBottomBarVariant.compact
              ? BottomNavigationBarType.shifting
              : BottomNavigationBarType.fixed,
          backgroundColor: bgColor,
          selectedItemColor: selectedColor,
          unselectedItemColor: unselectedColor,
          elevation: 0, // We handle elevation with container shadow
          selectedLabelStyle: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          showSelectedLabels: variant != CustomBottomBarVariant.compact,
          showUnselectedLabels: variant == CustomBottomBarVariant.labeled,
          items: _buildNavigationItems(),
        ),
      ),
    );
  }

  /// Build navigation items based on Mobile Navigation Hierarchy
  List<BottomNavigationBarItem> _buildNavigationItems() {
    return [
      BottomNavigationBarItem(
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Icon(Icons.home_outlined, size: 24),
        ),
        activeIcon: const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Icon(Icons.home, size: 24),
        ),
        label: 'Home',
        tooltip: 'Home - Main navigation hub',
      ),
      BottomNavigationBarItem(
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Icon(Icons.menu_book_outlined, size: 24),
        ),
        activeIcon: const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Icon(Icons.menu_book, size: 24),
        ),
        label: 'Study',
        tooltip: 'Study - Comprehensive learning materials',
      ),
      BottomNavigationBarItem(
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Icon(Icons.quiz_outlined, size: 24),
        ),
        activeIcon: const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Icon(Icons.quiz, size: 24),
        ),
        label: 'Quiz',
        tooltip: 'Quiz - Interactive testing mode',
      ),
      BottomNavigationBarItem(
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Icon(Icons.traffic_outlined, size: 24),
        ),
        activeIcon: const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Icon(Icons.traffic, size: 24),
        ),
        label: 'Signs',
        tooltip: 'Road Signs - Visual reference guide',
      ),
    ];
  }

  /// Handle navigation with route mapping
  void _handleNavigation(BuildContext context, int index) {
    // Call the onTap callback
    onTap(index);

    // Map index to route paths
    final routes = [
      '/home-screen',
      '/study-screen',
      '/quiz-screen',
      '/road-signs-screen',
    ];

    // Navigate to the selected route if not already there
    if (index != currentIndex && index < routes.length) {
      Navigator.pushReplacementNamed(context, routes[index]);
    }
  }
}

/// Extension to provide common bottom bar configurations
extension CustomBottomBarPresets on CustomBottomBar {
  /// Create a standard bottom bar
  static CustomBottomBar standard({
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return CustomBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      variant: CustomBottomBarVariant.standard,
    );
  }

  /// Create a compact bottom bar (icons only)
  static CustomBottomBar compact({
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return CustomBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      variant: CustomBottomBarVariant.compact,
    );
  }

  /// Create a labeled bottom bar (always show labels)
  static CustomBottomBar labeled({
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return CustomBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      variant: CustomBottomBarVariant.labeled,
    );
  }
}
