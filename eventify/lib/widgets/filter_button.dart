import 'package:eventify/config/app_colors.dart';
import 'package:eventify/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    EventProvider eventProvider = context.watch<EventProvider>();
    List<Widget> categoryList = getCategories(eventProvider.categories);
    
    return ExpandableFab(
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.filter_alt_outlined),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: Colors.white,
        backgroundColor: AppColors.darkOrange,
      ),
      closeButtonBuilder: RotateFloatingActionButtonBuilder(
        angle: 3.15,
        child: const Icon(Icons.arrow_upward),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: Colors.black,
        backgroundColor: AppColors.amberOrange,
      ),
      type: ExpandableFabType.up,
      childrenAnimation: ExpandableFabAnimation.none,
      distance: 70,
      overlayStyle: ExpandableFabOverlayStyle(
        color: Colors.white.withOpacity(0.9),
      ),
      children: categoryList,
    );
  }

  List<Widget> getCategories(List<String> categories) {
    List<Widget> categoryList = [];

    for (String category in categories) {
      categoryList.add(ExpandableFabButton(category, Icon(Icons.filter_alt_outlined), AppColors.darkOrange));
    }

    return categoryList;
  }

  Row ExpandableFabButton(String category_name, Icon icon, Color color) {
    return Row(
        children: [
          Text(category_name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          const SizedBox(width: 20),
          FloatingActionButton.small(
            backgroundColor: color,
            heroTag: null,
            onPressed: null,
            child: icon,
          ),
        ],
      );
  }
}
