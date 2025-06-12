import 'package:flow/screens/detaisl.dart';
import 'package:flow/screens/homepage_screen/homepage.dart';
import 'package:flow/screens/limitset_screen/widgets/basic_container_widget.dart';
import 'package:flow/services/database_servieces.dart';
import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';

class LimitSetScreen extends StatefulWidget {
  const LimitSetScreen({super.key});

  @override
  State<LimitSetScreen> createState() => _LimitSetScreenState();
}

class _LimitSetScreenState extends State<LimitSetScreen> {
  final TextEditingController _dialyLimi = TextEditingController();
  final TextEditingController _monthlyLimi = TextEditingController();
  final DatabaseService _databaseService = DatabaseService.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 10,
            right: 10,
            bottom: 60,
          ),
          child: Column(
            children: [
              BasicWidget(isInvert: true, controller: _dialyLimi, heading: "Set your\ndaily limit", hinttext: "100",),
              BasicWidget(isInvert: false, controller: _monthlyLimi, heading: "Set your\nmonthly limit", hinttext: "3000",),
              Spacer(),
              TextButton(
                onPressed: () {
                  int daily = int.tryParse(_dialyLimi.text) ?? 100;
                  int monthly = int.tryParse(_monthlyLimi.text) ?? 3000;

                  _databaseService.addUserLimit(daily, monthly);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage()),
                  );
                },
                child: Text(
                  "Confirm",
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: AppColors.lightred,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
