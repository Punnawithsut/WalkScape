import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_colors.dart';
import '../widgets/logout_button.dart';

/// Mindfulness Journal Page
/// Shows walk history & photo gallery streamed live from Firebase Cloud Firestore.
class MindfulnessJournalPage extends StatelessWidget {
  const MindfulnessJournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Mindfulness Journal')),
        body: const Center(
          child: Text('Please log in to view your journal history.'),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('walk_logs')
          .where('userId', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(title: const Text('Mindfulness Journal')),
            body: const Center(child: CircularProgressIndicator(color: AppColors.forest)),
          );
        }

        final docs = snapshot.data?.docs ?? [];
        final entries = docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final int seconds = data['durationSeconds'] ?? 0;
          final int photosCount = (data['photoPaths'] as List?)?.length ?? 0;
          final List<String> photos = List<String>.from(data['photoPaths'] ?? []);

          final DateTime date = (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
          final String formattedDate = '${_getMonthAbbr(date.month)} ${date.day}, ${date.year}';

          return _JournalEntry(
            date: formattedDate,
            location: data['location'] ?? 'Mindful Walk',
            duration: '${seconds ~/ 60} min',
            durationSeconds: seconds,
            photoCount: photosCount,
            photoPaths: photos,
          );
        }).toList();

        final int totalWalks = entries.length;
        final int totalTimeSeconds = entries.fold(0, (sum, item) => sum + item.durationSeconds);
        final int totalPhotos = entries.fold(0, (sum, item) => sum + item.photoCount);

        final String totalTimeStr = '${totalTimeSeconds ~/ 3600}h ${(totalTimeSeconds % 3600) ~/ 60}m';

        final List<String> allPhotos = entries.expand((e) => e.photoPaths).toList();

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text('Mindfulness Journal'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, color: AppColors.forest),
                  onPressed: () => FirebaseAuth.instance.signOut(),
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
            body: TabBarView(
              children: [
                _WalkHistoryTab(
                  entries: entries,
                  totalWalks: '$totalWalks',
                  totalTime: totalTimeStr,
                  totalPhotos: '$totalPhotos',
                ),
                _PhotoGalleryTab(photoPaths: allPhotos),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _getMonthAbbr(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}

class _WalkHistoryTab extends StatelessWidget {
  final List<_JournalEntry> entries;
  final String totalWalks;
  final String totalTime;
  final String totalPhotos;

  const _WalkHistoryTab({
    required this.entries,
    required this.totalWalks,
    required this.totalTime,
    required this.totalPhotos,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSummaryStrip(),
        Expanded(
          child: entries.isEmpty
              ? const Center(
                  child: Text(
                    'No walks logged yet. Start walking!',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _JournalCard(entry: entries[index]);
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
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(label: 'Total Walks', value: totalWalks),
          ),
          const _VerticalDivider(),
          Expanded(
            child: _SummaryItem(label: 'Total Time', value: totalTime),
          ),
          const _VerticalDivider(),
          Expanded(
            child: _SummaryItem(label: 'Photos', value: totalPhotos),
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
  final int durationSeconds;
  final int photoCount;
  final List<String> photoPaths;

  const _JournalEntry({
    required this.date,
    required this.location,
    required this.duration,
    required this.durationSeconds,
    required this.photoCount,
    required this.photoPaths,
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
  final List<String> photoPaths;
  const _PhotoGalleryTab({required this.photoPaths});

  @override
  Widget build(BuildContext context) {
    if (photoPaths.isEmpty) {
      return const Center(
        child: Text('No photos captured yet.', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: photoPaths.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final path = photoPaths[index];
        final fileExists = File(path).existsSync();

        return Container(
          decoration: BoxDecoration(
            color: AppColors.sage.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: fileExists
              ? Image.file(File(path), fit: BoxFit.cover)
              : const Icon(
                  Icons.image_outlined,
                  color: AppColors.forest,
                  size: 26,
                ),
        );
      },
    );
  }
}