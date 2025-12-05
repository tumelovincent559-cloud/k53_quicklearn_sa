import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/quick_access_widget.dart';
import './widgets/study_card_widget.dart';
import './widgets/study_header_widget.dart';

/// Study Screen for K53 Learner application
/// Provides comprehensive K53 learning materials through scrollable card-based layout
class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  bool _isRefreshing = false;
  final Set<int> _bookmarkedSections = {};
  int _completedSections = 0;

  // Mock K53 study data
  final List<Map<String, dynamic>> _studySections = [
    {
      "id": 1,
      "icon": "gavel",
      "title": "Rules of the Road",
      "description":
          "Master the fundamental traffic laws and regulations that govern South African roads. Understanding these rules is essential for safe driving.",
      "content":
          """The Rules of the Road form the foundation of safe driving in South Africa. Key topics include: • Right of Way: Understanding who has priority at intersections, roundabouts, and pedestrian crossings • Speed Limits: Knowing the legal speed limits for different road types (60km/h urban, 100km/h rural, 120km/h freeways) • Traffic Signals: Proper response to traffic lights, stop signs, and yield signs • Lane Discipline: Correct lane usage, overtaking rules, and merging procedures • Pedestrian Rights: Respecting pedestrian crossings and school zones • Emergency Vehicles: Yielding to ambulances, fire trucks, and police vehicles Remember: Following these rules protects you and other road users. The K53 test will assess your knowledge of these fundamental principles.""",
    },
    {
      "id": 2,
      "icon": "settings",
      "title": "Vehicle Controls",
      "description":
          "Learn about essential vehicle controls and their proper operation. From steering to braking, master every aspect of vehicle handling.",
      "content":
          """Vehicle Controls are critical for safe vehicle operation. This section covers: • Steering Techniques: Hand-over-hand method, push-pull steering, and proper grip • Pedal Control: Smooth acceleration, progressive braking, and clutch operation • Gear Selection: Understanding when to change gears for optimal performance • Mirrors and Blind Spots: Proper mirror adjustment and blind spot checking • Indicators and Lights: Correct use of turn signals, headlights, and hazard lights • Parking Brake: When and how to engage the handbrake • Dashboard Instruments: Understanding warning lights and gauges Practice Tip: Familiarize yourself with these controls before your test. Smooth, confident operation demonstrates competence.""",
    },
    {
      "id": 3,
      "icon": "shield",
      "title": "Defensive Driving",
      "description":
          "Develop defensive driving skills to anticipate and avoid potential hazards. Learn to drive proactively and protect yourself on the road.",
      "content":
          """Defensive Driving is about anticipating danger and taking preventive action. Key principles include: • Hazard Perception: Identifying potential dangers before they become threats • Following Distance: Maintaining safe space (2-3 second rule) • Scanning Technique: Constantly checking mirrors and surroundings • Speed Management: Adjusting speed for conditions (weather, traffic, visibility) • Intersection Safety: Approaching intersections with caution • Night Driving: Extra vigilance in reduced visibility • Adverse Conditions: Handling rain, fog, and strong winds • Fatigue Management: Recognizing when you're too tired to drive Safety First: Defensive driving reduces accident risk by 50%. Always expect the unexpected and have an escape plan.""",
    },
    {
      "id": 4,
      "icon": "route",
      "title": "Road Markings",
      "description":
          "Understand the meaning of various road markings and their importance in traffic management. These visual guides are crucial for safe navigation.",
      "content":
          """Road Markings provide essential guidance and warnings. This section explains: • Lane Lines: White (same direction), yellow (opposite direction), solid vs. broken • Stop Lines: Where to stop at intersections and crossings • Pedestrian Crossings: Zebra crossings and their right-of-way rules • Box Junctions: Yellow grid markings and blocking rules • Arrows and Symbols: Directional arrows, bicycle lanes, and special lanes • Edge Lines: Road boundaries and shoulder markings • Chevrons: Hazard warnings on curves and obstacles • Parking Markings: Legal parking zones and restrictions Visual Learning: Road markings are your constant guide. Learn to read them instinctively for safer driving.""",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Study Materials',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: const Color(0xFF0039A6),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 2.h),
                  StudyHeaderWidget(
                    totalSections: _studySections.length,
                    completedSections: _completedSections,
                  ),
                  QuickAccessWidget(
                    onQuizPressed: () =>
                        Navigator.pushNamed(context, '/quiz-screen'),
                    onRoadSignsPressed: () =>
                        Navigator.pushNamed(context, '/road-signs-screen'),
                  ),
                  SizedBox(height: 1.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'auto_stories',
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Study Sections',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final section = _studySections[index];
                return GestureDetector(
                  onLongPress: () => _showContextMenu(context, index),
                  child: StudyCardWidget(
                    studySection: section,
                    onReadMore: () => _navigateToQuiz(context),
                  ),
                );
              }, childCount: _studySections.length),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 10.h)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToQuiz(context),
        backgroundColor: const Color(0xFF008037),
        foregroundColor: Colors.white,
        icon: CustomIconWidget(iconName: 'quiz', color: Colors.white, size: 24),
        label: Text(
          'Take Quiz',
          style: theme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate content refresh
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Study materials updated'),
          backgroundColor: const Color(0xFF008037),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showContextMenu(BuildContext context, int index) {
    final theme = Theme.of(context);
    final isBookmarked = _bookmarkedSections.contains(index);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: isBookmarked ? 'bookmark' : 'bookmark_border',
                color: const Color(0xFFF2C12E),
                size: 24,
              ),
              title: Text(
                isBookmarked ? 'Remove Bookmark' : 'Bookmark Section',
                style: theme.textTheme.bodyLarge,
              ),
              onTap: () {
                setState(() {
                  if (isBookmarked) {
                    _bookmarkedSections.remove(index);
                  } else {
                    _bookmarkedSections.add(index);
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isBookmarked ? 'Bookmark removed' : 'Section bookmarked',
                    ),
                    backgroundColor: const Color(0xFFF2C12E),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'check_circle',
                color: const Color(0xFF008037),
                size: 24,
              ),
              title: Text(
                'Mark as Completed',
                style: theme.textTheme.bodyLarge,
              ),
              onTap: () {
                setState(() {
                  if (_completedSections < _studySections.length) {
                    _completedSections++;
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Section marked as completed'),
                    backgroundColor: const Color(0xFF008037),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'quiz',
                color: const Color(0xFF0039A6),
                size: 24,
              ),
              title: Text('Practice Quiz', style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                _navigateToQuiz(context);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _navigateToQuiz(BuildContext context) {
    Navigator.pushNamed(context, '/quiz-screen');
  }
}
