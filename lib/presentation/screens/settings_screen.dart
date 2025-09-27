import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minq/data/providers.dart';
import 'package:minq/data/services/notification_service.dart';
import 'package:minq/presentation/common/notification_permission_flow.dart';
import 'package:minq/presentation/theme/minq_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<bool> _handleNotificationToggle(
    BuildContext context,
    WidgetRef ref,
    bool value,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    if (value) {
      final granted =
          await runNotificationPermissionFlow(context: context, ref: ref);
      return granted;
    }

    final notifications = ref.read(notificationServiceProvider);
    await notifications.cancelAll();
    ref.read(notificationPermissionProvider.notifier).state = false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.notificationPermissionMuted)),
    );
    return false;
  }

  Future<void> _sendTestNotification(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    var permissionGranted = ref.read(notificationPermissionProvider);
    if (!permissionGranted) {
      permissionGranted =
          await runNotificationPermissionFlow(context: context, ref: ref);
    }

    if (!permissionGranted) {
      return;
    }

    final notifications = ref.read(notificationServiceProvider);
    await notifications.showTestNotification(
      title: l10n.testNotificationTitle,
      body: l10n.testNotificationBody,
      channelName: l10n.testNotificationChannelName,
      channelDescription: l10n.testNotificationChannelDescription,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.testNotificationScheduled)),
    );
  }

  Future<void> _showLanguagePicker(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Locale? currentLocale,
  ) async {
    final tokens = context.tokens;

    final selectedLocale = await showModalBottomSheet<Locale?>(
      context: context,
      backgroundColor: tokens.surface,
      shape: RoundedRectangleBorder(borderRadius: tokens.cornerLarge()),
      builder: (BuildContext context) {
        Locale? tempSelection = currentLocale;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.all(tokens.spacing(5)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.settingsLanguagePickerTitle,
                    style: tokens.titleSmall.copyWith(color: tokens.textPrimary),
                  ),
                  SizedBox(height: tokens.spacing(3)),
                  ...[
                    _LocaleOption(null, l10n.languageSystemDefault),
                    _LocaleOption(const Locale('en'), l10n.languageEnglish),
                    _LocaleOption(const Locale('ja'), l10n.languageJapanese),
                  ].map((option) {
                    final isSelected = _isSameLocale(option.locale, tempSelection);
                    return RadioListTile<Locale?>(
                      title: Text(option.label),
                      value: option.locale,
                      groupValue: tempSelection,
                      onChanged: (Locale? value) {
                        setState(() => tempSelection = value);
                      },
                    );
                  }),
                  SizedBox(height: tokens.spacing(2)),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(tempSelection),
                    style: FilledButton.styleFrom(
                      minimumSize: Size(double.infinity, tokens.spacing(12)),
                      backgroundColor: tokens.brandPrimary,
                      foregroundColor: tokens.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: tokens.cornerLarge(),
                      ),
                    ),
                    child: Text(l10n.commonConfirm),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (selectedLocale == currentLocale) {
      return;
    }

    await ref
        .read(appLocaleControllerProvider.notifier)
        .setLocale(selectedLocale);

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.languageChangeApplied)),
    );
  }

  String _languageSubtitle(AppLocalizations l10n, Locale? locale) {
    if (locale == null) {
      return l10n.languageSystemDefault;
    }
    switch (locale.languageCode) {
      case 'ja':
        return l10n.languageJapanese;
      case 'en':
        return l10n.languageEnglish;
      default:
        return locale.toLanguageTag();
    }
  }

  bool _isSameLocale(Locale? a, Locale? b) {
    if (a == null || b == null) {
      return a == b;
    }
    return a.languageCode == b.languageCode && a.countryCode == b.countryCode;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context)!;
    final permissionGranted = ref.watch(notificationPermissionProvider);
    final locale = ref.watch(appLocaleControllerProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: Text(
          l10n.settingsTitle,
          style: tokens.titleMedium.copyWith(
            color: tokens.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: tokens.background.withOpacity(0.8),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: EdgeInsets.all(tokens.spacing(4)),
        children: <Widget>[
          _SettingsSection(
            title: l10n.settingsGeneralSection,
            tiles: [
              _SettingsTile(
                title: l10n.settingsNotificationsTileTitle,
                subtitle: l10n.settingsNotificationsTileSubtitle,
                isSwitch: true,
                switchValue: permissionGranted,
                onSwitchChanged: (value) =>
                    _handleNotificationToggle(context, ref, value),
              ),
              _SettingsTile(
                title: l10n.settingsNotificationTimesTile,
                onTap: () => context.push('/settings/notifications'),
              ),
              _SettingsTile(
                title: l10n.settingsSoundsTile,
              ),
              _SettingsTile(
                title: l10n.settingsSendTestNotification,
                subtitle: l10n.settingsSendTestNotificationSubtitle,
                onTap: () => _sendTestNotification(context, ref, l10n),
              ),
              _SettingsTile(
                title: l10n.settingsLanguageTileTitle,
                subtitle: _languageSubtitle(l10n, locale),
                onTap: () => _showLanguagePicker(context, ref, l10n, locale),
              ),
            ],
          ),
          _SettingsSection(
            title: l10n.settingsPrivacySection,
            tiles: [
              _SettingsTile(
                title: l10n.settingsDataSyncTileTitle,
                subtitle: l10n.settingsDataSyncTileSubtitle,
                isSwitch: true,
                switchValue: false,
              ),
              _SettingsTile(
                title: l10n.settingsManageBlockedUsers,
              ),
              _SettingsTile(
                title: l10n.settingsExportData,
                isDownload: true,
              ),
              _SettingsTile(
                title: l10n.settingsDeleteAccount,
                isDelete: true,
              ),
            ],
          ),
          _SettingsSection(
            title: l10n.settingsAboutSection,
            tiles: [
              _SettingsTile(
                title: l10n.settingsTermsOfService,
                onTap: () => context.push('/policy/terms'),
              ),
              _SettingsTile(
                title: l10n.settingsPrivacyPolicy,
                onTap: () => context.push('/policy/privacy'),
              ),
              _SettingsTile(
                title: l10n.settingsAppVersion,
                isStatic: true,
                staticValue: '1.0.0',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.tiles});

  final String title;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: EdgeInsets.only(bottom: tokens.spacing(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: tokens.spacing(2), bottom: tokens.spacing(4)),
            child: Text(
              title,
              style: tokens.titleLarge.copyWith(
                color: tokens.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...tiles,
        ],
      ),
    );
  }
}

class _SettingsTile extends StatefulWidget {
  const _SettingsTile({
    required this.title,
    this.subtitle,
    this.onTap,
    this.isSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
    this.isDelete = false,
    this.isDownload = false,
    this.isStatic = false,
    this.staticValue,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isSwitch;
  final bool switchValue;
  final Future<bool> Function(bool value)? onSwitchChanged;
  final bool isDelete;
  final bool isDownload;
  final bool isStatic;
  final String? staticValue;

  @override
  State<_SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<_SettingsTile> {
  late bool _currentSwitchValue;

  @override
  void initState() {
    super.initState();
    _currentSwitchValue = widget.switchValue;
  }

  @override
  void didUpdateWidget(covariant _SettingsTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.switchValue != widget.switchValue) {
      _currentSwitchValue = widget.switchValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final titleColor =
        widget.isDelete ? Colors.red.shade500 : tokens.textPrimary;

    return Card(
      elevation: 1,
      shadowColor: tokens.background.withOpacity(0.1),
      color: tokens.surface,
      margin: EdgeInsets.symmetric(vertical: tokens.spacing(2)),
      shape: RoundedRectangleBorder(borderRadius: tokens.cornerXLarge()),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: EdgeInsets.all(tokens.spacing(4)),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: tokens.bodyLarge.copyWith(
                        color: titleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.subtitle != null)
                      Padding(
                        padding: EdgeInsets.only(top: tokens.spacing(1)),
                        child: Text(
                          widget.subtitle!,
                          style: tokens.bodySmall.copyWith(
                            color: tokens.textMuted,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.isSwitch)
                Switch(
                  value: _currentSwitchValue,
                  onChanged: (value) async {
                    if (widget.onSwitchChanged != null) {
                      final result = await widget.onSwitchChanged!(value);
                      setState(() => _currentSwitchValue = result);
                    } else {
                      setState(() => _currentSwitchValue = value);
                    }
                  },
                  activeColor: Colors.white,
                  activeTrackColor: tokens.brandPrimary,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: tokens.border,
                )
              else if (widget.isDelete)
                Icon(Icons.delete, color: titleColor)
              else if (widget.isDownload)
                Icon(Icons.download, color: tokens.textMuted)
              else if (widget.isStatic)
                Text(
                  widget.staticValue ?? '',
                  style: tokens.bodyMedium.copyWith(color: tokens.textMuted),
                )
              else
                Icon(Icons.arrow_forward_ios,
                    color: tokens.textMuted, size: tokens.spacing(4)),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocaleOption {
  const _LocaleOption(this.locale, this.label);

  final Locale? locale;
  final String label;
}
