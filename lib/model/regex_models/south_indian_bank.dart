Map<String, dynamic>? parseSouthIndianBankSms(String message, DateTime timestamp) {
  final lowerMsg = message.toLowerCase();
  
  // Enhanced mode detection - checks for debit/credit patterns
  String? mode;
  if (lowerMsg.contains('debit') || lowerMsg.contains('debited')) {
    mode = 'DEBIT';
  } else if (lowerMsg.contains('credit') || lowerMsg.contains('credited')) {
    mode = 'CREDIT';
  }
  
  // Fixed amount regex patterns with proper escaping and broader matching
  final amountRegexes = [
    // Pattern 1: "DEBIT:Rs 600.00" or "Credit:Rs. 100.00" - Fixed Rs pattern
    RegExp(r'(?:debit|credit)[:\s]*rs\.?\s*([0-9,]+(?:\.[0-9]{1,2})?)', caseSensitive: false),
    // Pattern 2: "A/c Debit:Rs. 600.00" - Fixed A/c escaping
    RegExp(r'a/c\s+(?:debit|credit)[:\s]*rs\.?\s*([0-9,]+(?:\.[0-9]{1,2})?)', caseSensitive: false),
    // Pattern 3: "is credited with Rs 100.00" - Fixed spacing
    RegExp(r'(?:credited|debited)\s+with\s+rs\.?\s*([0-9,]+(?:\.[0-9]{1,2})?)', caseSensitive: false),
    // Pattern 4: "INR 1000.00" or "Rs1000.00" - Added INR support and no-space Rs
    RegExp(r'(?:inr|rs)\.?\s*([0-9,]+(?:\.[0-9]{1,2})?)', caseSensitive: false),
    // Pattern 5: Generic amount pattern for fallback
    RegExp(r'([0-9,]+\.[0-9]{2})'),
  ];
  
  double? amount;
  for (final regex in amountRegexes) {
    final match = regex.firstMatch(message);
    if (match != null) {
      // Remove commas from amount string before parsing
      final amountStr = match.group(1)?.replaceAll(',', '') ?? '';
      amount = double.tryParse(amountStr);
      if (amount != null && amount > 0) break; // Ensure positive amount
    }
  }
  
  // Enhanced balance regex with better pattern matching
  final balanceRegexes = [
    // Pattern 1: "Bal:Rs 19535.21" - Fixed Rs pattern
    RegExp(r'bal(?:ance)?[:\s]*rs\.?\s*([0-9,]+(?:\.[0-9]{1,2})?)', caseSensitive: false),
    // Pattern 2: "Final balance is Rs 20285.21" - Fixed spacing
    RegExp(r'final\s+balance\s+is\s+rs\.?\s*([0-9,]+(?:\.[0-9]{1,2})?)', caseSensitive: false),
    // Pattern 3: "Available balance: Rs 1000.00"
    RegExp(r'available\s+balance[:\s]*rs\.?\s*([0-9,]+(?:\.[0-9]{1,2})?)', caseSensitive: false),
    // Pattern 4: "Bal Rs 1000.00" - Without colon
    RegExp(r'bal\s+rs\.?\s*([0-9,]+(?:\.[0-9]{1,2})?)', caseSensitive: false),
  ];
  
  double? balance;
  for (final regex in balanceRegexes) {
    final match = regex.firstMatch(message);
    if (match != null) {
      // Remove commas from balance string before parsing
      final balanceStr = match.group(1)?.replaceAll(',', '') ?? '';
      balance = double.tryParse(balanceStr);
      if (balance != null && balance >= 0) break; // Ensure non-negative balance
    }
  }
  
  // Fixed UPI ID extraction with more robust patterns
  final upiRegexes = [
    // Pattern 1: "UPI Ref No. 551921616206" - Most specific first
    RegExp(r'upi\s+ref(?:\s+no)?\.?\s*:?\s*(\d{12})', caseSensitive: false),
    // Pattern 2: "Ref No. 551921616206" - Alternative format
    RegExp(r'ref(?:\s+no)?\.?\s*:?\s*(\d{12})', caseSensitive: false),
    // Pattern 3: "UPI/SBIN/551921616206/PRAVEENKUMAR" - Extract middle number
    RegExp(r'upi/[a-zA-Z]+/(\d{9,})/[^/\s]+', caseSensitive: false),
    // Pattern 4: "UPI/FDRL/514860183537/FINSHA P/UPI" - Handle extra segments
    RegExp(r'upi/[a-zA-Z]+/(\d{9,})/[^/]+(?:/[^/\s]+)?', caseSensitive: false),
    // Pattern 5: Generic 12-digit number in UPI context
    RegExp(r'upi.*?(\d{12})', caseSensitive: false),
    // Pattern 6: Any 12-digit number (last resort)
    RegExp(r'(\d{12})'),
  ];
  
  String? upiid;
  for (int i = 0; i < upiRegexes.length; i++) {
    final regex = upiRegexes[i];
    final match = regex.firstMatch(message);
    if (match != null) {
      upiid = match.group(1);
      // Validate UPI ID length (should be 9-12 digits typically)
      if (upiid != null && upiid.length >= 9) {
        break;
      }
    }
  }
  
  // Enhanced consumer name extraction with better patterns
  final consumerRegexes = [
    // Pattern 1: "UPI/SBIN/551921616206/PRAVEENKUMAR" - Extract name after third slash
    RegExp(r'upi/[a-zA-Z]+/\d{9,}/([A-Z][A-Z0-9\s]+?)(?:/|$)', caseSensitive: false),
    // Pattern 2: "UPI/FDRL/514860183537/FINSHA P/UPI" - Extract name before /UPI
    RegExp(r'upi/[a-zA-Z]+/\d{9,}/([A-Z][A-Z0-9\s]+?)/[A-Z]+', caseSensitive: false),
    // Pattern 3: "Info: UPI/.../..." format
    RegExp(r'info:\s*upi/[a-zA-Z]+/\d{9,}/([A-Z][A-Z0-9\s]+?)(?:[/\s]|$)', caseSensitive: false),
    // Pattern 4: Consumer name from '/' till 'Bal:Rs' - "/MERCHANT NAME Bal:Rs"
    RegExp(r'/([A-Z][A-Z0-9\s]+?)\s+Bal:Rs', caseSensitive: false),
    // Pattern 5: Consumer name from '/' till '. Final' - "/MERCHANT NAME. Final"
    RegExp(r'UPI\/[A-Z]{3,4}\/\d+\/([A-Z][A-Z\s]+?)(?:\s*\.|$)', caseSensitive: false),
    RegExp(r'/([A-Z][A-Za-z\s]+?)/.(?=\s+Final)', caseSensitive: false),
    // Pattern 6: "to/from MERCHANT NAME" - Extract merchant name
    RegExp(r'(?:to|from)\s+([A-Z][A-Z0-9\s]{2,}?)(?:\s+on|\s+at|$)', caseSensitive: false),
    // Pattern 7: Generic name pattern after common keywords
    RegExp(r'(?:merchant|payee|sender)[:\s]+([A-Z][A-Z0-9\s]{2,}?)(?:\s|$)', caseSensitive: false),
  ];
  
  String? consumer;
  for (final regex in consumerRegexes) {
    final match = regex.firstMatch(message);
    if (match != null) {
      consumer = match.group(1)?.trim();
      // Clean up consumer name - remove trailing dots, slashes, etc.
      consumer = consumer?.replaceAll(RegExp(r'[\.\/\s]+$'), '');
      // Validate consumer name (should be at least 2 characters)
      if (consumer != null && consumer.length >= 2) break;
    }
  }
  
  // Enhanced timestamp extraction with multiple date formats
  final timestampRegexes = [
    // Pattern 1: "on 2024-01-15 14.30.25"
    RegExp(r'on\s+(\d{4}-\d{2}-\d{2})\s+(\d{2})\.(\d{2})\.(\d{2})', caseSensitive: false),
    // Pattern 2: "on 15/01/2024 14:30:25"
    RegExp(r'on\s+(\d{2})/(\d{2})/(\d{4})\s+(\d{2}):(\d{2}):(\d{2})', caseSensitive: false),
    // Pattern 3: "on 15-Jan-2024 14:30"
    RegExp(r'on\s+(\d{2})-([A-Za-z]{3})-(\d{4})\s+(\d{2}):(\d{2})', caseSensitive: false),
  ];
  
  String date = '';
  String time = '';
  bool timestampFound = false;
  
  for (final regex in timestampRegexes) {
    final match = regex.firstMatch(message);
    if (match != null) {
      if (regex == timestampRegexes[0]) {
        // Format: 2024-01-15 14.30.25
        date = match.group(1) ?? '';
        time = '${match.group(2)}:${match.group(3)}:${match.group(4)}';
      } else if (regex == timestampRegexes[1]) {
        // Format: 15/01/2024 14:30:25
        date = '${match.group(3)}-${match.group(2)}-${match.group(1)}';
        time = '${match.group(4)}:${match.group(5)}:${match.group(6)}';
      } else if (regex == timestampRegexes[2]) {
        // Format: 15-Jan-2024 14:30 (would need month conversion)
        // For now, use fallback timestamp
        continue;
      }
      timestampFound = true;
      break;
    }
  }
  
  if (!timestampFound) {
    // Fallback to provided timestamp
    date = '${timestamp.year.toString().padLeft(4, '0')}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
    time = '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
  }
  
  // Category determination based on consumer name and message content
  String category = _determineCategory(consumer, message);
  
  // Enhanced validation - return null if no meaningful data was extracted
  if (amount == null && balance == null && upiid == null && consumer == null && mode == null) {
    return null;
  }
  
  return {
    'amount': amount,
    'balance': balance,
    'upiid': upiid,
    'consumer': consumer,
    'mode': mode,
    'date': date,
    'time': time,
    'category': category,
    // Add debug info for troubleshooting (remove in production)
    '_raw_message': message, // For debugging
  };
}

