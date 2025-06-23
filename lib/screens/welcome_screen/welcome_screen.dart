import 'package:flow/common/utils/common_elevated_button.dart';
import 'package:flow/screens/signin_screen/signin_screen.dart';
import 'package:flow/theme/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
            AnimatedTextKit(
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
            CommonElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SigninScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
