import 'package:flutter/material.dart';
import 'package:poke_app/colors.dart';
import 'package:poke_app/l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<String> onboardingSteps = [
    'assets/png/onboarding.png',
    'assets/png/onboarding2.png',
  ];
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final titles = [l10n.onboardingTitle1, l10n.onboardingTitle2];
    final subtitles = [l10n.onboardingSubtitle1, l10n.onboardingSubtitle2];
    final buttonTexts = [l10n.continueButton, l10n.letsStartButton];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedCrossFade(
                firstCurve: Curves.easeInOut,
                secondCurve: Curves.easeInOut,
                duration: const Duration(milliseconds: 500),
                crossFadeState: currentStep == 0
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: Image.asset(
                  onboardingSteps[0],
                  width: 342,
                  height: 265,
                ),
                secondChild: Image.asset(
                  onboardingSteps[1],
                  width: 342,
                  height: 265,
                ),
              ),

              const SizedBox(height: 20),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                firstChild: Text(
                  titles[0],
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                secondChild: Text(
                  titles[currentStep],
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                crossFadeState: currentStep == 0
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              ),
              const SizedBox(height: 12),
              Text(
                subtitles[currentStep],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  color: textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: (currentStep == 0) ? 28 : 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: (currentStep == 0) ? azulNormal : azulSemiLight,
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: (currentStep == 1) ? 28 : 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: (currentStep == 1) ? azulNormal : azulSemiLight,
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        backgroundColor: primaryDefault,
                        elevation: 2,
                      ),
                      onPressed: () {
                        // Navigate to the next page or perform an action
                        setState(() {
                          if (currentStep < onboardingSteps.length - 1) {
                            currentStep++;
                          } else {
                            currentStep = 0;
                          }
                        });
                      },
                      child: AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        firstChild: Text(
                          buttonTexts[0],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        secondChild: Text(
                          buttonTexts[1],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        crossFadeState: currentStep == 0
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
