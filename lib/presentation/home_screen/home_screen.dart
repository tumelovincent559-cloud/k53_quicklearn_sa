import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/app_title_widget.dart';
import './widgets/decorative_border_widget.dart';
import './widgets/navigation_card_widget.dart';

/// Home Screen - Main navigation hub for K53 test preparation
/// Provides quick access to Study, Quiz, and Road Signs features
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        // Exit app on back button press
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Top decorative border
              const DecorativeBorderWidget(isTop: true),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),

                      // App title section
                      const AppTitleWidget(),

                      SizedBox(height: 3.h),

                      // Navigation cards
                      NavigationCardWidget(
                        title: 'Study',
                        description:
                            'Access comprehensive K53 learning materials',
                        iconName: 'menu_book',
                        accentColor: theme.colorScheme.primary,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pushNamed(context, '/study-screen');
                        },
                      ),

                      SizedBox(height: 2.h),

                      NavigationCardWidget(
                        title: 'Quiz',
                        description:
                            'Test your knowledge with interactive questions',
                        iconName: 'quiz',
                        accentColor: theme.colorScheme.secondary,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pushNamed(context, '/quiz-screen');
                        },
                      ),

                      SizedBox(height: 2.h),

                      NavigationCardWidget(
                        title: 'Road Signs',
                        description: 'Visual reference guide for SA road signs',
                        iconName: 'traffic',
                        accentColor: theme.colorScheme.tertiary,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pushNamed(context, '/road-signs-screen');
                        },
                      ),

                      SizedBox(height: 4.h),

                      // Footer info
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName: 'verified',
                                  color: theme.colorScheme.secondary,
                                  size: 16,
                                ),
                                SizedBox(width: 2.w),
                                Flexible(
                                  child: Text(
                                    'Official K53 Standards Compliant',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Prepare with confidence for your driving test',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.7),
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 3.h),
                    ],
                  ),
                ),
              ),

              // Bottom decorative border
              const DecorativeBorderWidget(isTop: false),
            ],
          ),
        ),
      ),
    );
  }
}
