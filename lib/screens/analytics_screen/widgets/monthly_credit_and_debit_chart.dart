import 'package:flow/screens/analytics_screen/widgets/chart_title_widget.dart';
import 'package:flow/theme/colors.dart';
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
            height: 370,
            child: Column(
              children: [
                ChartTitleWidget(context, 'Monthly Credit vs Debit'),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16 , top: 10),
                  child: SfCartesianChart(
                    legend: const Legend(isVisible: true),
                    tooltipBehavior: _tooltipBehavior,
                    primaryXAxis: CategoryAxis(
                      title: AxisTitle(text: 'Month',
                        textStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary
                        )
                      ),
                      majorGridLines: const MajorGridLines(width: 0),
                      labelStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary
                      ),
                    ),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(text: 'Amount',
                        textStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary
                        )
                      ),
                      labelFormat: '{value}',
                      axisLine: const AxisLine(width: 0),
                      majorTickLines: const MajorTickLines(size: 0),
                      labelStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary
                      ),
                    ),
                    series: <CartesianSeries>[
                      SplineSeries<MonthlyAndYearlyChartData, String>(
                        name: 'Credited',
                        dataSource: _MonthlyAndYearlyChartData,
                        xValueMapper: (data, _) => data.monthLabel,
                        yValueMapper: (data, _) => data.credited,
                        markerSettings: MarkerSettings(
                          isVisible: true,
                          color: AppColors.green,
                          height: 4,
                          width: 4,
                        ),
                        color: AppColors.green,
                        legendIconType: LegendIconType.circle,
                      ),
                      SplineSeries<MonthlyAndYearlyChartData, String>(
                        name: 'Debited',
                        dataSource: _MonthlyAndYearlyChartData,
                        xValueMapper: (data, _) => data.monthLabel,
                        yValueMapper: (data, _) => data.debited,
                        markerSettings: MarkerSettings(
                          isVisible: true,
                          color: AppColors.lightred,
                          height: 4,
                          width: 4,
                        ),
                        color: AppColors.lightred,
                        legendIconType: LegendIconType.circle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
