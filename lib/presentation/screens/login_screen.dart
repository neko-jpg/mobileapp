import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minq/presentation/common/minq_copy.dart';
import 'package:minq/presentation/theme/minq_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Spacer(),
                Icon(
                  Icons.checklist_rtl,
                  color: tokens.brandPrimary,
                  size: tokens.spacing(16),
                ),
                SizedBox(height: tokens.spacing(4)),
                Text(
                  'MinQ',
                  style: tokens.titleLarge.copyWith(
                    color: tokens.textPrimary,
                    fontSize: 40,
                  ),
                ),
                SizedBox(height: tokens.spacing(2)),
                Text(
                  MinqCopy.valuePropositionHeadline,
                  style: tokens.bodyMedium.copyWith(color: tokens.textMuted),
                ),
                SizedBox(height: tokens.spacing(10)),
                _SocialLoginButton(
                  icon: Icons.android,
                  text: 'Continue with Google',
                  onPressed: () => context.go('/'),
                ),
                SizedBox(height: tokens.spacing(3)),
                _SocialLoginButton(
                  icon: Icons.apple,
                  text: 'Continue with Apple',
                  onPressed: () => context.go('/'),
                ),
                SizedBox(height: tokens.spacing(3)),
                _SocialLoginButton(
                  icon: Icons.shield_outlined,
                  text: 'Continue as Guest',
                  onPressed: () => context.go('/'),
                ),
                SizedBox(height: tokens.spacing(3)),
                _SocialLoginButton(
                  icon: Icons.mail_outline,
                  text: 'Continue with Email',
                  onPressed: () => context.go('/'),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.all(tokens.spacing(4)),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: tokens.labelSmall.copyWith(
                        color: tokens.textMuted,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'By continuing, you agree to MinQ\'s ',
                        ),
                        TextSpan(
                          text: 'Terms of Service',
                          style: tokens.labelSmall.copyWith(
                            color: tokens.brandPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: tokens.labelSmall.copyWith(
                            color: tokens.brandPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: tokens.surface,
        foregroundColor: tokens.textSecondary,
        minimumSize: Size(double.infinity, tokens.spacing(13.5)),
        shape: RoundedRectangleBorder(
          borderRadius: tokens.cornerLarge(),
          side: BorderSide(color: tokens.brandPrimary.withValues(alpha: 0.18)),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: tokens.spacing(6)),
          SizedBox(width: tokens.spacing(3)),
          Text(
            text,
            style: tokens.bodyMedium.copyWith(
              color: tokens.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
