
import 'package:flow/screens/homepage_screen/services/homepage_db_services.dart';
import 'package:flow/services/database_servieces.dart';
import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HeatMapWidget extends StatelessWidget {
  const HeatMapWidget({
    super.key,
    required HomepageDbServices databaseService,
  }) : _databaseService = databaseService;

  final HomepageDbServices _databaseService;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.darkgray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: FutureBuilder<Map<DateTime, int>>(
        future: _databaseService.getTransactionCountPerDayFromDb(), // The function we defined above
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); 
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return Text('No data available');
          }
    
          final calendarData = snapshot.data!;   
       
          return Stack(
            children: [
              Positioned(
                top: 10,
                child: Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width - 90,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
              HeatMapCalendar(
                defaultColor: AppColors.whitecolor,
                textColor: AppColors.darkgray,
                weekTextColor: AppColors.whitecolor,
                showColorTip: false,
                flexible: true,
                colorMode: ColorMode.opacity,
                datasets: calendarData,
                colorsets: { 1: AppColors.lightred },
                onClick: (date) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$date')),
                  );
                },
              ),
              
            ],
          );
        },
        
      ),
    );
  }
}