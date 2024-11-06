import 'package:eventify/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.filter_alt_outlined),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: Colors.black,
        backgroundColor: AppColors.amberOrange,
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
      children: const [
        Row(
          children: [
            Text('Music', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            SizedBox(width: 20),
            FloatingActionButton.small(
              backgroundColor: Color.fromARGB(255, 215, 156, 225),
              heroTag: null,
              onPressed: null,
              child: Icon(Icons.music_note),
            ),
          ],
        ),
        Row(
          children: [
            Text('Technology', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            SizedBox(width: 20),
            FloatingActionButton.small(
              backgroundColor: Color.fromARGB(255, 196, 248, 255),
              heroTag: null,
              onPressed: null,
              child: Icon(Icons.tablet_android),
            ),
          ],
        ),
        Row(
          children: [
            Text('Sports', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            SizedBox(width: 20),
            FloatingActionButton.small(
              backgroundColor: Color.fromARGB(255, 255, 226, 139),
              heroTag: null,
              onPressed: null,
              child: Icon(Icons.sports_basketball),
            ),
          ],
        ),
        Row(
          children: [
            Text('Clear filter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            SizedBox(width: 20),
            FloatingActionButton.small(
              backgroundColor: Color.fromARGB(255, 252, 155, 148),
              heroTag: null,
              onPressed: null,
              child: Icon(Icons.dangerous),
            ),
          ],
        ),
      ],
    );
  }
}
