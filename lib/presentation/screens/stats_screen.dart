import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF13B6EC);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      appBar: AppBar(
        title: Text(
          'Progress',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF101D22),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildStreakCounter(),
          const SizedBox(height: 24),
          _buildHeatmapCard(primaryColor),
          const SizedBox(height: 24),
          _buildDailyLog(),
        ],
      ),
    );
  }

  Widget _buildStreakCounter() {
    return Column(
      children: [
        const Text(
          'Current Streak',
          style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.local_fire_department,
                color: Colors.amber, size: 50),
            const SizedBox(width: 8),
            Text(
              '21',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 60,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF101D22),
              ),
            ),
          ],
        ),
        const Text(
          'days',
          style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildHeatmapCard(Color primaryColor) {
    return Card(
      elevation: 0.5,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Activity Heatmap',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'This month',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Icon(Icons.expand_more, color: Colors.grey.shade600),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            HeatMap(
              datasets: {
                DateTime(2024, 6, 3): 5,
                DateTime(2024, 6, 4): 7,
                DateTime(2024, 6, 5): 10,
                DateTime(2024, 6, 6): 3,
                DateTime(2024, 6, 8): 6,
                DateTime(2024, 6, 9): 8,
                DateTime(2024, 6, 10): 10,
                DateTime(2024, 6, 12): 5,
                DateTime(2024, 6, 13): 9,
                DateTime(2024, 6, 17): 4,
                DateTime(2024, 6, 21): 10,
                DateTime(2024, 6, 22): 7,
                DateTime(2024, 6, 23): 8,
              },
              colorMode: ColorMode.opacity,
              showText: false,
              scrollable: true,
              colorsets: {
                1: primaryColor,
              },
              defaultColor: Colors.grey.shade200,
              borderRadius: 8,
              margin: const EdgeInsets.all(2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyLog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Log',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _LogItem(date: 'Today', time: '8:15 AM'),
        _LogItem(date: 'Yesterday', time: '7:50 AM'),
        _LogItem(date: 'June 22, 2024', time: '9:02 AM'),
      ],
    );
  }
}

class _LogItem extends StatelessWidget {
  const _LogItem({required this.date, required this.time});

  final String date;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            Row(
              children: [
                Text(
                  time,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const SizedBox(width: 8),
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check, color: Colors.white, size: 16),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}