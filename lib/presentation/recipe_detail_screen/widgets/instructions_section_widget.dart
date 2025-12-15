import 'package:flutter/material.dart';

class InstructionsSectionWidget extends StatelessWidget {
  final List<dynamic> instructions;

  const InstructionsSectionWidget({super.key, required this.instructions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Instructions", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...List.generate(instructions.length, (index) {
            final step = instructions[index] as String;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${index + 1}. ",
                      style: Theme.of(context).textTheme.bodyLarge),
                  Expanded(child: Text(step)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
