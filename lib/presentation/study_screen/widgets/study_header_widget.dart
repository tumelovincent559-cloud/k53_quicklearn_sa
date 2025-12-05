import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Header widget for study screen with statistics and progress
class StudyHeaderWidget extends StatelessWidget {
  final int totalSections;
  final int completedSections;

  const StudyHeaderWidget({
    super.key,
    required this.totalSections,
    required this.completedSections,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressPercentage = totalSections > 0
        ? (completedSections / totalSections * 100).toInt()
        : 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0039A6), Color(0xFF005BBB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'menu_book',
                color: Colors.white,
                size: 32,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'K53 Study Materials',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Master your driving knowledge',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Sections',
                  totalSections.toString(),
                  'library_books',
                ),
                Container(
                  width: 1,
                  height: 6.h,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                _buildStatItem(
                  context,
                  'Completed',
                  completedSections.toString(),
                  'check_circle',
                ),
                Container(
                  width: 1,
                  height: 6.h,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                _buildStatItem(
                  context,
                  'Progress',
                  '$progressPercentage%',
                  'trending_up',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    String iconName,
  ) {
    final theme = Theme.of(context);
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: const Color(0xFFF2C12E),
          size: 24,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
