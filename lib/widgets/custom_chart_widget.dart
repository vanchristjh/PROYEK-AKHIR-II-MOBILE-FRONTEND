import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/chart_helper.dart';

/// A custom chart widget that handles compatibility issues with fl_chart
class CustomLineChart extends StatelessWidget {
  final List<LineChartBarData> lines;
  final String title;
  final bool showGrid;

  const CustomLineChart({
    Key? key,
    required this.lines,
    this.title = '',
    this.showGrid = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        Expanded(
          child: LineChart(
            ChartHelper.createLineChartData(
              lineBarsData: lines,
              gridData: FlGridData(show: showGrid),
            ),
          ),
        ),
      ],
    );
  }
}

/// A custom bar chart widget that handles compatibility issues with fl_chart
class CustomBarChart extends StatelessWidget {
  final List<BarChartGroupData> barGroups;
  final String title;
  final bool showGrid;

  const CustomBarChart({
    Key? key,
    required this.barGroups,
    this.title = '',
    this.showGrid = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        Expanded(
          child: BarChart(
            ChartHelper.createBarChartData(
              barGroups: barGroups,
              gridData: FlGridData(show: showGrid),
            ),
          ),
        ),
      ],
    );
  }
}
