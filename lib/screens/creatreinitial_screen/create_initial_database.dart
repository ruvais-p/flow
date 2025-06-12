import 'package:flow/model/regex_models/south_indian_bank.dart';
import 'package:flow/screens/detaisl.dart';
import 'package:flow/screens/limitset_screen/limit_set_screen.dart';
import 'package:flow/services/database_servieces.dart';
import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateInitialDatabase extends StatefulWidget {
  const CreateInitialDatabase({super.key});

  @override
  State<CreateInitialDatabase> createState() => _CreateInitialDatabaseState();
}

class _CreateInitialDatabaseState extends State<CreateInitialDatabase> {
  final DatabaseService _databaseService = DatabaseService.instance;
  static const platform = MethodChannel('uniqueChannel');
  List<Map<String, dynamic>> _smsMessages = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    loadAndNavigate();
  }

  Future<void> loadAndNavigate() async {
    await fetchSmsMessages();
    await parseAndInsertMessages();

    // Wait 2 seconds then navigate
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LimitSetScreen()),
      );
    });
  }

  Future<void> fetchSmsMessages() async {
  try {
    final filterString = await _databaseService.getBankCode(); // ✅ Await here
    final DateTime? afterDate = null;

    final List<dynamic> result = await platform.invokeMethod(
      'getAllSMS',
      {
        'filter': filterString ?? '', // ✅ Handle null safely
        'date': afterDate?.millisecondsSinceEpoch.toString(),
      },
    );

    setState(() {
      _smsMessages = result.cast<Map<dynamic, dynamic>>().map(
            (e) => e.map((k, v) => MapEntry(k.toString(), v)),
          ).toList();
      _isLoading = false;
    });

    await parseAndInsertMessages();
  } on PlatformException catch (e) {
    setState(() {
      _error = "Error: ${e.message}";
      _isLoading = false;
    });
  }
}


  Future<void> parseAndInsertMessages() async {
    for (var msg in _smsMessages) {
      final body = msg['body'];
      final timestamp = msg['date'];

      if (body != null && timestamp != null) {
        final parsedData = parseSouthIndianBankSms(body, DateTime.fromMillisecondsSinceEpoch(timestamp));
        if (parsedData != null) {
          await _databaseService.insertTransaction(
            message: body,
            amount: parsedData['amount'],
            balance: parsedData['balance'],
            date: parsedData['date'],
            time: parsedData['time'],
            consumer: parsedData['consumer'],
            transactionType: parsedData['mode'],
            category: "unknown",
            upiid: parsedData['upiid'] ?? '',
            bank: "SIB"
          );
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _error != null
                ? Text(_error!)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer circle showing SMS count
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.lightred,
                                width: 5,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: Theme.of(context).textTheme.displayMedium,
                                children: [
                                  const TextSpan(text: 'Collected\n'),
                                  TextSpan(
                                    text: '${_smsMessages.length}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                          color: AppColors.lightred,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 36,
                                        ),
                                  ),
                                  const TextSpan(text: '\nmessages'),
                                ],
                              ),
                            ),
                          ),
                          // Small processing indicator
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: const CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Processing your messages...",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
      ),
    );
  }
  
}
