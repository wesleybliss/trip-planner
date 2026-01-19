import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/trip.dart';
import '../models/place.dart';
import '../services/api_service.dart';

part 'trip_provider.g.dart';

@riverpod
class TripDetails extends _$TripDetails {
  @override
  FutureOr<Trip?> build(int tripId) async {
    final apiService = ApiService();
    return await apiService.getTrip(tripId, withDetails: true);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final apiService = ApiService();
    state = await AsyncValue.guard(() => apiService.getTrip(tripId, withDetails: true));
  }
}

@riverpod
Future<List<Place>> places(Ref ref) async {
  final apiService = ApiService();
  return await apiService.getPlaces();
}
