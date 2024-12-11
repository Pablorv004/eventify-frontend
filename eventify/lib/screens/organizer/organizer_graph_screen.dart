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
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 110, left: 40, right: 40),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: 'Category',
              labelStyle: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
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
          padding: const EdgeInsets.only(right: 38),
          margin: const EdgeInsets.only(top: 20),
          height: 300,
          child: BarChart(
            BarChartData(
              backgroundColor: Colors.white,
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: 3,
                      color: Colors.blue,
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      toY: 1,
                      color: Colors.green,
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 2,
                  barRods: [
                    BarChartRodData(
                      toY: 2,
                      color: Colors.red,
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 3,
                  barRods: [
                    BarChartRodData(
                      toY: 4,
                      color: Colors.yellow,
                    ),
                  ],
                ),
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      switch (value.toInt()) {
                        case 0:
                          return const Text('Bar 1');
                        case 1:
                          return const Text('Bar 2');
                        case 2:
                          return const Text('Bar 3');
                        case 3:
                          return const Text('Bar 4');
                        default:
                          return const Text('');
                      }
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
            ),
            duration: const Duration(milliseconds: 150),
          ),
        ),
      ],
    );
  }
}
