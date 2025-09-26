import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// Mock data for demonstration
class Quest {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isCompleted;

  Quest({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isCompleted = false,
  });
}

final List<Quest> _todayQuests = [
  Quest(title: 'Read 1 page of a book', subtitle: 'Learning', icon: Icons.auto_stories),
  Quest(title: 'Do 5 push-ups', subtitle: 'Exercise', icon: Icons.fitness_center, isCompleted: true),
  Quest(title: 'Tidy one surface', subtitle: 'Tidying', icon: Icons.countertops),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF13B6EC);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          children: [
            _buildHeader(context),
            const SizedBox(height: 30),
            _buildSectionHeader('Today\'s Quests'),
            const SizedBox(height: 16),
            ..._todayQuests.map((quest) => _QuestCard(quest: quest)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning!',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF101D22),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Ready to build some habits?',
                style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => context.go('/profile'),
            child: const CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'), // Placeholder image
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF101D22),
        ),
      ),
    );
  }
}

class _QuestCard extends StatelessWidget {
  const _QuestCard({required this.quest});

  final Quest quest;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF13B6EC);

    return InkWell(
      onTap: () => context.go('/record'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: quest.isCompleted ? primaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: quest.isCompleted ? Colors.transparent : primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(quest.icon, color: primaryColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quest.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: const Color(0xFF101D22),
                      decoration: quest.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    quest.subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: quest.isCompleted ? primaryColor : Colors.grey.shade300,
                  width: 2,
                ),
                color: quest.isCompleted ? primaryColor : Colors.transparent,
              ),
              child: quest.isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}