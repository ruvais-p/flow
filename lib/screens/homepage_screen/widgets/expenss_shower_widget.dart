
import 'package:flow/screens/history_screen/history_screen.dart';
import 'package:flow/screens/homepage_screen/widgets/expenss_shower_container_widget.dart';
import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';

class ExpenssShower extends StatelessWidget {
  const ExpenssShower({
    super.key, required this.todayCredited, required this.thismonthCredited, required this.todayDebited, required this.thismonthDebited,
  });
  final double todayCredited;
  final double thismonthCredited;
  final double todayDebited;
  final double thismonthDebited;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width ;
    return Row(
      children: [
        Column(
          children: [
            ExpenssShowerContainer(isCreated: true, heading: "Debited", amount: todayDebited,),
            Text("Today", style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: AppColors.darkred
            ),),
            ExpenssShowerContainer(isCreated: false, heading: "Credited", amount: todayCredited,),
          ],
        ),
        CircleAvatar(
          radius: width * 0.0509,
          backgroundColor: AppColors.lightred,
          child: IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
          }, icon: Icon(Icons.history, color: AppColors.whitecolor,)),
        ),
        Column(
          children: [
            ExpenssShowerContainer(isCreated: true, heading: "Debited", amount: thismonthDebited,),
            Text("This month", style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: AppColors.darkred
            ),),
            ExpenssShowerContainer(isCreated: false, heading: "Credited", amount: thismonthCredited,),
          ],
        ),
      ],
    );
  }
}