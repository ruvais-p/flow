import 'package:flow/screens/homepage_screen/provider/provider.dart';
import 'package:flow/screens/homepage_screen/widgets/lastmonth_expenss_chart_widget.dart';
import 'package:flow/screens/homepage_screen/widgets/monthly_expenss_chart_widget.dart';
import 'package:flow/screens/homepage_screen/widgets/weakly_expenss_chart_widget.dart';
import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChartWidget extends StatelessWidget {
  ChartWidget({super.key});

  final List<String> titles = ["This week", "This month", "Last month"];
  final List<Widget> charts = [WeeklyChart(), MonthlyChart(), LastMonthChart()];

  @override
  Widget build(BuildContext context) {
    final chartProvider = context.watch<ChartTabProvider>();
    final selectedChartIndex = chartProvider.selectedIndex;

    return Column(
      children: [
        SizedBox(
          height: 60,
          child: ListView.builder(
            itemCount: titles.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 10),
            itemBuilder: (context, index) {
              final isSelected = index == selectedChartIndex;

              return GestureDetector(
                onTap: () {
                  context.read<ChartTabProvider>().setIndex(index);
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 10, top: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.lightred : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.lightred : Theme.of(context).colorScheme.secondary,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    titles[index],
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: isSelected ? AppColors.whitecolor : Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 350,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.2, 0), // Slide from right
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey<int>(selectedChartIndex),
              child: charts[selectedChartIndex],
            ),
          ),
        ),
      ],
    );
  }
}
