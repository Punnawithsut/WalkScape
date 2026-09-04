import 'package:flutter/material.dart';
import '../app_colors.dart';

/// Mindfulness Journal Page
/// Shows the user's walk history and mindfulness-checkpoint photo gallery,
/// pulled from Firebase Cloud Firestore. UI only — static placeholder data.
class MindfulnessJournalPage extends StatelessWidget {
  const MindfulnessJournalPage({super.key});

  static const List<_JournalEntry> _placeholderEntries = [
    _JournalEntry(
      date: 'Sep 3, 2026',
      location: 'Lumphini Park',
      duration: '24 min',
      photoCount: 3,
    ),
    _JournalEntry(
      date: 'Sep 1, 2026',
      location: 'Benjakitti Forest Park',
      duration: '31 min',
      photoCount: 5,
    ),
    _JournalEntry(
      date: 'Aug 28, 2026',
      location: 'Chao Phraya Riverside Walk',
      duration: '18 min',
      photoCount: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Mindfulness Journal'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: AppColors.forest),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            labelColor: AppColors.forest,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.leaf,
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Walk History'),
              Tab(text: 'Photo Gallery'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _WalkHistoryTab(),
            _PhotoGalleryTab(),
          ],
        ),
      ),
    );
  }
}

class _WalkHistoryTab extends StatelessWidget {
  const _WalkHistoryTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSummaryStrip(),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            itemCount: MindfulnessJournalPage._placeholderEntries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _JournalCard(
                entry: MindfulnessJournalPage._placeholderEntries[index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryStrip() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.leaf,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Expanded(
            child: _SummaryItem(label: 'Total Walks', value: '12'),
          ),
          _VerticalDivider(),
          Expanded(
            child: _SummaryItem(label: 'Total Time', value: '4h 52m'),
          ),
          _VerticalDivider(),
          Expanded(
            child: _SummaryItem(label: 'Photos', value: '31'),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.85),
            fontSize: 11.5,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: Colors.white.withOpacity(0.35),
    );
  }
}

class _JournalEntry {
  final String date;
  final String location;
  final String duration;
  final int photoCount;

  const _JournalEntry({
    required this.date,
    required this.location,
    required this.duration,
    required this.photoCount,
  });
}

class _JournalCard extends StatelessWidget {
  final _JournalEntry entry;
  const _JournalCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.mint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.self_improvement,
                  color: AppColors.leaf, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.location,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                      color: AppColors.forest,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${entry.date} · ${entry.duration}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const Icon(Icons.photo_camera_outlined,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '${entry.photoCount}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoGalleryTab extends StatelessWidget {
  const _PhotoGalleryTab();

  @override
  Widget build(BuildContext context) {
    // Placeholder count representing photos fetched from Firestore/Storage.
    const int placeholderPhotoCount = 9;

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: placeholderPhotoCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.sage.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.image_outlined,
            color: AppColors.forest,
            size: 26,
          ),
        );
      },
    );
  }
}
