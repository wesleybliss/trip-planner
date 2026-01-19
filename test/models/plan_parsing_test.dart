import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/models/plan.dart';
import 'package:trip_planner/models/segment.dart';

void main() {
  group('Plan and Segment Parsing Tests', () {
    test('should parse Plan and Segments correctly from typical API response', () {
      const jsonString = '''
      {
        "success": true,
        "data": {
          "id": 39,
          "updatedAt": "2026-01-12T23:31:10.000Z",
          "createdAt": "2026-01-12T23:31:10.000Z",
          "userId": 1,
          "name": "2026",
          "description": "",
          "coverImageUrl": null,
          "plans": [
            {
              "id": 136,
              "updatedAt": "2026-01-12T23:31:10.000Z",
              "createdAt": "2026-01-12T23:31:10.000Z",
              "tripId": 39,
              "name": "January 2026",
              "description": "",
              "segments": [
                {
                  "id": 1314,
                  "updatedAt": "2026-01-12T23:31:11.000Z",
                  "createdAt": "2026-01-12T23:31:11.000Z",
                  "tripId": 39,
                  "planId": 136,
                  "name": "Bogota, CO",
                  "description": "",
                  "startDate": 1767848400000,
                  "endDate": 1770613200000,
                  "coordsLat": null,
                  "coordsLng": null,
                  "color": "bg-slate-500",
                  "flightBooked": false,
                  "stayBooked": false,
                  "isShengenRegion": false
                },
                {
                  "id": 1315,
                  "updatedAt": "2026-01-15T23:30:39.000Z",
                  "createdAt": "2026-01-15T23:30:39.000Z",
                  "tripId": 39,
                  "planId": 136,
                  "name": "NYC/BGA",
                  "description": null,
                  "startDate": 1770613200000,
                  "endDate": 1773032400000,
                  "coordsLat": null,
                  "coordsLng": null,
                  "color": "bg-blue-500",
                  "flightBooked": false,
                  "stayBooked": false,
                  "isShengenRegion": false
                }
              ]
            }
          ]
        }
      }
      ''';

      final Map<String, dynamic> response = jsonDecode(jsonString);
      final List<dynamic> plansJson = response['data']['plans'];
      
      final plans = plansJson.map((p) => Plan.fromJson(p)).toList();
      
      expect(plans.length, 1);
      final plan = plans.first;
      expect(plan.id, 136);
      expect(plan.name, 'January 2026');
      expect(plan.startDate, null, reason: 'Plan dates are null in this response');
      
      expect(plan.segments, isNotNull);
      expect(plan.segments!.length, 2);
      
      final segment = plan.segments!.first;
      expect(segment.id, 1314);
      expect(segment.coordsLat, null);
      expect(segment.coordsLng, null);
      expect(segment.startDate, DateTime.fromMillisecondsSinceEpoch(1767848400000));
    });

    test('Segment.fromJson should handle null coordinates', () {
      final segmentJson = {
        "id": 1,
        "tripId": 39,
        "planId": 136,
        "name": "Test",
        "startDate": 1767848400000,
        "endDate": 1770613200000,
        "coordsLat": null,
        "coordsLng": null,
        "color": "red",
        "flightBooked": false,
        "stayBooked": false,
        "isShengenRegion": false
      };
      
      final segment = Segment.fromJson(segmentJson);
      expect(segment.coordsLat, null);
      expect(segment.coordsLng, null);
    });
    
    test('Plan.fromJson should handle missing dates', () {
      final planJson = {
        "id": 136,
        "tripId": 39,
        "name": "January 2026",
        "description": "",
        "segments": []
      };
      
      final plan = Plan.fromJson(planJson);
      expect(plan.startDate, null);
      expect(plan.endDate, null);
    });
  });
}
