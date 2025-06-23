import 'package:decimal/decimal.dart';
import 'package:flow/screens/analytics_screen/models/monthly_chart_model.dart';
import 'package:flow/screens/analytics_screen/services/analystic_db_services.dart';
import 'package:flow/screens/analytics_screen/widgets/chart_title_widget.dart';
import 'package:flow/theme/colors.dart';
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
            height: 370,
            child: Column(
              children: [
                ChartTitleWidget(context, 'Yearly Credit vs Debit'),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16 , top: 10),
                  child: SfCartesianChart(
                    legend: const Legend(isVisible: true),
                    tooltipBehavior: _tooltipBehavior,
                    primaryXAxis: CategoryAxis(
                      title: AxisTitle(text: 'Year',
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
                        dataSource: _yearlyChartData,
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
                        dataSource: _yearlyChartData,
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
