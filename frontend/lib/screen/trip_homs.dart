import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/repositories/trip_repository.dart';

import '../bloc/export_bloc.dart';
import '../models/models.dart';

class TripHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Home'),
      ),
      body: BlocProvider(
        create: (context) => TripBloc(tripRepository: TripRepository())..add(FetchTripEvent()),
        child: BlocBuilder<TripBloc, TripState>(
          builder: (context, state) {
            if (state is TripLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TripLoaded) {
              return ListView.builder(
                itemCount: state.trips.length,
                itemBuilder: (context, index) {
                  final trip = state.trips[index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(trip.tripName ?? 'No Name'),
                      subtitle: Text(trip.description ?? 'No Description'),
                      trailing: Icon(
                        trip.isDone == true ? Icons.check_circle : Icons.access_time,
                        color: trip.isDone == true ? Colors.green : Colors.red,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TripDetailPage(trip: trip),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (state is TripError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text('No trips found'));
          },
        ),
      ),
    );
  }
}
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
