import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF13B6EC);
    final categories = ['Featured', 'All', 'Learning', 'Exercise', 'Tidying'];

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8F8),
        appBar: AppBar(
          title: Text(
            'Mini-Quests',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF101D22),
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFFF6F8F8),
          elevation: 0,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: primaryColor,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey.shade600,
            labelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
            unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
            tabs: categories.map((String title) => Tab(text: title)).toList(),
          ),
        ),
        body: TabBarView(
          children: categories.map((String category) {
            return _QuestCategoryList(category: category);
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: const Text('Create Custom'),
          icon: const Icon(Icons.add),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

class _QuestCategoryList extends StatelessWidget {
  const _QuestCategoryList({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    // In a real app, you would filter quests based on the category
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSearchBar(),
        const SizedBox(height: 24),
        _buildSection(context, 'Featured'),
        const SizedBox(height: 24),
        _buildSection(context, 'Learning'),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search for templates...',
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.5, // Adjust aspect ratio for card size
          children: [
            _QuestTemplateCard(icon: Icons.auto_stories, title: 'Read 1 page of a book', userCount: '12.3k users'),
            _QuestTemplateCard(icon: Icons.fitness_center, title: 'Do 1 push-up', userCount: '11.8k users'),
            _QuestTemplateCard(icon: Icons.self_improvement, title: 'Stretch for 1 minute', userCount: '9.7k users'),
            _QuestTemplateCard(icon: Icons.bed, title: 'Make your bed', userCount: '8.2k users'),
          ],
        ),
      ],
    );
  }
}

class _QuestTemplateCard extends StatelessWidget {
  const _QuestTemplateCard({
    required this.icon,
    required this.title,
    required this.userCount,
  });

  final IconData icon;
  final String title;
  final String userCount;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF13B6EC);
    return Card(
      elevation: 0.5,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: primaryColor, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.group_outlined, color: Colors.grey.shade600, size: 16),
                const SizedBox(width: 4),
                Text(
                  userCount,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}