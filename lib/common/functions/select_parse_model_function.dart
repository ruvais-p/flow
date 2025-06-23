import 'package:flow/model/regex_models/south_indian_bank.dart';

Map<String, dynamic>? selectParseBankModel(String message, DateTime timestamp, String bankCode){
  switch (bankCode) {
    case "SIBSMS":
      return parseSouthIndianBankSms(message, timestamp);
    default:
    return null;
  }
} 
