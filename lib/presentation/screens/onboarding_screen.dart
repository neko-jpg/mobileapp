import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minq/data/providers.dart';
import 'package:minq/presentation/common/minq_copy.dart';
import 'package:minq/presentation/common/notification_permission_flow.dart';
import 'package:minq/presentation/theme/minq_theme.dart';

class OnboardingSlide {
  const OnboardingSlide({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations) subtitle;
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  static const List<OnboardingSlide> _slides = <OnboardingSlide>[
    OnboardingSlide(
      icon: Icons.flag_circle_outlined,
      title: _onboardingMiniQuestTitle,
      subtitle: MinqCopy.onboardingFeatureMiniQuest,
    ),
    OnboardingSlide(
      icon: Icons.groups,
      title: _onboardingAccountabilityTitle,
      subtitle: MinqCopy.onboardingFeatureAnonymousPair,
    ),
    OnboardingSlide(
      icon: Icons.notifications_active_outlined,
      title: _onboardingSmartRemindersTitle,
      subtitle: MinqCopy.onboardingFeatureNotifications,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handleNext() async {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
      return;
    }
    await runNotificationPermissionFlow(context: context, ref: ref);
    if (!mounted) {
      return;
    }
    context.go('/login');
  }

  void _handleSkip() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: tokens.spacing(6),
                right: tokens.spacing(6),
                top: tokens.spacing(6),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _handleSkip,
                  child: Text(l10n.onboardingSkipButton),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged:
                    (int index) => setState(() => _currentPage = index),
                itemBuilder: (BuildContext context, int index) {
                  final slide = _slides[index];
                  return _OnboardingSlideView(slide: slide);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.spacing(6)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _OnboardingIndicator(
                    length: _slides.length,
                    currentIndex: _currentPage,
                  ),
                  SizedBox(height: tokens.spacing(6)),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: Size(double.infinity, tokens.spacing(14)),
                      backgroundColor: tokens.brandPrimary,
                      foregroundColor: tokens.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: tokens.cornerXLarge(),
                      ),
                    ),
                    onPressed: _handleNext,
                    child: Text(
                      _currentPage == _slides.length - 1
                          ? l10n.onboardingContinueButton
                          : l10n.onboardingNextButton,
                    ),
                  ),
                  SizedBox(height: tokens.spacing(4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlideView extends StatelessWidget {
  const _OnboardingSlideView({required this.slide});

  final OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: tokens.spacing(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: tokens.spacing(24),
            height: tokens.spacing(24),
            decoration: BoxDecoration(
              color: tokens.brandPrimary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              slide.icon,
              size: tokens.spacing(13),
              color: tokens.brandPrimary,
            ),
          ),
          SizedBox(height: tokens.spacing(6)),
          Text(
            slide.title(l10n),
            textAlign: TextAlign.center,
            style: tokens.titleMedium.copyWith(color: tokens.textPrimary),
          ),
          SizedBox(height: tokens.spacing(3)),
          Text(
            slide.subtitle(l10n),
            textAlign: TextAlign.center,
            style: tokens.bodyMedium.copyWith(color: tokens.textMuted),
          ),
        ],
      ),
    );
  }
}

class _OnboardingIndicator extends StatelessWidget {
  const _OnboardingIndicator({
    required this.length,
    required this.currentIndex,
  });

  final int length;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(length, (int index) {
        final bool isActive = index == currentIndex;
        return AnimatedContainer(
          margin: EdgeInsets.symmetric(horizontal: tokens.spacing(1)),
          duration: const Duration(milliseconds: 240),
          height: tokens.spacing(2),
          width: isActive ? tokens.spacing(6) : tokens.spacing(2.5),
          decoration: BoxDecoration(
            color: isActive
                ? tokens.brandPrimary
                : tokens.brandPrimary.withValues(alpha: 0.25),
            borderRadius: tokens.cornerSmall(),
          ),
        );
      }),
    );
  }
}

String _onboardingMiniQuestTitle(AppLocalizations l10n) =>
    l10n.onboardingMiniQuestTitle;

String _onboardingAccountabilityTitle(AppLocalizations l10n) =>
    l10n.onboardingAccountabilityTitle;

String _onboardingSmartRemindersTitle(AppLocalizations l10n) =>
    l10n.onboardingSmartRemindersTitle;
