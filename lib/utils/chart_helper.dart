import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Helper class to work around fl_chart compatibility issues
class ChartHelper {
  /// Safely check if bold text is enabled in the context
  static bool isBoldTextEnabled(BuildContext context) {
    // MediaQuery.boldTextOverride no longer exists in newer Flutter versions
    // This is a safe replacement that tries to determine if bold text is enabled
    final mediaQuery = MediaQuery.of(context);
    
    // Check textScaleFactor as an indicator
    final isTextScaled = mediaQuery.textScaleFactor > 1.3;
    return isTextScaled;
  }
  
  /// Create line chart data with safe defaults
  static LineChartData createLineChartData({
    required List<LineChartBarData> lineBarsData,
    FlGridData? gridData,
    bool showBorder = true,
  }) {
    return LineChartData(
      gridData: gridData ?? FlGridData(show: true),
      titlesData: FlTitlesData(show: true),
      borderData: showBorder ? FlBorderData(show: true) : FlBorderData(show: false),
      lineBarsData: lineBarsData,
    );
  }
  
  /// Create bar chart data with safe defaults
  static BarChartData createBarChartData({
    required List<BarChartGroupData> barGroups,
    FlGridData? gridData,
    bool showBorder = true,
  }) {
    return BarChartData(
      gridData: gridData ?? FlGridData(show: true),
      titlesData: FlTitlesData(show: true),
      borderData: showBorder ? FlBorderData(show: true) : FlBorderData(show: false),
      barGroups: barGroups,
    );
  }
  
  /// Create safe text style that accounts for bold text accessibility settings
  static TextStyle safeTextStyle(BuildContext context, TextStyle baseStyle) {
    if (isBoldTextEnabled(context)) {
      return baseStyle.copyWith(fontWeight: FontWeight.bold);
    }
    return baseStyle;
  }
}
