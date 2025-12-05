import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Decorative border widget with South African flag colors
/// Provides visual branding elements
class DecorativeBorderWidget extends StatelessWidget {
  final bool isTop;

  const DecorativeBorderWidget({super.key, this.isTop = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 1.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
            theme.colorScheme.tertiary,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}
