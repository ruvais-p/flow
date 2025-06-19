import 'package:flow/screens/history_screen/functions/date_picker_function_history_screen.dart';
import 'package:flow/screens/history_screen/provider/history_provider.dart';
import 'package:flow/screens/history_screen/widgets/history_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedDate = context.watch<HistoryProvider>().selectedDate;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              HistoryAppBar(
                onBack: () => Navigator.pop(context),
                onCalendar: () => pickDate(context),
              ),
              const SizedBox(height: 20),
              if (selectedDate != null)
                Text(
                  'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                  style: const TextStyle(fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
