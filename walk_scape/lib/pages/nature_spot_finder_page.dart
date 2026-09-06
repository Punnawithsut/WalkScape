import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/logout_button.dart';

/// Nature Spot Finder Page
/// Shows nearby green spaces/parks pulled from OpenTripMap based on GPS.
/// UI only — static placeholder data, no API/GPS wiring yet.
class NatureSpotFinderPage extends StatelessWidget {
  const NatureSpotFinderPage({super.key});

  // Placeholder data representing what the API fetcher would return.
  static const List<_NatureSpot> _placeholderSpots = [
    _NatureSpot(
      name: 'Lumphini Park',
      type: 'Public Park',
      distance: '0.8 km',
      icon: Icons.park,
    ),
    _NatureSpot(
      name: 'Benjakitti Forest Park',
      type: 'Urban Forest',
      distance: '1.4 km',
      icon: Icons.forest,
    ),
    _NatureSpot(
      name: 'Chao Phraya Riverside Walk',
      type: 'Riverside Path',
      distance: '2.1 km',
      icon: Icons.water,
    ),
    _NatureSpot(
      name: 'Rot Fai Park',
      type: 'Botanical Garden',
      distance: '3.6 km',
      icon: Icons.local_florist,
    ),
    _NatureSpot(
      name: 'Chulalongkorn Centenary Park',
      type: 'Green Rooftop',
      distance: '4.2 km',
      icon: Icons.eco,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Nature Spots Nearby'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.forest),
            onPressed: () {},
          ),
          const LogoutButton(),
        ],
      ),
      body: Column(
        children: [
          _buildLocationBanner(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              itemCount: _placeholderSpots.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                return _SpotCard(spot: _placeholderSpots[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.sage.withOpacity(0.35),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.my_location, color: AppColors.forest, size: 20),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Using your current location',
              style: TextStyle(
                color: AppColors.forest,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
            ),
            child: const Text('Refresh', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _NatureSpot {
  final String name;
  final String type;
  final String distance;
  final IconData icon;

  const _NatureSpot({
    required this.name,
    required this.type,
    required this.distance,
    required this.icon,
  });
}

class _SpotCard extends StatelessWidget {
  final _NatureSpot spot;
  const _SpotCard({required this.spot});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.mint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(spot.icon, color: AppColors.leaf, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spot.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.forest,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        spot.type,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.circle,
                          size: 4, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          const Icon(Icons.directions_walk,
                              size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 2),
                          Text(
                            spot.distance,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text('Start Walk', style: TextStyle(fontSize: 12.5)),
            ),
          ],
        ),
      ),
    );
  }
}
