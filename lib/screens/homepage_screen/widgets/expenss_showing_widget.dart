
import 'package:flow/screens/homepage_screen/services/homepage_db_services.dart';
import 'package:flow/screens/homepage_screen/widgets/expenss_shower_widget.dart';
import 'package:flutter/material.dart';

class ExpenssShowingWidget extends StatelessWidget {
  const ExpenssShowingWidget({
    super.key,
    required HomepageDbServices databaseService,
  }) : _databaseService = databaseService;

  final HomepageDbServices _databaseService;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
      future: _databaseService.getTodayAndMonthTotals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Failed to load data');
        } else {
          final data = snapshot.data!;
          return ExpenssShower(
            todayCredited: data['todayCredited'] ?? 0.0,
            thismonthCredited: data['monthCredited'] ?? 0.0,
            todayDebited: data['todayDebited'] ?? 0.0,
            thismonthDebited: data['monthDebited'] ?? 0.0,
          );
        }
      },
    );
  }
}
