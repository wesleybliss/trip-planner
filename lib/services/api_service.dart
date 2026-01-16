import '../models/trip.dart';
import '../models/plan.dart';
import '../models/segment.dart';
import '../models/place.dart';

class ApiService {
  // ignore: unused_field
  final String _baseUrl = 'http://localhost:3000/api'; // Replace with your actual API base URL

  // Mock data
  final List<Trip> _mockTrips = [
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
              place: Place(id: 1, name: 'Paris, France', type: 'City'),
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
              place: Place(id: 2, name: 'Rome, Italy', type: 'City'),
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
    return await Future.delayed(const Duration(seconds: 1), () => _mockTrips.firstWhere((trip) => trip.id == id));
  }

  Future<Trip> createTrip(Trip trip) async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      final newId = _mockTrips.isNotEmpty ? _mockTrips.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1 : 1;
      final newTrip = trip.copyWith(id: newId);
      _mockTrips.add(newTrip);
    });
    return trip;
  }

  Future<void> updateTrip(Trip trip) async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      final index = _mockTrips.indexWhere((t) => t.id == trip.id);
      if (index != -1) {
        _mockTrips[index] = trip;
      }
    });
  }

  Future<void> deleteTrip(int tripId) async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      _mockTrips.removeWhere((trip) => trip.id == tripId);
    });
  }

  Future<Plan> createPlan(Plan plan) async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      final trip = _mockTrips.firstWhere((trip) => trip.id == plan.tripId);
      final newId = trip.plans?.isNotEmpty ?? false
          ? trip.plans!.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1
          : 1;
      final newPlan = plan.copyWith(id: newId);
      trip.plans?.add(newPlan);
    });
    return plan;
  }

  Future<void> updatePlan(Plan plan) async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      final trip = _mockTrips.firstWhere((trip) => trip.id == plan.tripId);
      final index = trip.plans?.indexWhere((p) => p.id == plan.id) ?? -1;
      if (index != -1) {
        trip.plans?[index] = plan;
      }
    });
  }

  Future<void> deletePlan(int tripId, int planId) async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      final trip = _mockTrips.firstWhere((trip) => trip.id == tripId);
      trip.plans?.removeWhere((plan) => plan.id == planId);
    });
  }

  Future<Segment> createSegment(Segment segment) async {
    late Segment newSegment;
    await Future.delayed(const Duration(milliseconds: 500), () {
      final trip = _mockTrips.firstWhere((trip) => trip.id == segment.tripId);
      final plan = trip.plans?.firstWhere((plan) => plan.id == segment.planId);
      final maxId = plan?.segments?.map((s) => s.id).fold(0, (max, id) => id > max ? id : max) ?? 0;
      final newId = maxId + 1;
      newSegment = segment.copyWith(id: newId);
      plan?.segments?.add(newSegment);
    });
    return newSegment;
  }

  Future<void> updateSegment(Segment segment) async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      final trip = _mockTrips.firstWhere((trip) => trip.id == segment.tripId);
      final plan = trip.plans?.firstWhere((p) => p.id == segment.planId);
      final index = plan?.segments?.indexWhere((s) => s.id == segment.id) ?? -1;
      if (index != -1) {
        plan?.segments?[index] = segment;
      }
    });
  }

  Future<void> deleteSegment(Segment segment) async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      final trip = _mockTrips.firstWhere((trip) => trip.id == segment.tripId);
      final plan = trip.plans?.firstWhere((p) => p.id == segment.planId);
      plan?.segments?.removeWhere((s) => s.id == segment.id);
    });
  }
}
