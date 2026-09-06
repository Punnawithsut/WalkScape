import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../app_colors.dart';
import 'active_walk_tracker_page.dart';

/// Nature Spot Finder Page
/// Shows nearby green spaces/parks pulled from OpenTripMap based on GPS.
class NatureSpotFinderPage extends StatefulWidget {
  const NatureSpotFinderPage({super.key});

  @override
  State<NatureSpotFinderPage> createState() => _NatureSpotFinderPageState();
}

class _NatureSpotFinderPageState extends State<NatureSpotFinderPage> {
  // Replace with your actual OpenTripMap API Key
  static const String _apiKey = '5ae2e3f221c38a28845f05b6c401b2d9c4a19067ebfc45e74323a0c2';

  List<_NatureSpot> _spots = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNearbySpots();
  }

  Future<void> _fetchNearbySpots() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled on your device.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions were denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final url = Uri.parse(
        'https://api.opentripmap.com/0.1/en/places/radius?radius=5000&lon=${position.longitude}&lat=${position.latitude}&kinds=natural,parks&format=json&apikey=$_apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final fetchedSpots = data
            .where((item) => item['name'] != null && item['name'].toString().trim().isNotEmpty)
            .map((item) {
          final double distMeters = (item['dist'] as num?)?.toDouble() ?? 0.0;
          final String distKm = (distMeters / 1000).toStringAsFixed(1);
          return _NatureSpot(
            name: item['name'] ?? 'Green Space',
            type: 'Park & Nature',
            distance: '$distKm km',
            icon: Icons.park,
          );
        }).toList();

        setState(() {
          _spots = fetchedSpots;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch nature spots from API.');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Nature Spots Nearby'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.forest),
            onPressed: _fetchNearbySpots,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildLocationBanner(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.forest))
                : _errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      )
                    : _spots.isEmpty
                        ? const Center(
                            child: Text(
                              'No nature spots found nearby.',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                            itemCount: _spots.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              return _SpotCard(spot: _spots[index]);
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
            onPressed: _fetchNearbySpots,
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActiveWalkTrackerPage(spotName: spot.name),
                  ),
                );
              },
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