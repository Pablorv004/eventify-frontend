import 'package:eventify/config/app_colors.dart';
import 'package:flutter/material.dart';

class ExpandableFabButton extends StatelessWidget{
    final String category_name;

  const ExpandableFabButton({super.key, required this.category_name});

    @override
    Widget build(BuildContext context) {
      return Row(
        children: [
          Text(category_name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          const SizedBox(width: 20),
          FloatingActionButton.small(
            backgroundColor: getBackgroundColor(category_name),
            heroTag: null,
            onPressed: null,
            child: getIcon(category_name),
          ),
        ],
      );
    }
    
      Color getBackgroundColor(String category_name) {
        switch(category_name){
          case 'Clear filter': return Colors.red;
          case 'Technology': return AppColors.technologyColor;
          case 'Sport': return AppColors.sportColor;
          case 'Music': return AppColors.musicColor;
          default: return Colors.grey;
        }
      }

      Icon getIcon(String category_name) {
        switch(category_name){
          case 'Clear filter': return Icon(Icons.close);
          case 'Technology': return Icon(Icons.tablet_android);
          case 'Sport': return Icon(Icons.sports_basketball);
          case 'Music': return Icon(Icons.music_note);
          default: return Icon(Icons.warning);
        }
      }
  }
