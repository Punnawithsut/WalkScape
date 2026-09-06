import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_colors.dart';

/// Active Walk Tracker Page
/// Tracks live duration, GPS distance, camera photos, and saves session to Firestore.
class ActiveWalkTrackerPage extends StatefulWidget {
  final String spotName;

  const ActiveWalkTrackerPage({super.key, this.spotName = 'Mindful Walk'});

  @override
  State<ActiveWalkTrackerPage> createState() => _ActiveWalkTrackerPageState();
}

class _ActiveWalkTrackerPageState extends State<ActiveWalkTrackerPage> {
  Timer? _timer;
  int _secondsElapsed = 0;
  bool _isPaused = false;

  double _totalDistanceMeters = 0.0;
  Position? _lastPosition;
  StreamSubscription<Position>? _positionStream;

  final List<String> _capturedPhotoPaths = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _startGpsTracking();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() => _secondsElapsed++);
      }
    });
  }

  void _startGpsTracking() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 3,
      ),
    ).listen((Position position) {
      if (!_isPaused) {
        if (_lastPosition != null) {
          double dist = Geolocator.distanceBetween(
            _lastPosition!.latitude,
            _lastPosition!.longitude,
            position.latitude,
            position.longitude,
          );
          setState(() => _totalDistanceMeters += dist);
        }
        _lastPosition = position;
      }
    });
  }

  void _togglePause() {
    setState(() => _isPaused = !_isPaused);
  }

  Future<void> _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _capturedPhotoPaths.add(photo.path);
      });
    }
  }

  Future<void> _endWalkAndSave() async {
    setState(() => _isSaving = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('walk_logs').add({
          'userId': user.uid,
          'location': widget.spotName,
          'durationSeconds': _secondsElapsed,
          'distanceMeters': _totalDistanceMeters,
          'photoPaths': _capturedPhotoPaths,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Walk saved to Mindfulness Journal!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving walk: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _positionStream?.cancel();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final mins = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final double distKm = _totalDistanceMeters / 1000;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Active Walk - ${widget.spotName}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.forest),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 8),
              _buildMapPlaceholder(),
              const SizedBox(height: 20),
              _buildStatsRow(_formatDuration(_secondsElapsed), '${distKm.toStringAsFixed(2)} km', '${_capturedPhotoPaths.length}'),
              const SizedBox(height: 20),
              _buildMindfulnessPrompt(context),
              const Spacer(),
              _buildActionButtons(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.sage.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _capturedPhotoPaths.isNotEmpty && File(_capturedPhotoPaths.last).existsSync()
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    File(_capturedPhotoPaths.last),
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                )
              : Icon(
                  Icons.map_outlined,
                  size: 64,
                  color: AppColors.forest.withOpacity(0.35),
                ),
          Positioned(
            bottom: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.gps_fixed, size: 18, color: AppColors.leaf),
            ),
          ),
          Positioned(
            top: 14,
            left: 14,
            child: _LiveBadge(isPaused: _isPaused),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(String durationText, String distanceText, String checkpointText) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.timer_outlined,
            label: 'Duration',
            value: durationText,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.directions_walk,
            label: 'Distance',
            value: distanceText,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.self_improvement,
            label: 'Checkpoints',
            value: checkpointText,
          ),
        ),
      ],
    );
  }

  Widget _buildMindfulnessPrompt(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.leaf.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.leaf.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.spa, color: AppColors.forest),
              SizedBox(width: 10),
              Text(
                'Mindfulness Checkpoint',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.forest,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Take a moment. Capture something around you that makes you feel calm — a tree, a flower, the sky.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _openCamera,
              icon: const Icon(Icons.camera_alt_outlined),
              label: Text(_capturedPhotoPaths.isEmpty ? 'Open Camera' : 'Snap Another Photo (${_capturedPhotoPaths.length})'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _togglePause,
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            label: Text(_isPaused ? 'Resume' : 'Pause'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isSaving ? null : _endWalkAndSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.forest,
            ),
            icon: _isSaving
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.flag_outlined),
            label: const Text('End Walk'),
          ),
        ),
      ],
    );
  }
}

class _LiveBadge extends StatelessWidget {
  final bool isPaused;
  const _LiveBadge({this.isPaused = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.forest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: isPaused ? Colors.amber : Colors.redAccent),
          const SizedBox(width: 6),
          Text(
            isPaused ? 'PAUSED' : 'LIVE',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: AppColors.leaf, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.forest,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}