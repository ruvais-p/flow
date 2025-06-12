
import 'package:flow/screens/homepage_screen/widgets/addressing_segment.dart';
import 'package:flow/services/database_servieces.dart';
import 'package:flutter/material.dart';

class AddressingSegmentFutureBuilder extends StatelessWidget {
  const AddressingSegmentFutureBuilder({
    super.key,
    required DatabaseService databaseService,
  }) : _databaseService = databaseService;

  final DatabaseService _databaseService;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _databaseService.getUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // or a placeholder
        } else if (snapshot.hasError) {
          return const Text("Error loading name");
        } else {
          final userName = snapshot.data ?? 'User';
          return AddressingSegment(name: userName);
        }
      },
    );
  }
}
