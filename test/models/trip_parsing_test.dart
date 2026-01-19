import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/models/trip.dart';

const jsonString = '''
{
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
                },
                {
                    "id": 1318,
                    "updatedAt": "2026-01-15T23:35:03.000Z",
                    "createdAt": "2026-01-15T23:35:03.000Z",
                    "tripId": 39,
                    "planId": 136,
                    "name": "Cartagena, CO",
                    "description": null,
                    "startDate": 1773032400000,
                    "endDate": 1780117200000,
                    "coordsLat": null,
                    "coordsLng": null,
                    "color": "bg-yellow-500",
                    "flightBooked": false,
                    "stayBooked": false,
                    "isShengenRegion": false
                }
            ]
        }
    ]
}
''';

void main() {
  group('Trip and children parsing tests', () {
    test('should parse a trip with details', () {
      final Map<String, dynamic> response = jsonDecode(jsonString);
      
      final trip = Trip.fromJson(response);
      
      expect(trip.id, 39);
      expect(trip.name, '2026');
    });
  });
}
