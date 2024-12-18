import 'dart:math';

import 'package:eventify/config/app_colors.dart';
import 'package:eventify/domain/models/category.dart';
import 'package:eventify/providers/event_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizerGraphScreen extends StatefulWidget {
  const OrganizerGraphScreen({super.key});

  @override
  State<OrganizerGraphScreen> createState() => _OrganizerGraphScreenState();
}

class _OrganizerGraphScreenState extends State<OrganizerGraphScreen> {
  String categorySelected = 'Select a category';

  @override
  void initState() {
    super.initState();
    context.read<EventProvider>().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            items: context
                .read<EventProvider>()
                .categoryList
                .map((Category category) {
              return DropdownMenuItem(
                value: category.name,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                categorySelected = newValue!;
              });
            },
            value: categorySelected == 'Select a category'
                ? null
                : categorySelected,
            hint: Text(categorySelected),
          ),
        ),

        Container(
          margin: const EdgeInsets.only(top: 20),
          child: const Text(
            'Attendance per month',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
          child: Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AppColors.deepOrange, width: 1),
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: Container(
              padding: const EdgeInsets.only(bottom: 20),
              margin: const EdgeInsets.only(top: 20),
              height: 300,
              child: Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: 8,
                    barTouchData: barTouchData,
                    backgroundColor: Colors.white,
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [createBarChartRodData(1)],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [createBarChartRodData(2)],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [createBarChartRodData(3)],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 3,
                        barRods: [createBarChartRodData(4)],
                        showingTooltipIndicators: [0],
                      ),
                    ],
                    titlesData: getTitlesData(),
                    gridData: const FlGridData(show: false),
                  ),
                  duration: const Duration(milliseconds: 150),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  FlTitlesData getTitlesData() {
    return FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, getTitlesWidget: getTitles),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ));
  }

  Widget getTitles(double value, TitleMeta meta) {
    const TextStyle style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String title;
    switch (value.toInt()) {
      case 0:
        title = 'Month 1';
        break;
      case 1:
        title = 'Month 2';
        break;
      case 2:
        title = 'Month 3';
        break;
      case 3:
        title = 'Month 4';
        break;
      default:
        title = '';
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 7,
      child: Text(title, style: style),
    );
  }

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          AppColors.darkOrange,
          AppColors.softOrange,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: AppColors.darkOrange,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  BarChartRodData createBarChartRodData(int position) {
    return BarChartRodData(
      toY: Random().nextInt(7) +
          1, // Here must go the number of users that attended
      width: 15,
      gradient: _barsGradient,
    );
  }
}
