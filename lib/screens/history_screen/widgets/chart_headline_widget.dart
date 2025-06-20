
import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';

class ChartHeadingWidget extends StatelessWidget {
  const ChartHeadingWidget({
    super.key, required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.darkgray,
        borderRadius: BorderRadius.circular(20)
    
      ),
      child: Text(title, style: Theme.of(context).textTheme.displayMedium!.copyWith(
        fontSize: 18,
        color: AppColors.whitecolor
      )));
  }
}

