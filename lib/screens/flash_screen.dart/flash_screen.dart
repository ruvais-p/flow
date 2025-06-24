import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class FlashScreen extends StatefulWidget {
  final Widget homeWidget;
  const FlashScreen({super.key, required this.homeWidget});

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  bool _animationCompleted = false;

  @override
  void initState() {
    super.initState();
  }

  void _onTypingAnimationDone() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => widget.homeWidget),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightred,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/flash_screen_app_icon.svg',
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.1,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 25),
            AnimatedTextKit(
              isRepeatingAnimation: false,
              totalRepeatCount: 1,
              onFinished: _onTypingAnimationDone,
              animatedTexts: [
                TyperAnimatedText(
                  "Track your coin flow...",
                  textStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: AppColors.whitecolor,
                      ),
                  speed: const Duration(milliseconds: 80),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
