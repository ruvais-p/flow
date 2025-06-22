
  import 'package:flow/screens/history_screen/widgets/history_appbar_widget.dart';
import 'package:flutter/material.dart';

AppBar AnalysticAppbar(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: HistoryAppBar(onBack: () => Navigator.pop(context),),
      ),
      leadingWidth: 100,
    );
  }