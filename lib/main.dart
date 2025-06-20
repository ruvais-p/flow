import 'package:flow/screens/history_screen/provider/history_provider.dart';
import 'package:flow/screens/homepage_screen/provider/provider.dart';
import 'package:flow/screens/welcome_screen/welcome_screen.dart';
import 'package:flow/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flow/screens/homepage_screen/homepage.dart';
import 'package:flow/screens/creatreinitial_screen/create_initial_database.dart';
import 'package:flow/services/database_servieces.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure async before runApp

  Gemini.init(apiKey: 'AIzaSyD4hxY9Ri5rCP9G1SnUkUyULVWPN6CotKo');

  int? status = await DatabaseService.instance.getUserStatus();
  int? initiated = await DatabaseService.instance.getInitiatedrStatus();

runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TrendingPageProvider()),
      ChangeNotifierProvider(create: (_) => ChartTabProvider()),
      ChangeNotifierProvider(create: (_) => TransactionListProvider()),
      ChangeNotifierProvider(create: (_) => HistoryDataProvider())
    ],
    child: MyApp(status: status, initiated: initiated),
  ),
);
}

class MyApp extends StatelessWidget {
  final int? status;
  final int? initiated;

  const MyApp({super.key, required this.status, required this.initiated});

  @override
  Widget build(BuildContext context) {
    Widget homeWidget;
    if (status == 1 && initiated == 1) {
      homeWidget = const Homepage();
    } else if (status == 1 && initiated == 0) {
      homeWidget = const CreateInitialDatabase();
    } else {
      homeWidget = const WelcomeScreen();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: Apptheme.lightMode,
      darkTheme: Apptheme.darkMode,
      //home: Homepage(),
      home: homeWidget,
      //home: MessageParserPage(),
    );
  }
}
