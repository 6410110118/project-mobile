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
          title: Text('Trip List'),
        ),
        body: BlocBuilder<ItemPeopleBloc, ItemPeopleState>(
          builder: (context, itemPeopleState) {
            if (itemPeopleState is ItemPeopleLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (itemPeopleState is ItemPeopleLoaded) {
              return BlocBuilder<TripBloc, TripState>(
                builder: (context, tripState) {
                  if (tripState is TripLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (tripState is TripLoaded) {
                    // Ensure the list is properly cast to List<Trip> and filter using itemPeopleList
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
                    return Center(child: Text('No trips found'));
                  }
                },
              );
            } else if (itemPeopleState is ItemPeopleError) {
              return Center(child: Text(itemPeopleState.message));
            } else {
              return Center(child: Text('Please wait...'));
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
        margin: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(trip.imageUrl!),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.tripName!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text('Start: $formattedStartTime'),
                  Text('End: $formattedEndTime'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
