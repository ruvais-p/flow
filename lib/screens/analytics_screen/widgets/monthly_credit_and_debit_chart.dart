import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flow/screens/analytics_screen/services/analystic_db_services.dart';
import 'package:flow/screens/analytics_screen/models/monthly_chart_model.dart';

class MonthlyChartWidget extends StatefulWidget {
  const MonthlyChartWidget({super.key});

  @override
  State<MonthlyChartWidget> createState() => _MonthlyChartWidgetState();
}

class _MonthlyChartWidgetState extends State<MonthlyChartWidget> {
  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
  List<MonthlyAndYearlyChartData> _MonthlyAndYearlyChartData = [];

  @override
  void initState() {
    super.initState();
    _loadMonthlyAndYearlyChartData();
  }

  Future<void> _loadMonthlyAndYearlyChartData() async {
    final data = await AnalysticDbServices.instance.fetchMonthlyCreditDebit();

    setState(() {
      _MonthlyAndYearlyChartData = data.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final monthStr = item['month'].toString();
        final credit = Decimal.tryParse(item['total_credited'].toString()) ?? Decimal.zero;
        final debit = Decimal.tryParse(item['total_debited'].toString()) ?? Decimal.zero;

        return MonthlyAndYearlyChartData(
          index.toDouble(),
          credit.toDouble(),
          debit.toDouble(),
          monthStr,
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _MonthlyAndYearlyChartData.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SizedBox(
            height: 350,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SfCartesianChart(
                title: const ChartTitle(text: 'Monthly Credit vs Debit'),
                legend: const Legend(isVisible: true),
                tooltipBehavior: _tooltipBehavior,
                primaryXAxis: CategoryAxis(
                  title: AxisTitle(text: 'Month'),
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
                    dataSource: _MonthlyAndYearlyChartData,
                    xValueMapper: (data, _) => data.monthLabel,
                    yValueMapper: (data, _) => data.credited,
                    color: Colors.green.withOpacity(0.5),
                  ),
                  SplineSeries<MonthlyAndYearlyChartData, String>(
                    name: 'Debited',
                    dataSource: _MonthlyAndYearlyChartData,
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
