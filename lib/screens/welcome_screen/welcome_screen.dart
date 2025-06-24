import 'package:flow/common/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flow/common/utils/common_elevated_button.dart';
import 'package:flow/screens/signin_screen/signin_screen.dart';
import 'package:flow/theme/strings.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _requestSmsPermission(BuildContext context) async {
    var status = await Permission.sms.status;

    if (!status.isGranted) {
      status = await Permission.sms.request();
    }

    if (status.isGranted) {
      showAppSnackBar(context, "✅ SMS permission granted");
    } else {
      showAppSnackBar(context, "❌ SMS permission denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              isDarkTheme
                  ? 'assets/svg/welcome_image_dark.svg'
                  : 'assets/svg/welcome_image_light.svg',
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.536,
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    welecome_page_text,
                    textStyle: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 1000),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
                isRepeatingAnimation: false,
              ),
            ),
            CommonElevatedButton(
              onPressed: () async {
                await _requestSmsPermission(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SigninScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
