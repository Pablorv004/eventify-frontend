import 'package:eventify/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class FilterButton extends StatelessWidget {
  final List<Widget> categoryList;

  const FilterButton({
    super.key,
    required this.categoryList,
  });

  @override
  Widget build(BuildContext context) {
    
    return ExpandableFab(
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.filter_alt_outlined),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: Colors.white,
        backgroundColor: AppColors.darkOrange,
      ),
      closeButtonBuilder: RotateFloatingActionButtonBuilder(
        angle: 3.14,
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
}
