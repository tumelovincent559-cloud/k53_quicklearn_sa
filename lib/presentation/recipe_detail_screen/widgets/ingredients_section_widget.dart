import 'package:flutter/material.dart';

class IngredientsSectionWidget extends StatefulWidget {
  final List<dynamic> ingredients;

  const IngredientsSectionWidget({super.key, required this.ingredients});

  @override
  State<IngredientsSectionWidget> createState() =>
      _IngredientsSectionWidgetState();
}

class _IngredientsSectionWidgetState extends State<IngredientsSectionWidget> {
  final Set<int> _checked = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ingredients", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...List.generate(widget.ingredients.length, (index) {
            final ingredient = widget.ingredients[index] as String;
            return CheckboxListTile(
              title: Text(ingredient),
              value: _checked.contains(index),
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    _checked.add(index);
                  } else {
                    _checked.remove(index);
                  }
                });
              },
            );
          }),
        ],
      ),
    );
  }
}
