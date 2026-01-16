import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trip.dart';
import '../models/plan.dart';
import '../models/segment.dart';
import '../models/place.dart';
import '../models/user.dart';
import '../models/auth_response.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://trip-planner-basic.vercel.app/api';

  ApiService() {
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    }));
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/signup',
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
      final response = await _dio.post(
        '$_baseUrl/auth/signin',
        data: {'email': email, 'password': password},
      );
      final authResponse = AuthResponse.fromJson(response.data);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', authResponse.token);
    } catch (e) {
      throw Exception('Failed to sign in');
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<User?> getAuthenticatedUser() async {
    try {
      final response = await _dio.get('$_baseUrl/auth/me');
      return User.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<List<Trip>> getTrips({bool withCounts = false}) async {
    try {
      final response = await _dio.get('$_baseUrl/trips');
      final trips =
          (response.data as List).map((trip) => Trip.fromJson(trip)).toList();
      developer.log('Fetched trips: $trips', name: 'api_service');
      return trips;
    } catch (e, s) {
      developer.log('Failed to load trips', name: 'api_service', error: e, stackTrace: s);
      throw Exception('Failed to load trips');
    }
  }

  Future<Trip> getTrip(int id, {bool withDetails = false}) async {
    try {
      final response = await _dio.get('$_baseUrl/trips/$id');
      return Trip.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load trip');
    }
  }

  Future<Trip> createTrip(Trip trip) async {
    try {
      final response = await _dio.post('$_baseUrl/trips', data: trip.toJson());
      return Trip.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create trip');
    }
  }

  Future<void> updateTrip(Trip trip) async {
    try {
      await _dio.put('$_baseUrl/trips/${trip.id}', data: trip.toJson());
    } catch (e) {
      throw Exception('Failed to update trip');
    }
  }

  Future<void> deleteTrip(int tripId) async {
    try {
      await _dio.delete('$_baseUrl/trips/$tripId');
    } catch (e) {
      throw Exception('Failed to delete trip');
    }
  }

  Future<List<Plan>> getPlans(int tripId) async {
    try {
      final response = await _dio.get('$_baseUrl/trips/$tripId/plans');
      return (response.data as List).map((plan) => Plan.fromJson(plan)).toList();
    } catch (e) {
      throw Exception('Failed to load plans');
    }
  }

  Future<Plan> getPlan(int planId, {bool withSegments = false}) async {
    try {
      final response = await _dio.get('$_baseUrl/plans/$planId?withSegments=$withSegments');
      return Plan.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load plan');
    }
  }

  Future<Plan> createPlan(Plan plan) async {
    try {
      final response = await _dio
          .post('$_baseUrl/trips/${plan.tripId}/plans', data: plan.toJson());
      return Plan.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create plan');
    }
  }

  Future<void> updatePlan(Plan plan) async {
    try {
      await _dio.put('$_baseUrl/trips/${plan.tripId}/plans/${plan.id}',
          data: plan.toJson());
    } catch (e) {
      throw Exception('Failed to update plan');
    }
  }

  Future<void> deletePlan(int tripId, int planId) async {
    try {
      await _dio.delete('$_baseUrl/trips/$tripId/plans/$planId');
    } catch (e) {
      throw Exception('Failed to delete plan');
    }
  }

  Future<Segment> createSegment(Segment segment) async {
    try {
      final response = await _dio.post(
          '$_baseUrl/trips/${segment.tripId}/plans/${segment.planId}/segments',
          data: segment.toJson());
      return Segment.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create segment');
    }
  }

  Future<void> updateSegment(Segment segment) async {
    try {
      await _dio.put(
          '$_baseUrl/trips/${segment.tripId}/plans/${segment.planId}/segments/${segment.id}',
          data: segment.toJson());
    } catch (e) {
      throw Exception('Failed to update segment');
    }
  }

  Future<void> deleteSegment(Segment segment) async {
    try {
      await _dio.delete(
          '$_baseUrl/trips/${segment.tripId}/plans/${segment.planId}/segments/${segment.id}');
    } catch (e) {
      throw Exception('Failed to delete segment');
    }
  }

  Future<List<Place>> getPlaces() async {
    try {
      final response = await _dio.get('$_baseUrl/places');
      return (response.data as List).map((place) => Place.fromJson(place)).toList();
    } catch (e) {
      throw Exception('Failed to load places');
    }
  }

  Future<Place> createPlace(Place place) async {
    try {
      final response = await _dio.post('$_baseUrl/places', data: place.toJson());
      return Place.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create place');
    }
  }

  Future<Place> updatePlace(Place place) async {
    try {
      final response = await _dio.put('$_baseUrl/places/${place.id}', data: place.toJson());
      return Place.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update place');
    }
  }

  Future<void> deletePlace(int placeId) async {
    try {
      await _dio.delete('$_baseUrl/places/$placeId');
    } catch (e) {
      throw Exception('Failed to delete place');
    }
  }
}
