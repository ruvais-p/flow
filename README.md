![Flow Expense Tracker Banner](https://your-image-link-here.com/banner.png)

# 💸 Flow – Tack your coin flow...

Tracking expenses is essential but often difficult. Despite people's best intentions, many give up because:

- Most apps require **manual input**
- Others depend on **third-party bank APIs**
- Some lack flexibility across banks and regions

After trying several apps, I realized something:  
📩 **Every transaction we make sends an SMS** – containing valuable data like **amounts, UPI IDs, merchant names**, etc. Though these messages vary slightly between banks, they all have a common structure.

So I decided to build **Flow**, a lightweight expense tracker that extracts your transaction details **directly from SMS** – no APIs, no manual typing!

---

## 🔧 Tech Stack

- **Flutter** (Frontend & Logic)
- **Method Channels** to connect native code for SMS access
- **Regex Modeling** in Dart for message parsing
- **Sqflite** for offline storage

---

## 🚀 Features

- 📲 Automatically reads and parses transaction SMS
- 🧠 Uses bank-specific regex models for accurate detection
- 🏦 Supports multiple Indian banks (customizable)
- 📊 Visual insights on your spending
- 🔒 Works completely offline

---

## 🛠️ Adding a New Bank / Regex Model

To add support for a new bank:

1. **Create Regex Model**  
   Add your regex parsing model to:  
   ```bash
   lib/model/regex_models/
````

2. **Update Bank List UI**
   Add the new bank name to the selection screen:

   ```bash
   lib/screens/bankselection_screen/bank_selection_screen.dart
   ```

3. **Connect Bank to Regex Parser**
   Inside the function in:

   ```bash
   lib/common/functions/select_parse_model_function.dart
   ```

   Add the corresponding bank logic to call your regex model.

---

## 🧪 Run Locally

```bash
# Get dependencies
flutter pub get

# Run on Android device
flutter run

# Build release APK
flutter build apk --release
```

---

## 📌 Note

To read SMS, make sure you've added the following permissions to `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.READ_SMS" />
<uses-permission android:name="android.permission.RECEIVE_SMS" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
```
