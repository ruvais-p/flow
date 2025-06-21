import 'package:flow/data/lists/chart_color_palette_list.dart';
import 'package:flow/model/chart.dart';
import 'package:flow/screens/history_screen/widgets/chart_headline_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const ChartHeadingWidget(title: "Credit Category Breakdown",),
            BasicChartUnit(dataSet: creditData),
            const SizedBox(height: 40),
            const ChartHeadingWidget(title: "Debit Category Breakdown",),
            BasicChartUnit(dataSet: debitData),
          ],
        ),
      ),
    );
  }
}

class BasicChartUnit extends StatelessWidget {
  const BasicChartUnit({
    super.key,
    required this.dataSet,
  });

  final List<ChartData> dataSet;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: SfCircularChart(
        tooltipBehavior: TooltipBehavior(
          enable: true,
          textStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
          activationMode: ActivationMode.singleTap,
          color: Theme.of(context).colorScheme.secondary,
         ),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          alignment: ChartAlignment.far,
          textStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.w700,
          ),
          orientation: LegendItemOrientation.auto,
          overflowMode: LegendItemOverflowMode.wrap
        ),
        palette: chartColorPaletteList,
        series: <CircularSeries<ChartData, String>>[
          DoughnutSeries<ChartData, String>(
            dataSource: dataSet,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            dataLabelMapper: (ChartData data, _) => "${data.x}: ₹${data.y.toStringAsFixed(0)}",
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          )
        ],
      ),
    );
  }
}
