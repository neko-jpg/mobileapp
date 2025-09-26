import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PairScreen extends StatefulWidget {
  const PairScreen({super.key});

  @override
  State<PairScreen> createState() => _PairScreenState();
}

class _PairScreenState extends State<PairScreen> {
  bool _isPaired = false;

  void _findPartner() {
    setState(() {
      _isPaired = true;
    });
  }

  void _unpair() {
    setState(() {
      _isPaired = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      appBar: AppBar(
        title: Text(
          'Pair',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF101D22),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_isPaired)
            IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: _unpair, // Simple unpair for demo
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _isPaired
            ? _PairedView(key: const ValueKey('paired'))
            : _UnpairedView(key: const ValueKey('unpaired'), onFindPartner: _findPartner),
      ),
    );
  }
}

class _UnpairedView extends StatelessWidget {
  const _UnpairedView({super.key, required this.onFindPartner});

  final VoidCallback onFindPartner;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF13B6EC);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 20),
        const Icon(Icons.groups_outlined, color: primaryColor, size: 64),
        const SizedBox(height: 16),
        Text(
          'Power Up with a Partner!',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Color(0xFF64748B), height: 1.5),
              children: [
                const TextSpan(text: 'Having an accountability partner increases your chance of success by '),
                TextSpan(
                  text: '95%',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const TextSpan(text: '. Stay anonymous and motivated.'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Other widgets like invite code and random match would go here
        // For brevity, we'll just have the main button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            shadowColor: primaryColor.withOpacity(0.3),
          ),
          onPressed: onFindPartner,
          child: Text(
            'Find a Partner',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _PairedView extends StatelessWidget {
  const _PairedView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF13B6EC);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 64,
            backgroundColor: Color(0xFFE0F7FA),
            child: Icon(Icons.person_off_outlined, size: 64, color: primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            'Anonymous Partner',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Paired for "Meditate" Quest',
            style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(40),
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 8,
              shadowColor: primaryColor.withOpacity(0.4),
            ),
            onPressed: () { /* TODO: Handle High Five */ },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.back_hand_outlined, size: 60),
                SizedBox(height: 8),
                Text('High Five!', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Send a quick message:',
            style: TextStyle(fontSize: 15, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _QuickMessageChip(text: 'You\'re doing great!'),
              _QuickMessageChip(text: 'Keep it up!'),
              _QuickMessageChip(text: 'Let\'s finish strong.'),
              _QuickMessageChip(text: 'I completed my goal!'),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickMessageChip extends StatelessWidget {
  const _QuickMessageChip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF13B6EC);
    return ActionChip(
      label: Text(text),
      onPressed: () { /* TODO: Handle message send */ },
      backgroundColor: Colors.white,
      labelStyle: const TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
      side: BorderSide(color: primaryColor.withOpacity(0.5)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}