
import 'package:flow/screens/history_screen/provider/history_provider.dart';
import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OptionSelectorWidget extends StatelessWidget {
  const OptionSelectorWidget({
    super.key,
    required this.titles,
    required this.selectedChartIndex,
  });

  final List<String> titles;
  final int selectedChartIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
              height: 60,
              child: ListView.builder(
    itemCount: titles.length,
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, index) {
      final isSelected = index == selectedChartIndex;
    
      return GestureDetector(
        onTap: () {
          context.read<HistoryDataProvider>().setIndex(index);
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 10, top: 15),
          padding: const EdgeInsets.symmetric(horizontal: 37.5),
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
            );
  }
}
