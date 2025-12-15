import 'package:flutter/material.dart';

class RecipeMetadataWidget extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeMetadataWidget({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: [
          _buildMeta(theme, "Prep", recipe['prepTime']),
          _buildMeta(theme, "Cook", recipe['cookTime']),
          _buildMeta(theme, "Servings", recipe['servings']),
          _buildMeta(theme, "Difficulty", recipe['difficulty']),
        ],
      ),
    );
  }

  Widget _buildMeta(ThemeData theme, String label, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodySmall),
        Text(value?.toString() ?? "-", style: theme.textTheme.bodyLarge),
      ],
    );
  }
}
