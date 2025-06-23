import 'package:flow/common/utils/donugt_chart.dart';
import 'package:flow/model/chart.dart';
import 'package:flow/screens/history_screen/widgets/chart_headline_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flow/screens/history_screen/provider/history_provider.dart';

class PieChartSection extends StatelessWidget {
  const PieChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<HistoryDataProvider>();

    // Convert pie data into chart data
    List<ChartData> convertMapToChartData(Map<String, double> pieData) {
      return pieData.entries
          .map((e) => ChartData(e.key, e.value))
          .toList();
    }

    final creditData = convertMapToChartData(historyProvider.creditCategoryPieData);
    final debitData = convertMapToChartData(historyProvider.debitCategoryPieData);

    final bool isAllDataEmpty = creditData.isEmpty && debitData.isEmpty;

    return Expanded(
      child: isAllDataEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  "No transactions found...",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  ChartHeadingWidget(title: "Credit Category Breakdown"),
                  BasicChartUnit(dataSet: creditData),
                  const SizedBox(height: 40),
                  ChartHeadingWidget(title: "Debit Category Breakdown"),
                  BasicChartUnit(dataSet: debitData),
                ],
              ),
            ),
    );
  }
}
