import 'package:flutter/material.dart';

class RecipeHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const RecipeHeaderWidget({
    super.key,
    required this.recipe,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recipe image
        if (recipe['image'] != null)
          Image.network(
            recipe['image'] as String,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        const SizedBox(height: 8),
        // Title + favorite toggle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  recipe['title'] as String,
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite
                      ? theme.colorScheme.tertiary
                      : theme.colorScheme.onSurface,
                ),
                onPressed: onFavoriteToggle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
