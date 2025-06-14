import 'package:flow/model/weekexpenss.dart';
import 'package:flow/services/database_servieces.dart';
import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LastMonthChart extends StatelessWidget {
  LastMonthChart({super.key});

  final DatabaseService _databaseService = DatabaseService.instance;

  Future<Map<String, List<WeakExpenss>>> getChartData() async {
    final debitData = await _databaseService.fetchLastMonthData('DEBIT');
    final creditData = await _databaseService.fetchLastMonthData('CREDIT');
    return {'debit': debitData, 'credit': creditData};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<WeakExpenss>>>(
      future: getChartData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        return Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.lightgray,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SfCartesianChart(
            backgroundColor: AppColors.lightgray,
            plotAreaBorderColor: AppColors.whitecolor,
            legend: Legend(isVisible: true),
            tooltipBehavior: TooltipBehavior(enable: true),
            primaryXAxis: CategoryAxis(
              labelRotation: 90,
            ),
            primaryYAxis: NumericAxis(
            ),
            series: <CartesianSeries<WeakExpenss, String>>[
              ColumnSeries<WeakExpenss, String>(
                name: 'Debited',
                dataSource: data['debit']!,
                xValueMapper: (WeakExpenss sales, _) => sales.year,
                yValueMapper: (WeakExpenss sales, _) => sales.sales,
                legendIconType: LegendIconType.circle,
                color: AppColors.lightred,
              ),
              ColumnSeries<WeakExpenss, String>(
                name: 'Credited',
                dataSource: data['credit']!,
                xValueMapper: (WeakExpenss sales, _) => sales.year,
                yValueMapper: (WeakExpenss sales, _) => sales.sales,
                legendIconType: LegendIconType.circle,
                color: AppColors.darkgray,
              ),
            ],
          ),
        );
      },
    );
  }
}
