
import 'package:flow/screens/analytics_screen/analytics_screen.dart';
import 'package:flow/screens/history_screen/widgets/history_appbar_widget.dart';
import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';

AppBar HistoryAppBarWidget(BuildContext context, bool showAnalysisButton) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,),
        child: HistoryAppBar(onBack: () => Navigator.pop(context)),
      ),
      leadingWidth: 100,
      actions: [
        showAnalysisButton ? GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AnalyticsScreen(),)),
          child: Container(
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.lightred,
                width: 2,
              )
            ),
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              "Analysis",
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ),
        ) : SizedBox()
      ],
    );
  }

