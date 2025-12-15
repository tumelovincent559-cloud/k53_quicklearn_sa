import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';

/// Splash Screen - Branded app launch experience with recipe data initialization
/// Displays app logo with fade-in animation during 2-3 second initialization
/// Loads SharedPreferences for theme and favorites, prepares recipe database
/// Navigates to Main Recipe List Screen after initialization completes
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _initializationFailed = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Setup fade-in animation for logo
  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  /// Initialize app resources and preferences
  Future<void> _initializeApp() async {
    try {
      // Initialize SharedPreferences
      await _initializePreferences();

      // Simulate asset loading and recipe database preparation
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to main recipe list screen
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main-recipe-list-screen');
      }
    } catch (e) {
      // Handle initialization failure
      if (mounted) {
        setState(() {
          _initializationFailed = true;
        });
      }
    }
  }

  /// Initialize SharedPreferences for theme and favorites
  Future<void> _initializePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if preferences exist, if not create defaults
      if (!prefs.containsKey('isDarkMode')) {
        await prefs.setBool('isDarkMode', false);
      }

      if (!prefs.containsKey('favorites')) {
        await prefs.setStringList('favorites', []);
      }
    } catch (e) {
      // Reset to defaults if corrupted
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await prefs.setBool('isDarkMode', false);
      await prefs.setStringList('favorites', []);
    }
  }

  /// Retry initialization on failure
  Future<void> _retryInitialization() async {
    setState(() {
      _initializationFailed = false;
    });
    await _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primaryContainer,
              theme.colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: _initializationFailed
              ? _buildErrorView(theme)
              : _buildSplashContent(theme),
        ),
      ),
    );
  }

  /// Build main splash content with logo and loading indicator
  Widget _buildSplashContent(ThemeData theme) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          _buildLogo(theme),
          const SizedBox(height: 24),
          _buildAppName(theme),
          const Spacer(flex: 2),
          _buildLoadingIndicator(theme),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  /// Build app logo with cooking-themed iconography
  Widget _buildLogo(ThemeData theme) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'restaurant_menu',
          size: 64,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  /// Build app name text
  Widget _buildAppName(ThemeData theme) {
    return Column(
      children: [
        Text(
          'Recipe Explorer',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Discover Your Next Favorite Dish',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  /// Build loading indicator
  Widget _buildLoadingIndicator(ThemeData theme) {
    return SizedBox(
      width: 40,
      height: 40,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          theme.colorScheme.onPrimary,
        ),
        strokeWidth: 3,
      ),
    );
  }

  /// Build error view with retry option
  Widget _buildErrorView(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'error_outline',
              size: 80,
              color: theme.colorScheme.onPrimary,
            ),
            const SizedBox(height: 24),
            Text(
              'Initialization Failed',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load recipe data. Please check your connection and try again.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _retryInitialization,
              icon: CustomIconWidget(
                iconName: 'refresh',
                size: 20,
                color: theme.colorScheme.onPrimary,
              ),
              label: Text(
                'Retry',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.surface,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
