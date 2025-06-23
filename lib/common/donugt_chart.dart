import 'package:flow/data/lists/chart_color_palette_list.dart';
import 'package:flow/model/chart.dart';
import 'package:flow/theme/colors.dart';
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
    return Column(
      children: [
        // Doughnut chart
        SizedBox(
          height: 300,
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
            legend: const Legend(isVisible: false), // Hide default legend
            palette: chartColorPaletteList,
            series: <CircularSeries<ChartData, String>>[
              DoughnutSeries<ChartData, String>(
                dataSource: dataSet,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                dataLabelMapper: (ChartData data, _) =>
                    "${data.x}: ₹${data.y.toStringAsFixed(0)}",
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              )
            ],
          ),
        ),

        // Custom legend
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Column(
            children: List.generate(dataSet.length, (index) {
              final data = dataSet[index];
              final color = chartColorPaletteList[index % chartColorPaletteList.length];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        data.x,
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    Text(
                      "₹${data.y.toStringAsFixed(0)}",
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