String _determineCategory(String? consumer, String message) {
  if (consumer == null) {
    // Check message content for ATM withdrawal patterns
    if (message.toLowerCase().contains('atm') || 
        message.toLowerCase().contains('cash withdrawal') ||
        message.toLowerCase().contains('withdrawal')) {
      return 'ATM Withdrawal';
    }
    return 'Other';
  }
  
  final lowerConsumer = consumer.toLowerCase();
  final lowerMessage = message.toLowerCase();
  
  // Travel & Transportation
  if (_containsAny(lowerConsumer, [
    'irctc', 'uts', 'kmrl', 'metro', 'transport', 'railway', 'train',
    'bus', 'taxi', 'uber', 'ola', 'rapido', 'auto', 'cab', 'redbus',
    'ksrtc', 'rtc', 
  ])) {
    return 'Transportation';
  }
  
  // Food & Dining (Online food delivery)
  if (_containsAny(lowerConsumer, [
    'swiggy', 'zomato', 'uber eats', 'ubereats', 'foodpanda', 'dominos',
    'pizza hut', 'kfc', 'mcdonalds', 'burger king', 'subway',
    'dunzo', 'food delivery', 'restaurant', 'cafe', 'hotel',
    'biryani', 'food', 'eat', 'dine', 'mandi', 'bakes', 'bakery','juice', 'ice cream', 'peni', 
    'cusat rest', 'rest', 'thattukada', 'food', 'food court', 'tea', 'coffee',
    'tea shop',  
  ])) {
    return 'Food & Dining';
  }
  
  // Groceries & Essentials
  if (_containsAny(lowerConsumer, [
    'instamart', 'zepto', 'blinkit', 'grofers', 'bigbasket', 'naturebasket', 'jio mart'
    'grocery', 'supermarket', 'hypermarket', 'fresh', 'organic',
    'vegetables', 'fruits', 'milk', 'bread', 'essentials',
    'dmart', 'reliance fresh', 'spencer', 'more', 'star bazaar',
    'easyday', 'nilgiris', 'knh', 'store', 'trade', 'mart', 'hypermarket', 'market', 'grocery', 
  ])) {
    return 'Groceries';
  }
  
  // Healthcare
  if (_containsAny(lowerConsumer, [
    'medical', 'pharmacy', 'drugs', 'clinic', 'hospital', 'doctor',
    'apollo', 'fortis', 'max', 'medplus', 'netmeds', 'pharmeasy',
    '1mg', 'healthcare', 'health', 'medicine', 'diagnostic',
    'lab', 'pathology', 'dental', 'eye care', 'physiotherapy', 'medi',
  ])) {
    return 'Healthcare';
  }
  
  // Online Shopping & E-commerce
  if (_containsAny(lowerConsumer, [
    'amazon', 'flipkart', 'myntra', 'ajio', 'nykaa', 'meesho',
    'paytm mall', 'tata cliq', 'snapdeal', 'shopclues', 'limeroad',
    'jabong', 'koovs', 'bewakoof', 'urban ladder', 'pepperfry',
    'online', 'ecommerce',
  ])) {
    return 'Online Shopping';
  }
  
  // Utilities
  if (_containsAny(lowerConsumer, [
    'electricity', 'water', 'gas', 'internet', 'mobile', 'broadband',
    'wifi', 'telecom', 'airtel', 'jio', 'vi', 'vodafone', 'idea',
    'bsnl', 'mtnl', 'tata sky', 'dish tv', 'sun direct', 'videocon',
    'bescom', 'kseb', 'tneb', 'mseb', 'pseb', 'wbsedcl', 'cesc',
    'bill payment', 'recharge', 'postpaid', 'prepaid', 'indian' , 'bharath', 
  ])) {
    return 'Utilities';
  }
  
  // Entertainment
  if (_containsAny(lowerConsumer, [
    'netflix', 'prime video', 'hotstar', 'zee5', 'sonyliv', 'voot',
    'spotify', 'youtube', 'music', 'gaming', 'steam', 'playstation',
    'xbox', 'movie', 'cinema', 'theatre', 'bookmyshow', 'paytm movies',
    'entertainment', 'subscription', 'ott', 'streaming', 'spotify', 'turf', 'pvr', 'cinepolis', 'film'
  ])) {
    return 'Entertainment';
  }
  
  // Education
  if (_containsAny(lowerConsumer, [
    'school', 'college', 'university', 'education', 'course', 'fees', 'fee',
    'tuition', 'coaching', 'byju', 'unacademy', 'vedantu', 'extramarks',
    'toppr', 'study', 'learning', 'books', 'exam', 'test', 'certification'
  ])) {
    return 'Education';
  }
  
  // Investment & Financial Services
  if (_containsAny(lowerConsumer, [
    'mutual fund', 'sip', 'investment', 'stock', 'equity', 'trading',
    'zerodha', 'groww', 'upstox', 'angel broking', 'hdfc securities',
    'icici direct', 'kotak securities', 'sharekhan', 'edelweiss',
    'nippon', 'aditya birla', 'sbi mutual', 'hdfc fund', 'icici prudential'
  ])) {
    return 'Investment';
  }
  
  // Insurance
  if (_containsAny(lowerConsumer, [
    'insurance', 'premium', 'policy', 'lic', 'hdfc life', 'icici lombard',
    'bajaj allianz', 'max life', 'sbi life', 'tata aig', 'reliance general',
    'star health', 'care insurance', 'health insurance', 'motor insurance'
  ])) {
    return 'Insurance';
  }
  
  // Shopping (Physical stores, retail)
  if (_containsAny(lowerConsumer, [
    'mall', 'retail', 'fashion', 'clothing', 'electronics', 'mobile', 'textile', 'silks', 'sarees','mens', 'womens',
    'laptop', 'accessories', 'jewelry', 'gold', 'silver', 'watch', 
    'footwear', 'bags', 'cosmetics', 'beauty', 'salon', 'spa'
  ])) {
    return 'Shopping';
  }
  
  // Check for Transfer patterns in message
  if (_containsAny(lowerMessage, [
    'transfer', 'transferred', 'sent to', 'received from', 'p2p',
    'person to person', 'friend', 'family', 'split', 'settle'
  ])) {
    return 'Transfer';
  }
  
  // Check for ATM Withdrawal patterns
  if (_containsAny(lowerMessage, [
    'atm', 'cash withdrawal', 'withdrawal', 'cash', 'atm withdrawal'
  ])) {
    return 'ATM Withdrawal';
  }

  //check for Oil patterns
  if (_containsAny(lowerMessage, [
    'oil', 'gas', 'pump', 'petrol', 'diesel', 'fuel', 'petroleum', 'petrol pump', 'hp', 'essar', 'nayara', 
  ])) {
    return 'Oil&Gas';
  }
  return 'Other';
}

bool _containsAny(String text, List<String> keywords) {
  return keywords.any((keyword) => text.contains(keyword));
}