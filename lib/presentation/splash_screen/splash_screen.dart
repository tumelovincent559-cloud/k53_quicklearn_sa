import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';

/// Splash Screen for K53 QuickLearn SA
/// Provides branded app launch experience with South African themed colors
/// Initializes core services and navigates to Home Screen after 3 seconds
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _initializeApp();
  }

  /// Initialize fade animation for logo and title
  void _initializeAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  /// Initialize app services and navigate to home screen
  Future<void> _initializeApp() async {
    try {
      // Simulate loading study materials, quiz questions, and road sign assets
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Navigate to home screen
        Navigator.pushReplacementNamed(context, '/home-screen');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  /// Retry initialization on error
  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _isLoading = true;
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0039A6), // South African blue
              const Color(0xFF0039A6).withValues(alpha: 0.8),
              const Color(0xFF008037), // South African green
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Animated logo and title section
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // App logo
                    Container(
                      width: 30.w,
                      height: 30.w,
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
                          iconName: 'directions_car',
                          color: const Color(0xFF0039A6),
                          size: 15.w,
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // App title
                    Text(
                      'K53 QuickLearn SA',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.surface,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 1.h),

                    // Subtitle
                    Text(
                      'Master Your Driving Test',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.surface.withValues(alpha: 0.9),
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Loading indicator or error message
              if (_isLoading && !_hasError)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 8.w,
                        height: 8.w,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.surface,
                          ),
                          strokeWidth: 3,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Loading study materials...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.surface.withValues(
                            alpha: 0.8,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else if (_hasError)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'error_outline',
                        color: const Color(0xFFF2C12E),
                        size: 12.w,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Failed to load resources',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.surface,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Please check your connection and try again',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.surface.withValues(
                            alpha: 0.8,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 3.h),
                      ElevatedButton(
                        onPressed: _retryInitialization,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF2C12E),
                          foregroundColor: const Color(0xFF0039A6),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Retry',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: const Color(0xFF0039A6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const Spacer(flex: 1),

              // K53 compliance message
              FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    'Official K53 Compliant Content',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.surface.withValues(alpha: 0.7),
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
