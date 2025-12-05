import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Individual study card widget for K53 content sections
/// Implements expandable card design with South African themed styling
class StudyCardWidget extends StatefulWidget {
  final Map<String, dynamic> studySection;
  final VoidCallback? onReadMore;

  const StudyCardWidget({
    super.key,
    required this.studySection,
    this.onReadMore,
  });

  @override
  State<StudyCardWidget> createState() => _StudyCardWidgetState();
}

class _StudyCardWidgetState extends State<StudyCardWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header with South African blue
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: const Color(0xFF0039A6),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: widget.studySection['icon'] as String,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    widget.studySection['title'] as String,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),

          // Card Content
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.studySection['description'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    height: 1.5,
                  ),
                  maxLines: _isExpanded ? null : 3,
                  overflow: _isExpanded ? null : TextOverflow.ellipsis,
                ),
                if (_isExpanded) ...[
                  SizedBox(height: 2.h),
                  Text(
                    widget.studySection['content'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.87,
                      ),
                      height: 1.6,
                    ),
                  ),
                ],
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      icon: CustomIconWidget(
                        iconName: _isExpanded ? 'expand_less' : 'expand_more',
                        color: const Color(0xFF0039A6),
                        size: 20,
                      ),
                      label: Text(
                        _isExpanded ? 'Show Less' : 'Read More',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: const Color(0xFF0039A6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (widget.onReadMore != null)
                      IconButton(
                        onPressed: widget.onReadMore,
                        icon: CustomIconWidget(
                          iconName: 'quiz',
                          color: const Color(0xFF008037),
                          size: 24,
                        ),
                        tooltip: 'Take Quiz',
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
