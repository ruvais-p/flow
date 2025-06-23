
  import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';

Container ChartTitleWidget(BuildContext context, String title) {
    return Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.darkgray,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(title, style: Theme.of(context).textTheme.displayMedium!.copyWith(color: AppColors.whitecolor)),
              );
  }