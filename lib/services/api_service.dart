import 'dart:developer' as developer;
import 'package:spot_di/spot_di.dart';
import 'package:trip_planner/utils/logger.dart';
import '../domain/io/net/i_dio_client.dart';
import '../models/trip.dart';
import '../models/plan.dart';
import '../models/segment.dart';
import '../models/place.dart';
import '../models/user.dart';
import 'auth_service.dart';

class ApiService {
  final log = Logger("ApiService");
  final IDioClient _dio = spot<IDioClient>();
  final AuthService _auth = spot<AuthService>();

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<User?> getAuthenticatedUser() async {
    try {
      // If we are not signed in to Firebase, return null
      if (_auth.currentUser == null) return null;

      // Call the API's /auth/me endpoint. It should now expect the Firebase ID token
      // which is automatically attached by the DioClient interceptor.
      final response = await _dio.get('/auth/me');
      return User.fromJson(response.data);
    } catch (e) {
      // If API call fails, it might mean the backend user doesn't exist yet or token is invalid.
      // But we still return null to indicate "not successfully authenticated with backend".
      return null;
    }
  }

  Future<List<Trip>> getTrips({bool withCounts = false}) async {
    try {
      final response = await _dio.get('/trips');

      final dynamic data = response.data;
      List<dynamic> list;

      if (data is List) {
        list = data;
      } else if (data is Map && data.containsKey('trips')) {
        list = data['trips'];
      } else if (data is Map && data.containsKey('data')) {
        list = data['data'];
      } else {
        throw Exception('Unexpected response format');
      }

      final trips = list.map((trip) => Trip.fromJson(trip)).toList();
      // developer.log('Fetched trips: $trips', name: 'api_service');
      return trips;
    } catch (e, s) {
      developer.log(
        'Failed to load trips',
        name: 'api_service',
        error: e,
        stackTrace: s,
      );
      throw Exception('Failed to load trips');
    }
  }

  Future<Trip> getTrip(int id, {bool withDetails = false}) async {
    try {
      String url = '/trips/$id';
      if (withDetails) {
        url += '?withDetails=true';
      }
      
      final response = await _dio.get(url);
      return Trip.fromJson(response.data);
    } catch (e) {
      log.e("getTrip", e);
      throw Exception('getTrip: Failed to load trip');
    }
  }

  Future<Trip> createTrip(Trip trip) async {
    try {
      final response = await _dio.post('/trips', data: trip.toJson());
      return Trip.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create trip');
    }
  }

  Future<void> updateTrip(Trip trip) async {
    try {
      await _dio.put('/trips/${trip.id}', data: trip.toJson());
    } catch (e) {
      throw Exception('Failed to update trip');
    }
  }

  Future<void> deleteTrip(int tripId) async {
    try {
      await _dio.delete('/trips/$tripId');
    } catch (e) {
      throw Exception('Failed to delete trip');
    }
  }

