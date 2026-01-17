import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spot_di/spot_di.dart';
import '../domain/io/net/i_dio_client.dart';
import '../models/trip.dart';
import '../models/plan.dart';
import '../models/segment.dart';
import '../models/place.dart';
import '../models/user.dart';
import '../models/auth_response.dart';

class ApiService {
  final IDioClient _dio = spot<IDioClient>();

  Future<void> signUp(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/signup',
        data: {'name': name, 'email': email, 'password': password},
      );
      final authResponse = AuthResponse.fromJson(response.data);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', authResponse.token);
    } catch (e) {
      throw Exception('Failed to sign up');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      // 1. Get CSRF Token
      final csrfRes = await _dio.get('/auth/csrf');
      final csrfToken = csrfRes.data['csrfToken'];

      // 2. Sign In
      final response = await _dio.post(
        '/auth/callback/credentials',
        data: {
          'csrfToken': csrfToken,
          'email': email,
          'password': password,
          'json': 'true',
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      // 3. Check for errors in the redirect URL provided by NextAuth
      final url = response.data['url'] as String?;
      if (url != null && url.contains('error=')) {
        throw Exception('Sign in failed');
      }

      // 4. Set dummy token to satisfy app logic (session is in cookies)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', 'session-active');
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<User?> getAuthenticatedUser() async {
    try {
      final response = await _dio.get('/auth/me');
      return User.fromJson(response.data);
    } catch (e) {
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
      developer.log('Fetched trips: $trips', name: 'api_service');
      return trips;
    } catch (e, s) {
      developer.log('Failed to load trips', name: 'api_service', error: e, stackTrace: s);
      throw Exception('Failed to load trips');
    }
  }

  Future<Trip> getTrip(int id, {bool withDetails = false}) async {
    try {
      final response = await _dio.get('/trips/$id');
      return Trip.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load trip');
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
      final response = await _dio.get('/trips/$tripId?withDetails=true');
      
      final dynamic data = response.data;
      List<dynamic> list;
      
      if (data is List) {
        list = data;
      } else if (data is Map && data.containsKey('plans')) {
        list = data['plans'];
      } else if (data is Map && data.containsKey('data')) {
        list = data['data'];
      } else {
        throw Exception('Unexpected response format');
      }

      return list.map((plan) => Plan.fromJson(plan)).toList();
    } catch (e) {
      throw Exception('Failed to load plans');
    }
  }

  Future<Plan> getPlan(int planId, {bool withSegments = false}) async {
    try {
      final response = await _dio.get('/plans/$planId?withSegments=$withSegments');
      return Plan.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load plan');
    }
  }

  Future<Plan> createPlan(Plan plan) async {
    try {
      final response = await _dio
          .post('/trips/${plan.tripId}/plans', data: plan.toJson());
      return Plan.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create plan');
    }
  }

  Future<void> updatePlan(Plan plan) async {
    try {
      await _dio.put('/trips/${plan.tripId}/plans/${plan.id}',
          data: plan.toJson());
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
          data: segment.toJson());
      return Segment.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create segment');
    }
  }

  Future<void> updateSegment(Segment segment) async {
    try {
      await _dio.put(
          '/trips/${segment.tripId}/plans/${segment.planId}/segments/${segment.id}',
          data: segment.toJson());
    } catch (e) {
      throw Exception('Failed to update segment');
    }
  }

  Future<void> deleteSegment(Segment segment) async {
    try {
      await _dio.delete(
          '/trips/${segment.tripId}/plans/${segment.planId}/segments/${segment.id}');
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
      final response = await _dio.put('/places/${place.id}', data: place.toJson());
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
}
