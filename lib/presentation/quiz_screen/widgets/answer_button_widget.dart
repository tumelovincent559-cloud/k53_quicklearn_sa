import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AnswerButtonWidget extends StatelessWidget {
  final String answerText;
  final bool isSelected;
  final bool isCorrect;
  final bool isAnswered;
  final VoidCallback onTap;

  const AnswerButtonWidget({
    super.key,
    required this.answerText,
    required this.isSelected,
    required this.isCorrect,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color getBackgroundColor() {
      if (!isAnswered) {
        return isSelected
            ? const Color(0xFFF2C12E).withValues(alpha: 0.2)
            : theme.colorScheme.surface;
      }

      if (isSelected && !isCorrect) {
        return theme.colorScheme.error.withValues(alpha: 0.1);
      }

      if (isCorrect) {
        return const Color(0xFF008037).withValues(alpha: 0.1);
      }

      return theme.colorScheme.surface;
    }

    Color getBorderColor() {
      if (!isAnswered) {
        return isSelected ? const Color(0xFFF2C12E) : theme.colorScheme.outline;
      }

      if (isSelected && !isCorrect) {
        return theme.colorScheme.error;
      }

      if (isCorrect) {
        return const Color(0xFF008037);
      }

      return theme.colorScheme.outline;
    }

    IconData? getIcon() {
      if (!isAnswered) return null;

      if (isSelected && !isCorrect) {
        return Icons.close;
      }

      if (isCorrect) {
        return Icons.check;
      }

      return null;
    }

    Color? getIconColor() {
      if (!isAnswered) return null;

      if (isSelected && !isCorrect) {
        return theme.colorScheme.error;
      }

      if (isCorrect) {
        return const Color(0xFF008037);
      }

      return null;
    }

    return InkWell(
      onTap: isAnswered ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: getBackgroundColor(),
          border: Border.all(color: getBorderColor(), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                answerText,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (getIcon() != null) ...[
              SizedBox(width: 2.w),
              CustomIconWidget(
                iconName: getIcon() == Icons.check ? 'check' : 'close',
                color: getIconColor()!,
                size: 24,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
