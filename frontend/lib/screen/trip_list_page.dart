import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/repositories/itempeople_repository.dart';
import 'package:frontend/widgets/detail_page.dart';
import 'package:intl/intl.dart';
import '../bloc/export_bloc.dart';
import '../repositories/trip_repository.dart';
import '../models/trip.dart';

class TripListPage extends StatelessWidget {
  final ItemPeopleRepository itemPeopleRepository = ItemPeopleRepository();
  final TripRepository tripRepository = TripRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ItemPeopleBloc(itemPeopleRepository)..add(FetchItemPeople()),
        ),
        BlocProvider(
          create: (context) =>
              TripBloc(tripRepository: tripRepository)..add(FetchTripEvent()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Trip List',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 32, 86, 137),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: const Color(0xFFF6F7F0),
        body: BlocBuilder<ItemPeopleBloc, ItemPeopleState>(
          builder: (context, itemPeopleState) {
            if (itemPeopleState is ItemPeopleLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (itemPeopleState is ItemPeopleLoaded) {
              return BlocBuilder<TripBloc, TripState>(
                builder: (context, tripState) {
                  if (tripState is TripLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (tripState is TripLoaded) {
                    final List<Trip> trips = tripState.trips
                        .where((trip) {
                          return itemPeopleState.itemPeopleList
                              .any((item) => item.itemId == trip.id);
                        })
                        .cast<Trip>()
                        .toList();

                    return _buildTripList(context, trips);
                  } else if (tripState is TripError) {
                    return Center(child: Text(tripState.message));
                  } else {
                    return const Center(child: Text('No trips found'));
                  }
                },
              );
            } else if (itemPeopleState is ItemPeopleError) {
              return Center(child: Text(itemPeopleState.message));
            } else {
              return const Center(child: Text('Please wait...'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildTripList(BuildContext context, List<Trip> trips) {
    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return _buildTripCard(context, trip);
      },
    );
  }

  Widget _buildTripCard(BuildContext context, Trip trip) {
    DateTime startTime = trip.starttime!;
    DateTime endTime = trip.endtime!;
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
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.network(
                    trip.imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'New',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.tripName!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 32, 86, 137),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.black54),
                      const SizedBox(width: 8),
                      Text(
                        'Start: $formattedStartTime',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.event, color: Colors.black54),
                      const SizedBox(width: 8),
                      Text(
                        'End: $formattedEndTime',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
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
