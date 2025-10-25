import 'package:flutter/material.dart';
import 'package:poke_app/colors.dart';
import 'package:poke_app/core/constants.dart';
import 'package:poke_app/l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<String> onboardingSteps = [
    AppConstants.onboardingImage1,
    AppConstants.onboardingImage2,
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
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedCrossFade(
                firstCurve: Curves.easeInOut,
                secondCurve: Curves.easeInOut,
                duration: AppConstants.longAnimationDuration,
                crossFadeState: currentStep == 0
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: Image.asset(
                  onboardingSteps[0],
                  width: AppConstants.imageWidth,
                  height: AppConstants.imageHeight,
                ),
                secondChild: Image.asset(
                  onboardingSteps[1],
                  width: AppConstants.imageWidth,
                  height: AppConstants.imageHeight,
                ),
              ),

              const SizedBox(height: 20),
              AnimatedCrossFade(
                duration: AppConstants.animationDuration,
                firstChild: Text(
                  titles[0],
                  style: TextStyle(
                    fontSize: AppConstants.titleFontSize,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppConstants.fontFamily,
                    color: textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                secondChild: Text(
                  titles[currentStep],
                  style: TextStyle(
                    fontSize: AppConstants.titleFontSize,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppConstants.fontFamily,
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
                  fontSize: AppConstants.subtitleFontSize,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppConstants.fontFamily,
                  color: textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: AppConstants.longAnimationDuration,
                    width: (currentStep == 0)
                        ? AppConstants.indicatorWidth.toDouble()
                        : AppConstants.indicatorWidthSmall.toDouble(),
                    height: AppConstants.indicatorHeight.toDouble(),
                    decoration: BoxDecoration(
                      color: (currentStep == 0) ? azulNormal : azulSemiLight,
                      borderRadius:
                          BorderRadius.circular(AppConstants.indicatorBorderRadius),
                    ),
                  ),
                  const SizedBox(width: AppConstants.indicatorSpacing),
                  AnimatedContainer(
                    duration: AppConstants.animationDuration,
                    width: (currentStep == 1)
                        ? AppConstants.indicatorWidth.toDouble()
                        : AppConstants.indicatorWidthSmall.toDouble(),
                    height: AppConstants.indicatorHeight.toDouble(),
                    decoration: BoxDecoration(
                      color: (currentStep == 1) ? azulNormal : azulSemiLight,
                      borderRadius:
                          BorderRadius.circular(AppConstants.indicatorBorderRadius),
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
                          borderRadius:
                              BorderRadius.circular(AppConstants.defaultBorderRadius),
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
                        duration: AppConstants.animationDuration,
                        firstChild: Text(
                          buttonTexts[0],
                          style: const TextStyle(
                            fontSize: AppConstants.buttonFontSize,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppConstants.fontFamily,
                          ),
                        ),
                        secondChild: Text(
                          buttonTexts[1],
                          style: const TextStyle(
                            fontSize: AppConstants.buttonFontSize,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppConstants.fontFamily,
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
