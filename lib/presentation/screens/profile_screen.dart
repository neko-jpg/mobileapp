import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minq/presentation/theme/minq_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: tokens.titleMedium.copyWith(color: tokens.textPrimary),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: tokens.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(tokens.spacing(5)),
        children: <Widget>[
          _buildProfileHeader(tokens),
          SizedBox(height: tokens.spacing(6)),
          _buildStatsRow(tokens),
          SizedBox(height: tokens.spacing(8)),
          _buildAboutSection(tokens),
          SizedBox(height: tokens.spacing(6)),
          _buildMenu(context, tokens),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(MinqTheme tokens) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: tokens.spacing(12),
          backgroundImage: const NetworkImage(
            'https://i.pravatar.cc/150?img=3',
          ),
        ),
        SizedBox(height: tokens.spacing(4)),
        Text(
          'Ethan',
          style: tokens.titleMedium.copyWith(color: tokens.textPrimary),
        ),
        SizedBox(height: tokens.spacing(1)),
        Text(
          '@ethan_123',
          style: tokens.bodySmall.copyWith(color: tokens.textMuted),
        ),
        SizedBox(height: tokens.spacing(2)),
        Text(
          'Joined 2 months ago',
          style: tokens.bodySmall.copyWith(color: tokens.textMuted),
        ),
      ],
    );
  }

  Widget _buildStatsRow(MinqTheme tokens) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const <Widget>[
        _StatItem(label: 'Streak', value: '12'),
        _StatItem(label: 'Pairs', value: '3'),
        _StatItem(label: 'Quests', value: '2'),
      ],
    );
  }

  Widget _buildAboutSection(MinqTheme tokens) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: tokens.spacing(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'About',
            style: tokens.titleSmall.copyWith(color: tokens.textPrimary),
          ),
          SizedBox(height: tokens.spacing(2)),
          Text(
            "I'm a software engineer who loves to code and build things. I'm also a big fan of productivity and habit-building, and I'm excited to be using MinQ to help me achieve my goals.",
            style: tokens.bodySmall.copyWith(
              color: tokens.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu(BuildContext context, MinqTheme tokens) {
    return Card(
      elevation: 0,
      color: tokens.surface,
      shape: RoundedRectangleBorder(borderRadius: tokens.cornerLarge()),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'Edit Profile',
              style: tokens.bodyMedium.copyWith(
                color: tokens.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: tokens.spacing(4),
              color: tokens.textMuted,
            ),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            title: Text(
              'Settings',
              style: tokens.bodyMedium.copyWith(
                color: tokens.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: tokens.spacing(4),
              color: tokens.textMuted,
            ),
            onTap: () => context.go('/settings'),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: tokens.spacing(3),
        horizontal: tokens.spacing(6),
      ),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: tokens.cornerMedium(),
        border: Border.all(color: tokens.brandPrimary.withValues(alpha: 0.18)),
        boxShadow: tokens.shadowSoft,
      ),
      child: Column(
        children: <Widget>[
          Text(
            value,
            style: tokens.titleSmall.copyWith(color: tokens.brandPrimary),
          ),
          SizedBox(height: tokens.spacing(1)),
          Text(
            label,
            style: tokens.bodySmall.copyWith(color: tokens.textMuted),
          ),
        ],
      ),
    );
  }
}
