import 'package:eventify/config/app_colors.dart';
import 'package:eventify/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpandableFabButton extends StatelessWidget {
  final String category_name;

  const ExpandableFabButton({super.key, required this.category_name});

  @override
  Widget build(BuildContext context) {

    EventProvider eventProvider = context.read<EventProvider>();

    return Row(
      children: [
        Text(
          category_name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 20),
        FloatingActionButton.small(
          backgroundColor: getBackgroundColor(category_name),
          heroTag: null,
          onPressed: getButtonAction(category_name, eventProvider),
          child: getIcon(category_name),
        ),
      ],
    );
  }

  Color getBackgroundColor(String category_name) {
    switch (category_name) {
      case 'Clear filter':
        return Colors.red;
      case 'Technology':
        return AppColors.technologyColor;
      case 'Sport':
        return AppColors.sportColor;
      case 'Music':
        return AppColors.musicColor;
      default:
        return Colors.grey;
    }
  }

  Icon getIcon(String category_name) {
    switch (category_name) {
      case 'Clear filter':
        return const Icon(Icons.close);
      case 'Technology':
        return const Icon(Icons.tablet_android);
      case 'Sport':
        return const Icon(Icons.sports_basketball);
      case 'Music':
        return const Icon(Icons.music_note);
      default:
        return const Icon(Icons.question_mark_outlined);
    }
  }

  getButtonAction(String category_name, EventProvider eventProvider) {
    switch (category_name) {
      case 'Clear filter':
        return () => eventProvider.clearFilter();
      default:
        return () => eventProvider.fetchEventsByCategory(category_name);
    }
  }
}
