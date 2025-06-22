import 'package:decimal/decimal.dart';
import 'package:flow/screens/analytics_screen/models/monthly_chart_model.dart';
import 'package:flow/screens/analytics_screen/services/analystic_db_services.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class YearlyChartWidget extends StatefulWidget {
  const YearlyChartWidget({super.key});

  @override
  State<YearlyChartWidget> createState() => _YearlyChartWidgetState();
}

class _YearlyChartWidgetState extends State<YearlyChartWidget> {
  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
  List<MonthlyAndYearlyChartData> _yearlyChartData = [];

  @override
  void initState() {
    super.initState();
    _loadYearlyChartData();
  }

  Future<void> _loadYearlyChartData() async {
    final data = await AnalysticDbServices.instance.fetchYearlyCreditDebit();

    setState(() {
      _yearlyChartData = data.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final yearStr = item['year'].toString();
        final credit = Decimal.tryParse(item['total_credited'].toString()) ?? Decimal.zero;
        final debit = Decimal.tryParse(item['total_debited'].toString()) ?? Decimal.zero;

        return MonthlyAndYearlyChartData(
          index.toDouble(),
          credit.toDouble(),
          debit.toDouble(),
          yearStr,
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _yearlyChartData.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SizedBox(
            height: 350,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SfCartesianChart(
                title: const ChartTitle(text: 'Yearly Credit vs Debit'),
                legend: const Legend(isVisible: true),
                tooltipBehavior: _tooltipBehavior,
                primaryXAxis: CategoryAxis(
                  title: AxisTitle(text: 'Year'),
                  majorGridLines: const MajorGridLines(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Amount'),
                  labelFormat: '{value}',
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                ),
                series: <CartesianSeries>[
                  SplineSeries<MonthlyAndYearlyChartData, String>(
                    name: 'Credited',
                    dataSource: _yearlyChartData,
                    xValueMapper: (data, _) => data.monthLabel,
                    yValueMapper: (data, _) => data.credited,
                    color: Colors.green.withOpacity(0.5),
                  ),
                  SplineSeries<MonthlyAndYearlyChartData, String>(
                    name: 'Debited',
                    dataSource: _yearlyChartData,
                    xValueMapper: (data, _) => data.monthLabel,
                    yValueMapper: (data, _) => data.debited,
                    color: Colors.red.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          );
  }
}
