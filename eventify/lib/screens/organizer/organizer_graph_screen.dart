import 'dart:math';

import 'package:eventify/config/app_colors.dart';
import 'package:eventify/domain/models/category.dart';
import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/providers/user_provider.dart';
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
  Map<String, int> attendeesPerMonth = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    await context.read<EventProvider>().fetchCategories();
    await context.read<EventProvider>().fetchAttendeesPerMonth(
        context.read<UserProvider>().currentUser!.id,
        context.read<UserProvider>());
    await fetchAttendeesData();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchAttendeesData() async {
    setState(() {
      isLoading = true;
    });
    final eventProvider = context.read<EventProvider>();
    final fetchedData = categorySelected == 'Select a category'
        ? {}
        : eventProvider.getAttendeesDataForCategory(categorySelected);
    if (mounted) {
      setState(() {
        attendeesPerMonth = Map<String, int>.from(fetchedData);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildContent(),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  Widget buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 200),
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
            onChanged: isLoading
                ? null
                : (String? newValue) async {
                    setState(() {
                      categorySelected = newValue!;
                    });
                    await fetchAttendeesData();
                  },
            hint: Text(categorySelected),
            disabledHint: Text(categorySelected),
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
              child: BarChart(
                BarChartData(
                  maxY: attendeesPerMonth.values.isNotEmpty
                      ? attendeesPerMonth.values.reduce(max).toDouble() + 1
                      : 8,
                  barTouchData: barTouchData,
                  backgroundColor: Colors.white,
                  borderData: FlBorderData(show: false),
                  barGroups: attendeesPerMonth.entries
                      .map((entry) => BarChartGroupData(
                            x: int.parse(entry.key),
                            barRods: [createBarChartRodData(entry.value)],
                            showingTooltipIndicators: [0],
                          ))
                      .toList(),
                  titlesData: getTitlesData(),
                  gridData: const FlGridData(show: false),
                ),
                duration: const Duration(milliseconds: 150),
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
      case 1:
        title = 'Jan';
        break;
      case 2:
        title = 'Feb';
        break;
      case 3:
        title = 'Mar';
        break;
      case 4:
        title = 'Apr';
        break;
      case 5:
        title = 'May';
        break;
      case 6:
        title = 'Jun';
        break;
      case 7:
        title = 'Jul';
        break;
      case 8:
        title = 'Aug';
        break;
      case 9:
        title = 'Sep';
        break;
      case 10:
        title = 'Oct';
        break;
      case 11:
        title = 'Nov';
        break;
      case 12:
        title = 'Dec';
        break;
      default:
        title = '';
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 3,
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

  BarChartRodData createBarChartRodData(int value) {
    return BarChartRodData(
      toY: value.toDouble(),
      width: 15,
      gradient: _barsGradient,
    );
  }
}
