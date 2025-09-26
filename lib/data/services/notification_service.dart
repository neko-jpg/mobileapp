import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService();

  static const List<String> defaultReminderTimes = ['07:30', '21:30', '18:30'];
  static const int _recurringNotificationBaseId = 200;
  static const int _auxiliaryNotificationId = 300;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  bool get _supportsLocalNotifications => !kIsWeb;

  Future<bool> init() async {
    if (!_supportsLocalNotifications) {
      return false;
    }

    if (!_initialized) {
      tz.initializeTimeZones();
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const initializationSettings = InitializationSettings(
        android: androidSettings,
      );
      await _plugin.initialize(initializationSettings);
      _initialized = true;
    }
    return requestPermission();
  }

  Future<bool> requestPermission() async {
    if (!_supportsLocalNotifications) {
      return false;
    }

    bool granted = true;

    final androidImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidImplementation != null) {
      final enabled = await androidImplementation.areNotificationsEnabled();
      if (enabled != null) {
        granted = granted && enabled;
      }
    }

    final iosImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (iosImplementation != null) {
      final iosGranted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      if (iosGranted != null) {
        granted = granted && iosGranted;
      }
    }

    return granted;
  }

  Future<void> scheduleRecurringReminders(List<String> times) async {
    if (!_supportsLocalNotifications) {
      return;
    }

    await _cancelRecurringReminders();
    for (var index = 0; index < times.length; index++) {
      final parsed = _parseTime(times[index]);
      if (parsed == null) continue;

      await _plugin.zonedSchedule(
        _recurringNotificationBaseId + index,
        _titleForIndex(index),
        _bodyForIndex(index),
        _nextInstance(parsed.$1, parsed.$2),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'minq_daily_channel',
            'MinQ 毎日のリマインダー',
            channelDescription: '続けやすいタイミングでミニクエをお知らせします。',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,

        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> scheduleAuxiliaryReminder(String time) async {
    if (!_supportsLocalNotifications) {
      return;
    }

    final parsed = _parseTime(time);
    if (parsed == null) return;

    await _plugin.zonedSchedule(
      _auxiliaryNotificationId,
      'あと1つだけやってみよう',
      '今日のミニクエがまだなら、今こそハイファイブをもらいにいこう。',
      _nextInstance(parsed.$1, parsed.$2),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'minq_aux_channel',
          'MinQ 追いリマインダー',
          channelDescription: '未完了のときだけ届く補助リマインダーです。',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,

    );
  }

  Future<void> cancelAuxiliaryReminder() async {
    if (!_supportsLocalNotifications) {
      return;
    }

    await _plugin.cancel(_auxiliaryNotificationId);
  }

  Future<void> cancelAll() async {
    if (!_supportsLocalNotifications) {
      return;
    }

    await _plugin.cancelAll();
  }

  Future<void> _cancelRecurringReminders() async {
    if (!_supportsLocalNotifications) {
      return;
    }

    for (var index = 0; index < 3; index++) {
      await _plugin.cancel(_recurringNotificationBaseId + index);
    }
  }

  (int, int)? _parseTime(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    final normalizedHour = hour.clamp(0, 23).toInt();
    final normalizedMinute = minute.clamp(0, 59).toInt();
    return (normalizedHour, normalizedMinute);
  }

  tz.TZDateTime _nextInstance(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  String _titleForIndex(int index) {
    switch (index) {
      case 0:
        return '朝一番のミニクエ時間';
      case 1:
        return 'おやすみ前の振り返り';
      default:
        return 'MinQからのお知らせ';
    }
  }

  String _bodyForIndex(int index) {
    switch (index) {
      case 0:
        return '最初のミニクエで勢いをつけましょう。まずは1分でOK！';
      case 1:
        return '今日の記録をまとめて、ストリークを伸ばそう。';
      default:
        return 'ミニクエを続けて、ペアにハイファイブを送りましょう。';
    }
  }
}
