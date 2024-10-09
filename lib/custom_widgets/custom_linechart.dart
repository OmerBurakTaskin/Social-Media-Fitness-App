import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gym_application/services/body_stats_db_service.dart';

class CustomLineChart extends StatelessWidget {
  final List<Map<DateTime, double>> data;
  final bodyStatsDbService = BodyStatsDbService();
  CustomLineChart({super.key, required this.data});

  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: lineChartBarData(),
    ));
  }

  List<LineChartBarData> lineChartBarData() {
    List<List<MapEntry>> sortedMapEntries = [];
    for (var map in data) {
      final sortedEntries = map.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      sortedMapEntries.add(sortedEntries);
    }
  }

  List sortedMap(Map map){
    if(!map.entries.any((element) => element.value is Map )){
        
    }
  }
}
