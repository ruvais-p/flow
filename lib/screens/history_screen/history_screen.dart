import 'package:flow/model/data.dart';
import 'package:flow/screens/history_screen/functions/date_picker_function_history_screen.dart';
import 'package:flow/screens/history_screen/provider/history_provider.dart';
import 'package:flow/screens/history_screen/widgets/circular_ionbutton_history_screen.dart';
import 'package:flow/screens/history_screen/widgets/date_controller_widget.dart';
import 'package:flow/screens/history_screen/widgets/history_appbar_widget.dart';
import 'package:flow/screens/homepage_screen/widgets/expenss_shower_container_widget.dart';
import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
Widget build(BuildContext context) {

    String monthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }

  final provider = context.watch<HistoryDataProvider>();
  final selectedDate = provider.selectedDate;

  final formattedMonthYear = "${monthName(selectedDate.month)} ${selectedDate.year}";

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          HistoryAppBar(
            onBack: () => Navigator.pop(context),
          ),
          const SizedBox(height: 20),
          DateControllerWidget(
            dateTitle: formattedMonthYear,
            debitedAmount: provider.totalDebited,
            creditedAmount: provider.totalCredited,
            leftButton: () {
              provider.goToPreviousMonth();
            },
            rightButton: () {
              provider.goToNextMonth();
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...provider.monthlyTransactions.map((e) => ExpenssShowerContainerWidget(data: e)),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

}


class ExpenssShowerContainerWidget extends StatelessWidget {
  final Data data;

  const ExpenssShowerContainerWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {

      String convertTo12Hour(String time24) {
  final parsedTime = DateFormat("HH:mm:ss").parse(time24);
  return DateFormat("hh:mm a").format(parsedTime);
}
    final isCredit = data.transactionType.toLowerCase() == 'credit';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkgray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.consumer,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: AppColors.whitecolor
                )
              ),
              Text(
                "${isCredit ? '+' : '-'} ₹${data.amount?.toStringAsFixed(2) ?? '0.00'}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isCredit ? AppColors.green : AppColors.red,
                ),
              ),
            ],
          ),
          Text(
            data.consumer,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: AppColors.lightgray
            )
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.lightred,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(data.category, style: Theme.of(context).textTheme.displaySmall!.copyWith(color: AppColors.whitecolor, fontWeight: FontWeight.bold,),),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                convertTo12Hour(data.time),
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: AppColors.whitecolor,
                  fontWeight: FontWeight.bold,
                ),
              ),
                  Text(
                    DateFormat('E, d').format(DateTime.parse(data.date)),
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: AppColors.whitecolor,
                  fontWeight: FontWeight.bold,
                ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
