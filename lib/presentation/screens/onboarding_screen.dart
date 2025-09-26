import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minq/presentation/common/minq_copy.dart';
import 'package:minq/presentation/theme/minq_theme.dart';

class OnboardingSlide {
  const OnboardingSlide({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  static const List<OnboardingSlide> _slides = <OnboardingSlide>[
    OnboardingSlide(
      icon: Icons.flag_circle_outlined,
      title: 'Mini-quests that stick',
      subtitle: MinqCopy.onboardingFeatureMiniQuest,
    ),
    OnboardingSlide(
      icon: Icons.groups,
      title: 'Anonymous accountability',
      subtitle: MinqCopy.onboardingFeatureAnonymousPair,
    ),
    OnboardingSlide(
      icon: Icons.notifications_active_outlined,
      title: 'Smart reminders (optional)',
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

  void _handleNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
      return;
    }
    _showNotificationPrePrompt();
  }

  Future<void> _showNotificationPrePrompt() async {
    final tokens = context.tokens;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: tokens.surface,
      shape: RoundedRectangleBorder(borderRadius: tokens.cornerLarge()),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            tokens.spacing(6),
            tokens.spacing(6),
            tokens.spacing(6),
            tokens.spacing(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                MinqCopy.notificationPrePromptTitle,
                style: tokens.titleSmall.copyWith(color: tokens.textPrimary),
              ),
              SizedBox(height: tokens.spacing(3)),
              Text(
                MinqCopy.notificationPrePromptBody,
                style: tokens.bodySmall.copyWith(color: tokens.textMuted),
              ),
              SizedBox(height: tokens.spacing(5)),
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: Size(double.infinity, tokens.spacing(12)),
                  backgroundColor: tokens.brandPrimary,
                  foregroundColor: tokens.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: tokens.cornerLarge(),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Sounds good'),
              ),
            ],
          ),
        );
      },
    );
    if (!mounted) return;
    context.go('/login');
  }

  void _handleSkip() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

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
                  child: const Text('スキップ'),
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
                      _currentPage == _slides.length - 1 ? '通知を設定して続ける' : '次へ',
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
            slide.title,
            textAlign: TextAlign.center,
            style: tokens.titleMedium.copyWith(color: tokens.textPrimary),
          ),
          SizedBox(height: tokens.spacing(3)),
          Text(
            slide.subtitle,
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
            color:
                isActive
                    ? tokens.brandPrimary
                    : tokens.brandPrimary.withValues(alpha: 0.25),
            borderRadius: tokens.cornerSmall(),
          ),
        );
      }),
    );
  }
}
