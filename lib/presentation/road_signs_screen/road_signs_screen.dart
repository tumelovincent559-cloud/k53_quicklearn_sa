import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/sign_category_card_widget.dart';
import './widgets/sign_detail_card_widget.dart';

/// Road Signs Screen - Comprehensive reference guide for South African road signs
/// Displays organized grid layout of sign categories with search functionality
class RoadSignsScreen extends StatefulWidget {
  const RoadSignsScreen({super.key});

  @override
  State<RoadSignsScreen> createState() => _RoadSignsScreenState();
}

class _RoadSignsScreenState extends State<RoadSignsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int? _expandedCategoryIndex;
  bool _isRefreshing = false;

  // Mock data for road sign categories
  final List<Map<String, dynamic>> _signCategories = [
    {
      "id": 1,
      "title": "Warning Signs",
      "description": "Alert drivers to potential hazards ahead",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_164de44dd-1764659035130.png",
      "semanticLabel":
          "Yellow triangular warning road sign with black exclamation mark symbol",
      "signs": [
        {
          "name": "Sharp Bend Ahead",
          "meaning":
              "Warns of a sharp curve in the road requiring reduced speed",
          "image":
              "https://images.unsplash.com/photo-1591392992452-85f71b065a83",
          "semanticLabel":
              "Yellow triangular sign showing black curved arrow indicating sharp bend",
        },
        {
          "name": "Pedestrian Crossing",
          "meaning": "Indicates upcoming pedestrian crossing zone",
          "image":
              "https://images.unsplash.com/photo-1642242817106-85002a1de97c",
          "semanticLabel":
              "Yellow triangular sign with black pedestrian figure crossing",
        },
        {
          "name": "School Zone",
          "meaning": "Warns drivers of school area with children present",
          "image":
              "https://images.unsplash.com/photo-1598640905241-902d04d59085",
          "semanticLabel":
              "Yellow triangular sign showing two children figures",
        },
      ],
    },
    {
      "id": 2,
      "title": "Regulatory Signs",
      "description": "Indicate traffic laws and regulations",
      "image": "https://images.unsplash.com/photo-1580162357903-a7d7166993d6",
      "semanticLabel":
          "Red circular regulatory road sign with white background",
      "signs": [
        {
          "name": "Stop Sign",
          "meaning": "Complete stop required at intersection",
          "image":
              "https://images.unsplash.com/photo-1611519627012-0c4f3c1d3367",
          "semanticLabel": "Red octagonal sign with white STOP text",
        },
        {
          "name": "Yield Sign",
          "meaning": "Give way to traffic on major road",
          "image":
              "https://img.rocket.new/generatedImages/rocket_gen_img_1dfaf2c47-1764838301485.png",
          "semanticLabel":
              "Red inverted triangle with white border and YIELD text",
        },
        {
          "name": "Speed Limit",
          "meaning": "Maximum speed allowed on this road section",
          "image":
              "https://images.unsplash.com/photo-1637417494942-3112b9548591",
          "semanticLabel":
              "White circular sign with red border showing speed limit number",
        },
      ],
    },
    {
      "id": 3,
      "title": "Information Signs",
      "description": "Provide helpful information to drivers",
      "image": "https://images.unsplash.com/photo-1599597435338-adbf0f27b5b0",
      "semanticLabel":
          "Blue rectangular information road sign with white symbols",
      "signs": [
        {
          "name": "Hospital",
          "meaning": "Indicates location of medical facility",
          "image":
              "https://img.rocket.new/generatedImages/rocket_gen_img_1d4632505-1764838298075.png",
          "semanticLabel": "Blue square sign with white H symbol and cross",
        },
        {
          "name": "Parking Area",
          "meaning": "Designated parking zone ahead",
          "image":
              "https://img.rocket.new/generatedImages/rocket_gen_img_147f59913-1764838306167.png",
          "semanticLabel": "Blue square sign with white P letter",
        },
        {
          "name": "Rest Area",
          "meaning": "Rest stop facilities available",
          "image":
              "https://img.rocket.new/generatedImages/rocket_gen_img_1c01ae647-1764838298312.png",
          "semanticLabel": "Blue square sign with white bed and person symbol",
        },
      ],
    },
    {
      "id": 4,
      "title": "Prohibitory Signs",
      "description": "Show actions that are not allowed",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1ded21725-1764688209024.png",
      "semanticLabel":
          "Red circular prohibitory sign with diagonal line through symbol",
      "signs": [
        {
          "name": "No Entry",
          "meaning": "Entry prohibited for all vehicles",
          "image":
              "https://img.rocket.new/generatedImages/rocket_gen_img_12f630026-1764838297262.png",
          "semanticLabel": "Red circle with white horizontal bar",
        },
        {
          "name": "No Parking",
          "meaning": "Parking not permitted in this area",
          "image":
              "https://img.rocket.new/generatedImages/rocket_gen_img_17d264c8a-1764838298810.png",
          "semanticLabel":
              "Red circle with blue background and red diagonal line through P",
        },
        {
          "name": "No U-Turn",
          "meaning": "U-turns are prohibited",
          "image":
              "https://img.rocket.new/generatedImages/rocket_gen_img_16ccd7206-1764838299397.png",
          "semanticLabel": "Red circle with black U-turn arrow crossed out",
        },
      ],
    },
    {
      "id": 5,
      "title": "Directional Signs",
      "description": "Guide drivers to destinations",
      "image": "https://images.unsplash.com/photo-1713275065148-fe260db30292",
      "semanticLabel":
          "Green rectangular directional road sign with white arrow and text",
      "signs": [
        {
          "name": "Highway Exit",
          "meaning": "Indicates upcoming highway exit",
          "image": "https://images.unsplash.com/photo-1559209057-e06ec5da2d20",
          "semanticLabel":
              "Green sign with white arrow pointing right and exit number",
        },
        {
          "name": "City Direction",
          "meaning": "Shows direction to major city or town",
          "image":
              "https://images.unsplash.com/photo-1709089748108-73229e38109f",
          "semanticLabel":
              "Green sign with white text showing city name and distance",
        },
        {
          "name": "Route Number",
          "meaning": "Identifies national or regional route",
          "image":
              "https://images.unsplash.com/photo-1539815819411-7522d3f68f35",
          "semanticLabel": "Green sign with white route number in shield shape",
        },
      ],
    },
    {
      "id": 6,
      "title": "Guidance Signs",
      "description": "Provide navigation assistance",
      "image": "https://images.unsplash.com/photo-1585558657114-e557e422cc82",
      "semanticLabel":
          "Blue guidance road sign with white directional information",
      "signs": [
        {
          "name": "Lane Guidance",
          "meaning": "Shows proper lane positioning for turns",
          "image":
              "https://images.unsplash.com/photo-1664791081020-395b3061339c",
          "semanticLabel":
              "Blue sign with white arrows showing lane directions",
        },
        {
          "name": "Distance Marker",
          "meaning": "Indicates distance to next destination",
          "image":
              "https://images.unsplash.com/photo-1710427082383-7a9d49a17e8d",
          "semanticLabel":
              "Blue sign with white text showing kilometers to destination",
        },
        {
          "name": "Service Area",
          "meaning": "Shows available services at next exit",
          "image":
              "https://images.unsplash.com/photo-1635604963629-8d840ae81956",
          "semanticLabel":
              "Blue sign with white symbols for fuel, food, and lodging",
        },
      ],
    },
  ];

  List<Map<String, dynamic>> get _filteredCategories {
    if (_searchQuery.isEmpty) {
      return _signCategories;
    }
    return _signCategories.where((category) {
      final titleMatch = (category["title"] as String).toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      final descMatch = (category["description"] as String)
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final signsMatch = (category["signs"] as List).any(
        (sign) =>
            (sign["name"] as String).toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
            (sign["meaning"] as String).toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
      );
      return titleMatch || descMatch || signsMatch;
    }).toList();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isRefreshing = false);
  }

  void _handleSearch(String query) {
    setState(() => _searchQuery = query);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _searchQuery = '');
  }

  void _toggleCategory(int index) {
    setState(() {
      _expandedCategoryIndex = _expandedCategoryIndex == index ? null : index;
    });
  }

  void _navigateToQuiz() {
    Navigator.pushNamed(context, '/quiz-screen');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Road Signs Reference',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Column(
          children: [
            // Search Bar
            SearchBarWidget(
              controller: _searchController,
              onChanged: _handleSearch,
              onClear: _clearSearch,
            ),

            // Results Count
            if (_searchQuery.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${_filteredCategories.length} categories found',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),

            // Sign Categories Grid
            Expanded(
              child: _filteredCategories.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'search_off',
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5),
                            size: 48,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'No signs found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Try a different search term',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                      itemCount: _filteredCategories.length,
                      itemBuilder: (context, index) {
                        final category = _filteredCategories[index];
                        final isExpanded = _expandedCategoryIndex == index;

                        return Column(
                          children: [
                            // Category Card
                            SignCategoryCardWidget(
                              category: category,
                              onTap: () => _toggleCategory(index),
                            ),

                            // Expanded Sign Details
                            if (isExpanded)
                              Container(
                                margin: EdgeInsets.only(top: 1.h, bottom: 2.h),
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: theme.colorScheme.outline.withValues(
                                      alpha: 0.3,
                                    ),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 2.w,
                                        vertical: 1.h,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Sign Examples',
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                          IconButton(
                                            icon: CustomIconWidget(
                                              iconName: 'close',
                                              color: theme
                                                  .colorScheme.onSurfaceVariant,
                                              size: 20,
                                            ),
                                            onPressed: () =>
                                                _toggleCategory(index),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ...(category["signs"] as List).map(
                                      (sign) =>
                                          SignDetailCardWidget(sign: sign),
                                    ),
                                  ],
                                ),
                              ),

                            if (!isExpanded) SizedBox(height: 2.h),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToQuiz,
        icon: CustomIconWidget(
          iconName: 'quiz',
          color: theme.colorScheme.onTertiary,
          size: 24,
        ),
        label: Text(
          'Test Knowledge',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onTertiary,
          ),
        ),
        backgroundColor: theme.colorScheme.tertiary,
      ),
    );
  }
}
