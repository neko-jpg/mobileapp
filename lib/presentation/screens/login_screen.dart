import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF13B6EC);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Icon(
                  Icons.checklist_rtl, // Using a similar icon
                  color: primaryColor,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'MinQ',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF101D22),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Build habits, one mini-quest at a time.',
                  style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 40),
                _SocialLoginButton(
                  icon: Icons.android, // Placeholder for Google icon
                  text: 'Continue with Google',
                  onPressed: () => context.go('/'),
                ),
                const SizedBox(height: 12),
                _SocialLoginButton(
                  icon: Icons.apple, // Placeholder for Apple icon
                  text: 'Continue with Apple',
                  onPressed: () => context.go('/'),
                ),
                const SizedBox(height: 12),
                _SocialLoginButton(
                  icon: Icons.shield_outlined, // Using outlined version
                  text: 'Continue as Guest',
                  onPressed: () => context.go('/'),
                ),
                const SizedBox(height: 12),
                _SocialLoginButton(
                  icon: Icons.mail_outline, // Using outlined version
                  text: 'Continue with Email',
                  onPressed: () => context.go('/'),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                      children: [
                        const TextSpan(text: 'By continuing, you agree to MinQ\'s '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            // TODO: Handle Terms of Service tap
                            print('Terms of Service tapped');
                          },
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            // TODO: Handle Privacy Policy tap
                            print('Privacy Policy tapped');
                          },
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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF334155),
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        elevation: 0.5,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}