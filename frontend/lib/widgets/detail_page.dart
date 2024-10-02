import 'package:flutter/material.dart';

import '../models/models.dart';

class TripDetailPage extends StatelessWidget {
  final Trip trip;
  TripDetailPage({required this.trip});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trip.tripName ?? 'Trip Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ตรวจสอบว่ามี URL ของภาพหรือไม่
            trip.imageUrl != null && trip.imageUrl!.isNotEmpty
                ? Image.network(trip.imageUrl!)
                : Placeholder(
                    fallbackHeight: 200, // กำหนดความสูงของ Placeholder
                    child: Center(child: Text('No Image Available')),
                  ),
            SizedBox(height: 10),
            Text('Description: ${trip.description ?? 'No Description'}'),
            SizedBox(height: 10),
            Text('Start Date: ${trip.starttime?.toIso8601String() ?? 'No Start Time'}'),
            Text('End Date: ${trip.endtime?.toIso8601String() ?? 'No End Time'}'),
            Text('Role: ${trip.role == true ? "Leader" : "Participant"}'),
            SizedBox(height: 10),
            Text(trip.isLate ? 'This trip is late!' : 'This trip is on time!'),
          ],
        ),
      ),
    );
  }
}