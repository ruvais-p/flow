
import 'package:flow/data/lists/chart_color_palette_list.dart';
import 'package:flow/model/chart.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