  Future<List<Plan>> getPlans(int tripId) async {
    try {
      final response = await _dio.get('/trips/$tripId');
      // log.d('getPlans response: $response');

      final dynamic data = response.data;
      // log.d('getPlans data type: ${data.runtimeType}, value: $data');
      List<dynamic> list;

      // Handle different response formats
      if (data is List) {
        log.d('getPlans: Direct list format');
        list = data;
      } else if (data is Map<String, dynamic>) {
        log.d('getPlans: Map format, keys: ${data.keys}');
        // Check for nested data structure: { "success": true, "data": { "plans": [...] } }
        if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
          log.d('getPlans: Found data key, data keys: ${data['data'].keys}');
          if (data['data'].containsKey('plans')) {
            log.d('getPlans: Found plans in data.data');
            list = data['data']['plans'] as List<dynamic>;
          } else {
            throw Exception('Unexpected response format: data.data missing plans key');
          }
        }
        // Check for direct plans structure: { "plans": [...] }
        else if (data.containsKey('plans')) {
          log.d('getPlans: Found direct plans key');
          list = data['plans'] as List<dynamic>;
        } else {
          throw Exception('Unexpected response format: Missing plans data');
        }
      } else {
        throw Exception('Unexpected response format: Expected List or Map, got ${data.runtimeType}');
      }

      log.d('getPlans: Found ${list.length} plans');
      return list.map((plan) {
        try {
          log.d("PLAN: ${plan['name']}");
          
          try {
            for (var seg in plan['segments']) {
              log.d("SEGMENT: ${seg['name']}");
              Segment.fromJson(seg);
            }
          } catch (x) {
            log.e('Error parsing segments for plan: ${plan['id']}', x);
            rethrow;
          }
          
          return Plan.fromJson(plan);
        } catch (e) {
          log.e('Error parsing plan for trip: ${plan['id']}', e);
          rethrow;
        }
      }).toList();
    } catch (e) {
      log.e('Failed to load plans', e);
      throw Exception('Failed to load plans');
    }
  }

  Future<Plan> getPlan(int planId) async {
    try {
      final response = await _dio.get(
        '/plans/$planId',
      );
      return Plan.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load plan');
    }
  }

  Future<Plan> createPlan(Plan plan) async {
    try {
      final response = await _dio.post(
        '/trips/${plan.tripId}/plans',
        data: plan.toJson(),
      );
      return Plan.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create plan');
    }
  }

  Future<void> updatePlan(Plan plan) async {
    try {
      await _dio.put(
        '/trips/${plan.tripId}/plans/${plan.id}',
        data: plan.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to update plan');
    }
  }

  Future<void> deletePlan(int tripId, int planId) async {
    try {
      await _dio.delete('/trips/$tripId/plans/$planId');
    } catch (e) {
      throw Exception('Failed to delete plan');
    }
  }

  Future<Segment> createSegment(Segment segment) async {
    try {
      final response = await _dio.post(
        '/trips/${segment.tripId}/plans/${segment.planId}/segments',
        data: segment.toJson(),
      );
      return Segment.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create segment');
    }
  }

  Future<void> updateSegment(Segment segment) async {
    try {
      await _dio.put(
        '/trips/${segment.tripId}/plans/${segment.planId}/segments/${segment.id}',
        data: segment.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to update segment');
    }
  }

  Future<void> deleteSegment(Segment segment) async {
    try {
      await _dio.delete(
        '/trips/${segment.tripId}/plans/${segment.planId}/segments/${segment.id}',
      );
    } catch (e) {
      throw Exception('Failed to delete segment');
    }
  }

  Future<List<Place>> getPlaces() async {
    try {
      final response = await _dio.get('/places');

      final dynamic data = response.data;
      List<dynamic> list;

      if (data is List) {
        list = data;
      } else if (data is Map && data.containsKey('places')) {
        list = data['places'];
      } else if (data is Map && data.containsKey('data')) {
        list = data['data'];
      } else {
        throw Exception('Unexpected response format');
      }

      return list.map((place) => Place.fromJson(place)).toList();
    } catch (e) {
      throw Exception('Failed to load placeholder');
    }
  }

  Future<Place> createPlace(Place place) async {
    try {
      final response = await _dio.post('/places', data: place.toJson());
      return Place.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create place');
    }
  }

  Future<Place> updatePlace(Place place) async {
    try {
      final response = await _dio.put(
        '/places/${place.id}',
        data: place.toJson(),
      );
      return Place.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update place');
    }
  }

  Future<void> deletePlace(int placeId) async {
    try {
      await _dio.delete('/places/$placeId');
    } catch (e) {
      throw Exception('Failed to delete place');
    }
  }

  Future<Segment> getSegment(int segmentId) async {
    try {
      final response = await _dio.get('/segments/$segmentId');
      return Segment.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load segment');
    }
  }
}
