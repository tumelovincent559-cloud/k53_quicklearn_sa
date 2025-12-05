import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Quick access buttons for related features
class QuickAccessWidget extends StatelessWidget {
  final VoidCallback onQuizPressed;
  final VoidCallback onRoadSignsPressed;

  const QuickAccessWidget({
    super.key,
    required this.onQuizPressed,
    required this.onRoadSignsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'rocket_launch',
                color: const Color(0xFF008037),
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Quick Access',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildQuickAccessButton(
                  context,
                  'Take Quiz',
                  'quiz',
                  const Color(0xFF008037),
                  onQuizPressed,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildQuickAccessButton(
                  context,
                  'Road Signs',
                  'traffic',
                  const Color(0xFFF2C12E),
                  onRoadSignsPressed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessButton(
    BuildContext context,
    String label,
    String iconName,
    Color color,
    VoidCallback onPressed,
  ) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.1),
        foregroundColor: color,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: color.withValues(alpha: 0.3), width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(iconName: iconName, color: color, size: 28),
          SizedBox(height: 1.h),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
