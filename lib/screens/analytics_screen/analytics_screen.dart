import 'package:flow/screens/analytics_screen/widgets/category_donugt_chart.dart';
import 'package:flow/screens/analytics_screen/widgets/monthly_credit_and_debit_chart.dart';
import 'package:flutter/material.dart';
import 'package:flow/screens/analytics_screen/widgets/analystic_app_bar.dart';
import 'package:flow/screens/analytics_screen/widgets/yearly_credit_and_debit_chart.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int thisYear = DateTime.now().year;
    int lastYear = thisYear - 1;
    return Scaffold(
      appBar: AnalysticAppbar(context),
      body: ListView(
  padding: const EdgeInsets.all(16),
  children:  [
    MonthlyChartWidget(),
    SizedBox(height: 32),
    YearlyChartWidget(),
    SizedBox(height: 32),
    YearlyCategoryChartSection(year: thisYear), // current year
    SizedBox(height: 32),
    YearlyCategoryChartSection(year: lastYear), // last year
  ],
)

    );
  }
}
