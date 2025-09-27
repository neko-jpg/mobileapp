import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:minq/data/providers.dart';
import 'package:minq/domain/log/quest_log.dart';
import 'package:minq/presentation/common/minq_buttons.dart';
import 'package:minq/presentation/theme/minq_theme.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final currentStreak = ref.watch(streakProvider);
    final longestStreak = ref.watch(longestStreakProvider);
    final heatmapData = ref.watch(heatmapDataProvider);
    final recentLogs = ref.watch(recentLogsProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: Text('Progress for "Meditate"', style: tokens.titleMedium.copyWith(color: tokens.textPrimary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: MinqIconButton(icon: Icons.arrow_back, onTap: () => context.pop()),
        backgroundColor: tokens.background.withOpacity(0.8),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: EdgeInsets.all(tokens.spacing(4)),
        children: [
          SizedBox(height: tokens.spacing(4)),
          currentStreak.when(
            data: (current) => longestStreak.when(
              data: (longest) => _buildStreakCounter(tokens, current, longest),
              error: (error, _) => _StatsError(message: 'Failed to load longest streak'),
              loading: () => const _StatsSectionLoading(),
            ),
            error: (error, _) => _StatsError(message: 'Failed to load current streak'),
            loading: () => const _StatsSectionLoading(),
          ),
          SizedBox(height: tokens.spacing(8)),
          heatmapData.when(
            data: (data) => _buildHeatmapCard(tokens, data),
            error: (error, _) => _StatsError(message: 'Failed to load activity heatmap'),
            loading: () => const _StatsSectionLoading(),
          ),
          SizedBox(height: tokens.spacing(8)),
          recentLogs.when(
            data: (logs) => _buildDailyLog(tokens, logs),
            error: (error, _) => _StatsError(message: 'Failed to load recent logs'),
            loading: () => const _StatsSectionLoading(),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCounter(MinqTheme tokens, int current, int longest) {
    return Column(
      children: [
        Text('Current Streak', style: tokens.bodyMedium.copyWith(color: tokens.textMuted)),
        SizedBox(height: tokens.spacing(2)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.local_fire_department, size: tokens.spacing(12), color: Colors.amber.shade400),
            SizedBox(width: tokens.spacing(2)),
            Text('$current', style: tokens.displayMedium.copyWith(color: tokens.textPrimary, fontWeight: FontWeight.w800)),
          ],
        ),
        Text('days', style: tokens.bodyMedium.copyWith(color: tokens.textMuted)),
        if (longest > 0) ...[
          SizedBox(height: tokens.spacing(2)),
          Text('Longest streak: $longest days', style: tokens.bodySmall.copyWith(color: tokens.textMuted)),
        ],
      ],
    );
  }

  Widget _buildHeatmapCard(MinqTheme tokens, Map<DateTime, int> heatmapData) {
    return Card(
      elevation: 0,
      color: tokens.surface,
      shape: RoundedRectangleBorder(borderRadius: tokens.cornerLarge()),
      child: Padding(
        padding: EdgeInsets.all(tokens.spacing(4)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Weekly Heatmap', style: tokens.titleSmall.copyWith(color: tokens.textPrimary, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text('This week', style: tokens.bodyMedium.copyWith(color: tokens.textMuted)),
                    Icon(Icons.expand_more, color: tokens.textMuted, size: tokens.spacing(5)),
                  ],
                ),
              ],
            ),
            SizedBox(height: tokens.spacing(4)),
            HeatMap(
              datasets: heatmapData,
              colorMode: ColorMode.color,
              showText: false,
              scrollable: true,
              colorsets: {1: tokens.brandPrimary},
              defaultColor: tokens.background,
              borderRadius: tokens.radiusMedium,
              margin: EdgeInsets.all(tokens.spacing(1)),
              size: tokens.spacing(10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyLog(MinqTheme tokens, List<QuestLog> logs) {
    if (logs.isEmpty) {
      return Card(
        elevation: 0,
        color: tokens.surface,
        shape: RoundedRectangleBorder(borderRadius: tokens.cornerLarge()),
        child: Padding(
          padding: EdgeInsets.all(tokens.spacing(4)),
          child: Center(
            child: Text('No recent logs yet. Start recording quests to build your streak!',
                style: tokens.bodyMedium.copyWith(color: tokens.textMuted)),
          ),
        ),
      );
    }

    final grouped = groupBy(
      logs,
      (QuestLog log) => DateTime.utc(log.ts.year, log.ts.month, log.ts.day),
    );
    final entries = grouped.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    final dateFormatter = DateFormat.yMMMMd();
    final timeFormatter = DateFormat.jm();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Daily Log', style: tokens.titleSmall.copyWith(color: tokens.textPrimary, fontWeight: FontWeight.bold)),
        SizedBox(height: tokens.spacing(4)),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            final label = _formatDayLabel(entry.key, dateFormatter);
            final times = entry.value
                .map((log) => timeFormatter.format(log.ts.toLocal()))
                .toList()
              ..sort((a, b) => a.compareTo(b));
            return Card(
              elevation: 0,
              color: tokens.surface,
              shape: RoundedRectangleBorder(borderRadius: tokens.cornerLarge()),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spacing(4), vertical: tokens.spacing(3)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(label,
                          style: tokens.bodyLarge.copyWith(color: tokens.textPrimary, fontWeight: FontWeight.w600)),
                    ),
                    Row(
                      children: [
                        Text(times.join(', '), style: tokens.bodyMedium.copyWith(color: tokens.textMuted)),
                        SizedBox(width: tokens.spacing(2)),
                        Container(
                          padding: EdgeInsets.all(tokens.spacing(1)),
                          decoration: BoxDecoration(color: Colors.green.shade500, shape: BoxShape.circle),
                          child: Icon(Icons.check, color: Colors.white, size: tokens.spacing(4)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: tokens.spacing(3)),
        ),
      ],
    );
  }

  String _formatDayLabel(DateTime day, DateFormat formatter) {
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    final normalizedDay = DateTime(day.year, day.month, day.day);
    final difference = normalizedToday.difference(normalizedDay).inDays;
    if (difference == 0) {
      return 'Today';
    }
    if (difference == 1) {
      return 'Yesterday';
    }
    return formatter.format(normalizedDay);
  }
}

class _StatsSectionLoading extends StatelessWidget {
  const _StatsSectionLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _StatsError extends StatelessWidget {
  const _StatsError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Card(
      elevation: 0,
      color: tokens.surface,
      shape: RoundedRectangleBorder(borderRadius: tokens.cornerLarge()),
      child: Padding(
        padding: EdgeInsets.all(tokens.spacing(4)),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: tokens.spacing(6),
            ),
            SizedBox(width: tokens.spacing(3)),
            Expanded(
              child: Text(message, style: tokens.bodyMedium.copyWith(color: tokens.textMuted)),
            ),
          ],
        ),
      ),
    );
  }
}
