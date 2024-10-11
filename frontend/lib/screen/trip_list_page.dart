import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/repositories/trip_repository.dart';
import 'package:intl/intl.dart';
import '../bloc/export_bloc.dart';
import '../models/trip.dart';
import '../widgets/detail_page.dart'; // Import TripDetailPage

class TripListPage extends StatelessWidget {
  const TripListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TripBloc(tripRepository: TripRepository())..add(FetchTripEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Trip List'),
          backgroundColor: Colors.deepPurple,
        ),
        body: BlocBuilder<TripBloc, TripState>(
          builder: (context, state) {
            if (state is TripLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TripLoaded) {
              final List trips = state.trips;

              return ListView.builder(
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  return _buildTripCard(context, trip);
                },
              );
            } else if (state is TripError) {
              return Center(
                child: Text('Error: ${state.message}'),
              );
            } else {
              return const Center(
                child: Text('No trips found.'),
              );
            }
          },
        ),
      ),
    );
  }

  // Card for displaying each trip
  Widget _buildTripCard(BuildContext context, Trip trip) {
    DateTime startTime = trip.starttime!;
    DateTime endTime = trip.endtime!;

    // Format date as needed
    String formattedStartTime = DateFormat('dd MMM yyyy').format(startTime);
    String formattedEndTime = DateFormat('dd MMM yyyy').format(endTime);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TripDetailPage(trip: trip),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                trip.imageUrl ?? 'https://via.placeholder.com/300',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.tripName ?? 'No Name',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$formattedStartTime - $formattedEndTime',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
