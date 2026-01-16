import '../models/trip.dart';
import '../models/plan.dart';
import '../models/segment.dart';

class ApiService {
  final String _baseUrl = 'http://localhost:3000/api'; // Replace with your actual API base URL

  // Mock data
  final _mockTrips = [
    Trip(
      id: 1,
      userId: 1,
      name: 'European Adventure',
      description: 'A trip through the heart of Europe.',
      coverImageUrl: 'https://picsum.photos/seed/europe/800/600',
      startDate: DateTime(2024, 8, 15),
      endDate: DateTime(2024, 9, 10),
      segmentCount: 2,
      plans: [
        Plan(
          id: 1,
          tripId: 1,
          name: 'Plan A',
          description: 'The main plan.',
          segments: [
            Segment(
              id: 1,
              tripId: 1,
              planId: 1,
              name: 'Paris',
              startDate: DateTime(2024, 8, 15),
              endDate: DateTime(2024, 8, 25),
              color: '#FF0000',
              flightBooked: true,
              stayBooked: true,
              isShengenRegion: true,
            ),
            Segment(
              id: 2,
              tripId: 1,
              planId: 1,
              name: 'Rome',
              startDate: DateTime(2024, 8, 25),
              endDate: DateTime(2024, 9, 5),
              color: '#0000FF',
              flightBooked: false,
              stayBooked: true,
              isShengenRegion: true,
            ),
          ],
        ),
      ],
    ),
  ];

  Future<List<Trip>> getTrips({bool withCounts = false}) async {
    // For now, return mock data
    return await Future.delayed(const Duration(seconds: 1), () => _mockTrips);
  }

  Future<Trip> getTrip(int id, {bool withDetails = false}) async {
    // For now, return mock data
    return await Future.delayed(const Duration(seconds: 1), () => _mockTrips.first);
  }
}
