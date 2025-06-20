
import 'package:flow/common/alert_box_for_categories_changing.dart';
import 'package:flow/model/data.dart';
import 'package:flow/screens/history_screen/provider/history_provider.dart';
import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

    return GestureDetector(
      onTap: () {
        showCategoryDialog(context, data.id ?? 0, data.category, (){});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkgray,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.consumer,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: AppColors.whitecolor,
                      ),
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
            // Consumer again (probably can be message instead?)
            Text(
              data.consumer,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: AppColors.lightgray,
                  ),
            ),
            const SizedBox(height: 6),
            // Bottom Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Category badge
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.lightred,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text(
                    data.category,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: AppColors.whitecolor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                // Time & Date
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
      ),
    );
  }
}