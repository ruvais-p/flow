import 'package:flow/screens/bankselection_screen/widgets/bank_selection_headline_widget.dart';
import 'package:flow/screens/bankselection_screen/widgets/bankcard_widget.dart';
import 'package:flow/screens/creatreinitial_screen/create_initial_database.dart';
import 'package:flow/services/database_servieces.dart';
import 'package:flutter/material.dart';

class BankSelectionScreen extends StatefulWidget {
  const BankSelectionScreen({super.key});

  @override
  State<BankSelectionScreen> createState() => _BankSelectionScreenState();
}

class _BankSelectionScreenState extends State<BankSelectionScreen> {
  int currentIndex = 0;
  final DatabaseService _databaseService = DatabaseService.instance;

  final List<String> banks = [
    'SBI',
    'Axis Bank',
    'South Indian Bank',
    'Canara Bank',
    'ICICI Bank',
    'Federal Bank',
    'Kerala Gramin Bank',
  ];

  final List<String> bankcodes = [
    'SBI',
    'Axis Bank',
    'SIBSMS',
    'Canara Bank',
    'ICICI Bank',
    'Federal Bank',
    'Kerala Gramin Bank',
  ];

  void _handleSwipe(DragEndDetails details) {
    if (details.primaryVelocity == null) return;

    setState(() {
      if (details.primaryVelocity! < 0 && currentIndex < banks.length - 1) {
        currentIndex++;
      } else if (details.primaryVelocity! > 0 && currentIndex > 0) {
        currentIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final double smallContainerHeight = screenHeight * 0.1345;
    final double smallContainerWidth = screenWidth * 0.248;
    final double largeContainerHeight = screenHeight * 0.1682;
    final double largeContainerWidth = screenWidth * 0.364;

    return Scaffold(
      body: Column(
        children: [
          const HeadlineSection(),
          SizedBox(height: screenHeight * 0.15),
          GestureDetector(
            onHorizontalDragEnd: _handleSwipe,
            child: BankCards(
              currentIndex: currentIndex,
              smallContainerWidth: smallContainerWidth,
              smallContainerHeight: smallContainerHeight,
              banks: banks,
              largeContainerWidth: largeContainerWidth,
              largeContainerHeight: largeContainerHeight,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              _databaseService.addUserBankData(
                banks[currentIndex], bankcodes[currentIndex]
              );
              Navigator.push(context, MaterialPageRoute(builder:(context) => CreateInitialDatabase(),));
            },
            child: Text(
              "Select",
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
