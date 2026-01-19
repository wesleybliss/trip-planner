import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/trip.dart';
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
