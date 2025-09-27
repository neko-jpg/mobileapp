import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minq/data/providers.dart';
import 'package:minq/presentation/common/minq_copy.dart';
import 'package:minq/presentation/theme/minq_theme.dart';

Future<bool> runNotificationPermissionFlow({
  required BuildContext context,
  required WidgetRef ref,
  bool showPrePrompt = true,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final tokens = context.tokens;

  bool proceed = true;
  if (showPrePrompt) {
    proceed = await showModalBottomSheet<bool>(
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
                    MinqCopy.notificationPrePromptTitle(l10n),
                    style: tokens.titleSmall.copyWith(color: tokens.textPrimary),
                  ),
                  SizedBox(height: tokens.spacing(3)),
                  Text(
                    MinqCopy.notificationPrePromptBody(l10n),
                    style: tokens.bodySmall.copyWith(color: tokens.textMuted),
                  ),
                  SizedBox(height: tokens.spacing(5)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilledButton(
                        style: FilledButton.styleFrom(
                          minimumSize: Size(double.infinity, tokens.spacing(12)),
                          backgroundColor: tokens.brandPrimary,
                          foregroundColor: tokens.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: tokens.cornerLarge(),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(l10n.notificationPrePromptPrimaryAction),
                      ),
                      SizedBox(height: tokens.spacing(3)),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(l10n.notificationPrePromptSecondaryAction),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ) ??
        false;
  }

  if (!proceed) {
    return false;
  }

  final notifications = ref.read(notificationServiceProvider);
  final granted = await notifications.requestPermission();
  ref.read(notificationPermissionProvider.notifier).state = granted;

  if (granted) {
    ref.invalidate(appStartupProvider);
    unawaited(ref.read(appStartupProvider.future));
  }

  final messenger = ScaffoldMessenger.of(context);
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        granted
            ? l10n.notificationPermissionGranted
            : l10n.notificationPermissionDenied,
      ),
    ),
  );

  return granted;
}
