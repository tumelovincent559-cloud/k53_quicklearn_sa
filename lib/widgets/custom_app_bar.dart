import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget for K53 Learner application
/// Implements Contemporary Educational Minimalism with South African branding
///
/// Features:
/// - Consistent South African blue header
/// - Professional typography with Roboto
/// - Optional back navigation
/// - Optional action buttons
/// - Centered title for balanced composition
enum CustomAppBarVariant {
  /// Standard app bar with back button
  standard,

  /// Home screen app bar without back button
  home,

  /// App bar with action buttons
  withActions,

  /// Minimal app bar with title only
  minimal,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title text displayed in the app bar
  final String title;

  /// The variant of the app bar
  final CustomAppBarVariant variant;

  /// Optional leading widget (overrides default back button)
  final Widget? leading;

  /// Optional action buttons
  final List<Widget>? actions;

  /// Whether to show the back button (only for standard variant)
  final bool showBackButton;

  /// Custom background color (overrides theme)
  final Color? backgroundColor;

  /// Custom foreground color (overrides theme)
  final Color? foregroundColor;

  /// Elevation of the app bar
  final double? elevation;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom callback for back button
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.variant = CustomAppBarVariant.standard,
    this.leading,
    this.actions,
    this.showBackButton = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine background and foreground colors
    final bgColor = backgroundColor ?? colorScheme.primary;
    final fgColor = foregroundColor ?? colorScheme.onPrimary;

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: fgColor,
          letterSpacing: 0.15,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: elevation ?? 2.0,
      leading: _buildLeading(context, fgColor),
      actions: _buildActions(context),
      automaticallyImplyLeading: false,
    );
  }

  /// Build the leading widget based on variant
  Widget? _buildLeading(BuildContext context, Color fgColor) {
    // If custom leading is provided, use it
    if (leading != null) {
      return leading;
    }

    // For home and minimal variants, no leading widget
    if (variant == CustomAppBarVariant.home ||
        variant == CustomAppBarVariant.minimal) {
      return null;
    }

    // For standard and withActions variants, show back button if enabled
    if (showBackButton && Navigator.of(context).canPop()) {
      return IconButton(
        icon: Icon(Icons.arrow_back, color: fgColor),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        tooltip: 'Back',
        splashRadius: 24,
      );
    }

    return null;
  }

  /// Build action buttons based on variant
  List<Widget>? _buildActions(BuildContext context) {
    if (variant == CustomAppBarVariant.withActions && actions != null) {
      return actions;
    }
    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Extension to provide common app bar configurations
extension CustomAppBarPresets on CustomAppBar {
  /// Create a home screen app bar
  static CustomAppBar home({required String title, List<Widget>? actions}) {
    return CustomAppBar(
      title: title,
      variant: CustomAppBarVariant.home,
      actions: actions,
    );
  }

  /// Create a standard screen app bar with back button
  static CustomAppBar standard({
    required String title,
    VoidCallback? onBackPressed,
  }) {
    return CustomAppBar(
      title: title,
      variant: CustomAppBarVariant.standard,
      onBackPressed: onBackPressed,
    );
  }

  /// Create an app bar with action buttons
  static CustomAppBar withActions({
    required String title,
    required List<Widget> actions,
    bool showBackButton = true,
  }) {
    return CustomAppBar(
      title: title,
      variant: CustomAppBarVariant.withActions,
      actions: actions,
      showBackButton: showBackButton,
    );
  }

  /// Create a minimal app bar
  static CustomAppBar minimal({required String title}) {
    return CustomAppBar(title: title, variant: CustomAppBarVariant.minimal);
  }
}
