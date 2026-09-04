import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/widgets/button.dart';
import '../../core/localization/translation_keys.dart';
import '../../core/utils/my_shared_pref.dart';
import '../auth/pages/on_boarding_screen.dart';

class _OnboardingPage {
  const _OnboardingPage({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}

List<_OnboardingPage> _buildPages() => [
  _OnboardingPage(title: LK.onboardingTitle1, subtitle: LK.onboardingSubtitle1),
  _OnboardingPage(title: LK.onboardingTitle2, subtitle: LK.onboardingSubtitle2),
  _OnboardingPage(title: LK.onboardingTitle3, subtitle: LK.onboardingSubtitle3),
];

class AppColor {
  static const Color primary = Color(0xFF242476);
  static const Color primarySoft = Color(0xFFEAEAF2);
  static const Color secondary = Color(0xFF0A0E2F);
  static const Color accent = Color(0xFFFABA3E);
  static const Color border = Color(0xFFD3D3E4);
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final List<_OnboardingPage> _pages = _buildPages();

  final PageController _controller = PageController();
  int _current = 0;

  void _next() {
    if (_current < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _goToWelcome();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColor.primary;

    // Text direction comes from the active locale via MaterialApp, so this
    // screen no longer forces RTL.
    return Directionality(
      textDirection: Directionality.of(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              /// CONTENT
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _current = i),
                  itemBuilder: (context, i) {
                    final page = _pages[i];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _image(i + 1, context),

                          const SizedBox(height: 30),

                          /// TITLE
                          Text(
                            page.title.tr(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(
                                  color: AppColor.secondary,
                                  fontWeight: FontWeight.w700,
                                  height: 1.4,
                                ),
                          ),

                          const SizedBox(height: 14),

                          /// SUBTITLE
                          Text(
                            page.subtitle.tr(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(
                                  color: const Color(0xff7A7A7A),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  height: 1.6,
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// BOTTOM
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
                child: Column(
                  children: [
                    _dots(),

                    const SizedBox(height: 25),

                    /// PRIMARY BUTTON (same style system as your app)
                    SizedBox(
                      width: double.infinity,
                      child: AuthButton(
                        text: _current == _pages.length - 1
                            ? LK.onboardingStart.tr()
                            : LK.commonNext.tr(),
                        onTap: _next,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// DOTS
  Widget _dots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _current == i ? 18 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: _current == i ? AppColor.primary : AppColor.primarySoft,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  /// IMAGE BLOCK (aligned with your soft UI style)
  Widget _image(int index, BuildContext context) {
    final asset = "assets/svg/onboarding$index.svg";

    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: SvgPicture.asset(
          asset,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.auto_awesome, size: 60, color: AppColor.primary),
        ),
      ),
    );
  }

  Future<void> _goToWelcome() async {
    // Persist that the intro was completed so it never shows again, and
    // replace this route so Back can't return to it.
    await MySharedPref.setOnBoardingSeen();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => OnBoardingScreen()),
    );
  }
}
