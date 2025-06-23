import 'package:flow/common/utils/alert_box_for_categories_changing.dart';
import 'package:flow/model/data.dart';
import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuildAnimatedCard{
 static String convertTo12Hour(String time24) {
  final parsedTime = DateFormat("HH:mm:ss").parse(time24);
  return DateFormat("hh:mm a").format(parsedTime);
}

static Widget buildAnimatedCard(
  int index,
  int currentPage,
  Data data,
  BuildContext context,
  VoidCallback onCategoryUpdated,
) {
  bool isCurrent = index == currentPage;
  return GestureDetector(
    onTap: () {
      showCategoryDialog(
        context,
        data.id ?? 0,
        data.category,
        onCategoryUpdated,
      );
    },
      child: AnimatedContainer(
        width: MediaQuery.of(context).size.width * 0.45,
        height: MediaQuery.of(context).size.width * 0.45,
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: isCurrent ? 20 : 40),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: index == currentPage ? AppColors.darkgray : AppColors.lightgray,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Text("₹${data.amount}", 
              style: Theme.of(context).textTheme.displayLarge!.copyWith(color: AppColors.whitecolor),
              )
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Text(data.transactionType, 
              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: data.transactionType != 'CREDIT' ? AppColors.lightred : AppColors.green, fontWeight: FontWeight.bold, shadows: [Shadow(color: AppColors.whitecolor)]),
              )
            ),
            Positioned(
              left: 0,
              top: 30,
              child: Text(data.consumer, 
              style: Theme.of(context).textTheme.displayLarge!.copyWith(color: AppColors.whitecolor, fontWeight: FontWeight.bold,),
              )
            ),
            Positioned(
              right: 0,
              top: 60,
              child: Text(data.consumer, 
              style: Theme.of(context).textTheme.displaySmall!.copyWith(color: AppColors.lightgray, fontWeight: FontWeight.bold,),
              )
            ),
            Positioned(
              right: 0,
              top: 90,
              child: Row(
                children: [
                  Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: index == currentPage ? AppColors.lightred : AppColors.darkred,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(data.category, style: Theme.of(context).textTheme.displaySmall!.copyWith(color: AppColors.whitecolor, fontWeight: FontWeight.bold,),),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,border: Border.all(color: AppColors.lightred, width: 3),
                      shape: BoxShape.circle,
                    ),
                    child:Icon( Icons.fastfood_sharp, color: AppColors.lightred,),
                  )
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Text(
                convertTo12Hour(data.time),
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: AppColors.whitecolor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Text(
                DateFormat('dd MMMM yyyy').format(DateTime.parse(data.date)),
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: AppColors.whitecolor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15
                ),
              ),
            )
          ],
        )
      ),
    );
  }

}

 